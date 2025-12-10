part of "push_notification_bloc.dart";

/// Base class for all push notification events.
sealed class PushNotificationEvent extends Equatable {
  @override
  List<Object?> get props => [
        "PushNotificationEvent",
      ];
}

/// Event triggered when a push notification is received in the foreground.
///
/// This event is fired when the app is open and actively running, and
/// a notification arrives. It allows the app to display in-app notification UI.
final class DidReceivedNotificationEvent extends PushNotificationEvent {
  /// The notification title text
  final String title;

  /// The notification body text
  final String body;

  /// Additional notification data payload
  final PushNotificationPayload payload;

  /// Optional deep link URL for mobile navigation
  final String? linkMobile;

  @override
  List<Object?> get props => [
        "DidReceivedNotificationEvent",
        title,
        body,
        payload,
        linkMobile,
      ];

  /// Creates a notification received event with the given notification data.
  DidReceivedNotificationEvent({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });
}

/// Event triggered when user taps on a notification.
///
/// This event is fired when the user interacts with a notification
/// (either from the system tray or as a foreground notification banner),
/// causing the app to open or come to the foreground.
final class DidUserOpenedNotificationEvent extends PushNotificationEvent {
  /// The notification title text
  final String title;

  /// The notification body text
  final String body;

  /// Additional notification data payload
  final PushNotificationPayload payload;

  /// Optional deep link URL for mobile navigation
  final String? linkMobile;

  @override
  List<Object?> get props => [
        "DidUserOpenedNotificationEvent",
        title,
        body,
        payload,
        linkMobile,
      ];

  /// Creates a notification opened event with the given notification data.
  DidUserOpenedNotificationEvent({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });
}

/// Event to reset notification state to initial.
///
/// Use this event to clear any displayed notification or reset the
/// notification state after handling it.
final class DidResetNotificationEvent extends PushNotificationEvent {
  @override
  List<Object?> get props => [
        "DidResetNotificationEvent",
      ];
}

/// Event to check for notifications that launched the app.
///
/// This event should be triggered when the app finishes mounting its UI.
/// It checks if the app was launched by tapping a notification while
/// the app was completely terminated.
final class DidMountedCheckInitialMessage extends PushNotificationEvent {
  @override
  List<Object?> get props => [
        "DidMountedCheckInitialMessage",
      ];

  /// Creates a check initial message event.
  DidMountedCheckInitialMessage();
}
