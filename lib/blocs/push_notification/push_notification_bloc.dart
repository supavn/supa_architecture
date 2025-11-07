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

/// Push notification BLoC for handling push notifications.
class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final UtilsNotificationRepository _notificationRepository =
      UtilsNotificationRepository();

  StreamSubscription? _foregroundNotificationSubscription;
  StreamSubscription? _notificationOpenSubscription;

  /// Stores the last retrieved Firebase token to avoid redundant network calls.
  String? _deviceToken;

  PushNotificationBloc() : super(const PushNotificationInitial()) {
    _onEvents();
  }

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

  Future<void> onClose() async {
    await _foregroundNotificationSubscription?.cancel();
    await _notificationOpenSubscription?.cancel();
  }

  /// Initialize push notifications.
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

  /// Check if the app has notification permissions.
  Future<bool> hasNotificationPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Request notification permissions.
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

  /// Set background message handler (should be called from `main.dart`).
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

  /// Register device token for push notifications.
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

  /// Unregister device token for push notifications.
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

extension RemoteMessageExtension on RemoteMessage {
  String get title => notification?.title ?? "";
  String get body => notification?.body ?? "";
  PushNotificationPayload get payload => PushNotificationPayload.fromJson(data);
  String? get linkMobile => data["linkMobile"];
}
