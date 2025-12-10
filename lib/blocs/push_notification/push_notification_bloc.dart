import "dart:async";
import "dart:convert";

import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:supa_architecture/core/device_notification_token.dart";
import "package:supa_architecture/models/user_notification.dart";
import "package:supa_architecture/repositories/utils_notification_repository.dart";
import "package:supa_architecture/supa_architecture_platform_interface.dart";

part "push_notification_event.dart";
part "push_notification_payload.dart";
part "push_notification_state.dart";

/// Manages Firebase Cloud Messaging push notifications.
///
/// This BLoC handles the complete push notification lifecycle including:
/// - Requesting and managing notification permissions
/// - Registering device tokens with the backend
/// - Processing foreground notifications
/// - Handling notification taps and deep links
/// - Managing initial notification when app is launched from terminated state
///
/// The bloc integrates with Firebase Cloud Messaging and maintains
/// notification state for the application.
class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  /// Firebase Messaging instance for push notification operations
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Repository for device token registration on the backend
  final UtilsNotificationRepository _notificationRepository =
      UtilsNotificationRepository();

  /// Subscription for foreground notification messages
  StreamSubscription? _foregroundNotificationSubscription;

  /// Subscription for notification tap events
  StreamSubscription? _notificationOpenSubscription;

  /// Cached Firebase device token to avoid redundant token retrieval
  String? _deviceToken;

  /// Creates a push notification bloc with initial state.
  PushNotificationBloc() : super(const PushNotificationInitial()) {
    _onEvents();
  }

  /// Creates a push notification bloc with an initial notification message.
  ///
  /// Use this constructor when the app was launched by tapping a notification
  /// while it was in a terminated state. The bloc will start in the
  /// [PushNotificationOpened] state if a message is provided.
  ///
  /// **Parameters:**
  /// - [initialMessage]: The notification that launched the app, or null
  PushNotificationBloc.fromInitialMessage(
    RemoteMessage? initialMessage,
  ) : super(
          initialMessage != null
              ? PushNotificationOpened.fromFields(
                  title: initialMessage.title,
                  body: initialMessage.body,
                  payload: initialMessage.payload,
                  linkMobile: initialMessage.linkMobile,
                )
              : const PushNotificationInitial(),
        ) {
    _onEvents();
  }

  void _onEvents() {
    on<DidReceivedNotificationEvent>(_onDidNotificationReceived);
    on<DidUserOpenedNotificationEvent>(_onDidUserOpenedNotification);
    on<DidResetNotificationEvent>(_onDidResetNotification);
    on<DidMountedCheckInitialMessage>(_onDidMountedCheckInitialMessage);
  }

  /// Cleans up notification subscriptions.
  ///
  /// Call this method when disposing the bloc to prevent memory leaks.
  Future<void> onClose() async {
    await _foregroundNotificationSubscription?.cancel();
    await _notificationOpenSubscription?.cancel();
  }

  /// Initializes push notification system with permissions and handlers.
  ///
  /// This method should be called during app initialization. It:
  /// 1. Requests notification permissions from the user
  /// 2. Initializes Firebase Messaging
  /// 3. Registers the device token with the backend
  /// 4. Sets up handlers for foreground and tap notifications
  ///
  /// **Parameters:**
  /// - [appId]: Application identifier for backend registration
  /// - [channelName]: Optional notification channel name for Android
  ///
  /// **Example:**
  /// ```dart
  /// await pushNotificationBloc.initializeNotifications(
  ///   appId: 'my_app',
  ///   channelName: 'General Notifications',
  /// );
  /// ```
  Future<void> initializeNotifications({
    required String appId,
    String? channelName,
  }) async {
    if (!await hasNotificationPermission()) {
      await requestNotificationPermission();
    }

    await _initializeFirebaseMessaging();
    await registerDeviceToken(appId);

    _setForegroundMessageHandler();
    _setNotificationOpenAppHandler();
  }

  /// Checks if the app has been granted notification permissions.
  ///
  /// **Returns:**
  /// - `true` if notifications are authorized, `false` otherwise
  Future<bool> hasNotificationPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Requests notification permissions from the user.
  ///
  /// Shows the system permission dialog to the user. On web, this always
  /// returns false as web notification permissions are not supported.
  ///
  /// **Returns:**
  /// - `true` if the user granted permission, `false` otherwise
  Future<bool> requestNotificationPermission() async {
    if (kIsWeb) return false;
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: true,
      provisional: true,
      announcement: true,
      criticalAlert: true,
      providesAppNotificationSettings: false,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Sets the handler for notifications received in the background.
  ///
  /// This static method must be called in `main.dart` before `runApp()` to
  /// handle notifications that arrive when the app is in the background or
  /// terminated. The handler runs in a separate isolate.
  ///
  /// **Parameters:**
  /// - [handler]: Callback function that processes background notifications
  ///
  /// **Example:**
  /// ```dart
  /// void main() {
  ///   PushNotificationBloc.setBackgroundMessageHandler(
  ///     _firebaseMessagingBackgroundHandler
  ///   );
  ///   runApp(MyApp());
  /// }
  ///
  /// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  ///   print('Handling background message: ${message.messageId}');
  /// }
  /// ```
  static void setBackgroundMessageHandler(
      Future<void> Function(RemoteMessage message) handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  /// Set handler for foreground messages.
  void _setForegroundMessageHandler() {
    if (kIsWeb) return;
    _foregroundNotificationSubscription ??=
        FirebaseMessaging.onMessage.listen(_handleNotification);
  }

  /// Set handler for notifications opened from the background.
  void _setNotificationOpenAppHandler() {
    if (kIsWeb) return;
    _notificationOpenSubscription ??=
        FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedNotification);
  }

  /// Handle incoming foreground notifications.
  void _handleNotification(RemoteMessage message) {
    add(DidReceivedNotificationEvent(
      title: message.title,
      body: message.body,
      payload: message.payload,
      linkMobile: message.linkMobile,
    ));
  }

  /// Handle notifications opened from the background.
  void _handleOpenedNotification(RemoteMessage message) {
    add(DidUserOpenedNotificationEvent(
      title: message.title,
      body: message.body,
      payload: message.payload,
      linkMobile: message.linkMobile,
    ));
  }

  /// Retrieve and store the device token.
  Future<void> _initializeFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();
    _deviceToken = await _firebaseMessaging.getToken();
    debugPrint("FIREBASE_MESSAGING_TOKEN: $_deviceToken");
  }

  /// Registers this device's FCM token with the backend.
  ///
  /// This allows the backend to send push notifications to this specific
  /// device. The method sends device information including OS version,
  /// device ID, model, and the Firebase token.
  ///
  /// **Parameters:**
  /// - [appCode]: Application code for backend identification
  Future<void> registerDeviceToken(String appCode) async {
    if (!await hasNotificationPermission() || _deviceToken == null) return;

    final deviceInfo = SupaArchitecturePlatform.instance.deviceInfo;
    final deviceToken = DeviceNotificationToken(
      osVersion: deviceInfo.systemVersion,
      deviceId: deviceInfo.deviceUuid,
      deviceModel: deviceInfo.deviceModel,
      token: _deviceToken!,
      appCode: appCode,
    );

    try {
      await _notificationRepository.createToken(deviceToken);
    } catch (error) {
      debugPrint("Failed to register device token: ${error.toString()}");
    }
  }

  /// Unregisters this device's FCM token from the backend.
  ///
  /// Call this method when the user logs out or wants to stop receiving
  /// notifications. This removes the device token from the backend database.
  ///
  /// **Parameters:**
  /// - [subSystemId]: Optional subsystem identifier for multi-tenant apps
  /// - [appCode]: Application code for backend identification
  Future<void> unregisterDeviceToken({
    int? subSystemId,
    required String appCode,
  }) async {
    if (!await hasNotificationPermission() || _deviceToken == null) return;

    final deviceInfo = SupaArchitecturePlatform.instance.deviceInfo;

    final deviceToken = DeviceNotificationToken(
      osVersion: deviceInfo.systemVersion,
      deviceId: deviceInfo.deviceUuid,
      deviceModel: deviceInfo.deviceModel,
      token: _deviceToken!,
      subSystemId: subSystemId,
      appCode: appCode,
    );

    try {
      _deviceToken = null;
      await _notificationRepository.deleteToken(deviceToken);
    } catch (error) {
      debugPrint("Failed to unregister device token: ${error.toString()}");
    }
  }

  void _onDidNotificationReceived(
    DidReceivedNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(PushNotificationReceived.fromFields(
      title: event.title,
      body: event.body,
      payload: event.payload,
      linkMobile: event.linkMobile,
    ));
  }

  void _onDidUserOpenedNotification(
    DidUserOpenedNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(PushNotificationOpened.fromFields(
      title: event.title,
      body: event.body,
      payload: event.payload,
      linkMobile: event.linkMobile,
    ));
  }

  void _onDidResetNotification(
    DidResetNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(const PushNotificationInitial());
  }

  void _onDidMountedCheckInitialMessage(
    DidMountedCheckInitialMessage event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        add(DidUserOpenedNotificationEvent(
          title: initialMessage.title,
          body: initialMessage.body,
          payload: initialMessage.payload,
          linkMobile: initialMessage.linkMobile,
        ));
      }
    } catch (error) {
      debugPrint("Failed to get initial message: ${error.toString()}");
    }
  }

  /// Retrieves the notification that launched the app from terminated state.
  ///
  /// This method checks if the app was opened by tapping a notification
  /// while it was completely closed. It returns null if the app was launched
  /// normally or if no notification is available.
  ///
  /// **Returns:**
  /// - A [UserNotification] containing the notification data, or null
  ///
  /// **Example:**
  /// ```dart
  /// final initialNotif = await pushNotificationBloc.getInitialNotification();
  /// if (initialNotif != null) {
  ///   // Handle the notification (e.g., navigate to specific screen)
  ///   navigateToNotificationTarget(initialNotif.linkMobile.value);
  /// }
  /// ```
  Future<UserNotification?> getInitialNotification() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final title = initialMessage.notification?.title ?? '';
      final body = initialMessage.notification?.body ?? '';
      final linkMobile = initialMessage.data['linkMobile'];
      final userNotification = UserNotification()
        ..title.value = title
        ..titleMobile.value = title
        ..content.value = body
        ..contentMobile.value = body
        ..link.value = linkMobile
        ..linkWeb.value = linkMobile
        ..linkMobile.value = linkMobile;
      return userNotification;
    }
    return null;
  }
}

/// Extension methods for convenient access to [RemoteMessage] data.
///
/// Provides simplified getters for commonly accessed notification fields.
extension RemoteMessageExtension on RemoteMessage {
  /// The notification title, or empty string if not available
  String get title => notification?.title ?? "";

  /// The notification body text, or empty string if not available
  String get body => notification?.body ?? "";

  /// The parsed notification payload containing custom data
  PushNotificationPayload get payload => PushNotificationPayload.fromJson(data);

  /// The mobile deep link URL from the notification data
  String? get linkMobile => data["linkMobile"];
}
