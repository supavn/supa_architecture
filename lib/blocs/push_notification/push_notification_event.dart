part of "push_notification_bloc.dart";

/// Push notification event
sealed class PushNotificationEvent extends Equatable {
  @override
  List<Object?> get props => [
        "PushNotificationEvent",
      ];
}

/// Push notification event when a notification is received
final class DidReceivedNotificationEvent extends PushNotificationEvent {
  /// Push notification event when a notification is received
  final String title;

  /// Push notification event when a notification is received
  final String body;

  /// Push notification event when a notification is received
  final PushNotificationPayload payload;

  /// Push notification event when a notification is received
  final String? linkMobile;

  @override
  List<Object?> get props => [
        "DidReceivedNotificationEvent",
        title,
        body,
        payload,
        linkMobile,
      ];

  /// Push notification event when a notification is received
  DidReceivedNotificationEvent({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });
}

/// Push notification event when the user opened the app
final class DidUserOpenedNotificationEvent extends PushNotificationEvent {
  /// Push notification event when a notification is received
  final String title;

  /// Push notification event when a notification is received
  final String body;

  /// Push notification event when a notification is received
  final PushNotificationPayload payload;

  /// Push notification event when a notification is received
  final String? linkMobile;

  @override
  List<Object?> get props => [
        "DidUserOpenedNotificationEvent",
        title,
        body,
        payload,
        linkMobile,
      ];

  /// Push notification event when the user opened the app
  DidUserOpenedNotificationEvent({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });
}

/// Push notification event when the user reset the app
final class DidResetNotificationEvent extends PushNotificationEvent {
  @override
  List<Object?> get props => [
        "DidResetNotificationEvent",
      ];
}

/// Push notification event to check for initial message when app is mounted
final class DidMountedCheckInitialMessage extends PushNotificationEvent {
  @override
  List<Object?> get props => [
        "DidMountedCheckInitialMessage",
      ];

  /// Push notification event to check for initial message when app is mounted
  DidMountedCheckInitialMessage();
}
