part of "push_notification_bloc.dart";

/// Base notification data that is shared between different notification states
class NotificationData {
  /// Notification title
  final String title;

  /// Notification body
  final String body;

  /// Notification payload
  final PushNotificationPayload payload;

  /// Mobile link for the notification
  final String? linkMobile;

  /// Creates a notification data instance
  const NotificationData({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });

  /// Converts the notification data to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "payload": payload.toJson(),
      "linkMobile": linkMobile,
    };
  }

  /// Creates a notification data instance from JSON
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      payload: PushNotificationPayload.fromJson(json["payload"] ?? {}),
      linkMobile: json["linkMobile"],
    );
  }

  /// Creates a copy of this notification data with the given fields replaced
  NotificationData copyWith({
    String? title,
    String? body,
    PushNotificationPayload? payload,
    String? linkMobile,
  }) {
    return NotificationData(
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      linkMobile: linkMobile ?? this.linkMobile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationData &&
        other.title == title &&
        other.body == body &&
        other.payload == payload &&
        other.linkMobile == linkMobile;
  }

  UserNotification toUserNotification() {
    return UserNotification()
      ..title.value = title
      ..titleWeb.value = title
      ..titleMobile.value = title
      ..content.value = body
      ..contentWeb.value = body
      ..contentMobile.value = body
      ..link.value = linkMobile
      ..linkWeb.value = linkMobile
      ..linkMobile.value = linkMobile;
  }

  @override
  int get hashCode {
    return Object.hash(title, body, payload, linkMobile);
  }
}

/// Push notification state
sealed class PushNotificationState {
  const PushNotificationState();

  /// Converts the state to a JSON map.
  ///
  /// **Returns:**
  /// - A Map\<String, dynamic\> representing the state in JSON format.
  Map<String, dynamic> toJson();
}

/// Push notification initial state
final class PushNotificationInitial extends PushNotificationState {
  /// Push notification initial state
  const PushNotificationInitial();

  @override
  Map<String, dynamic> toJson() {
    return {"type": "initial"};
  }
}

/// Push notification received state for data-only messages.
///
/// Represents a RemoteMessage that does **not** contain a `notification`
/// object, and only provides `data` payload.
final class PushNotificationDataOnlyReceived extends PushNotificationState {
  /// Parsed notification payload data
  final PushNotificationPayload payload;

  /// Optional deep link URL for mobile navigation
  final String? linkMobile;

  /// Push notification received state for data-only messages
  const PushNotificationDataOnlyReceived({
    required this.payload,
    this.linkMobile,
  });

  /// Converts to opened data-only notification event
  DidUserOpenedDataOnlyNotificationEvent toOpenedEvent() {
    return DidUserOpenedDataOnlyNotificationEvent(
      payload: payload,
      linkMobile: linkMobile,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "data_only_received",
      "payload": payload.toJson(),
      "linkMobile": linkMobile,
    };
  }
}

/// Push notification received state
final class PushNotificationReceived extends PushNotificationState {
  /// Notification data
  final NotificationData data;

  /// Push notification received state
  const PushNotificationReceived({
    required this.data,
  });

  /// Creates a received state from individual notification fields
  factory PushNotificationReceived.fromFields({
    required String title,
    required String body,
    required PushNotificationPayload payload,
    String? linkMobile,
  }) {
    return PushNotificationReceived(
      data: NotificationData(
        title: title,
        body: body,
        payload: payload,
        linkMobile: linkMobile,
      ),
    );
  }

  /// Converts to opened notification event
  DidUserOpenedNotificationEvent toOpenedEvent() {
    return DidUserOpenedNotificationEvent(
      title: data.title,
      body: data.body,
      payload: data.payload,
      linkMobile: data.linkMobile,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "received",
      "data": data.toJson(),
    };
  }
}

/// Push notification opened state for data-only messages.
///
/// Represents a RemoteMessage that does **not** contain a `notification`
/// object, and only provides `data` payload.
final class PushNotificationDataOnlyOpened extends PushNotificationState {
  /// Parsed notification payload data
  final PushNotificationPayload payload;

  /// Optional deep link URL for mobile navigation
  final String? linkMobile;

  /// Push notification opened state for data-only messages
  const PushNotificationDataOnlyOpened({
    required this.payload,
    this.linkMobile,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "data_only_opened",
      "payload": payload.toJson(),
      "linkMobile": linkMobile,
    };
  }
}

/// Push notification opened state
final class PushNotificationOpened extends PushNotificationState {
  /// Notification data
  final NotificationData data;

  /// Push notification opened state
  const PushNotificationOpened({
    required this.data,
  });

  /// Creates an opened state from individual notification fields
  factory PushNotificationOpened.fromFields({
    required String title,
    required String body,
    required PushNotificationPayload payload,
    String? linkMobile,
  }) {
    return PushNotificationOpened(
      data: NotificationData(
        title: title,
        body: body,
        payload: payload,
        linkMobile: linkMobile,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "opened",
      "data": data.toJson(),
    };
  }
}

/// Push notification error state
final class PushNotificationError extends PushNotificationState {
  /// Error message
  final String message;

  /// Error code (optional)
  final String? code;

  /// Original notification data if available
  final NotificationData? originalData;

  /// Push notification error state
  const PushNotificationError({
    required this.message,
    this.code,
    this.originalData,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "error",
      "message": message,
      "code": code,
      "originalData": originalData?.toJson(),
    };
  }
}
