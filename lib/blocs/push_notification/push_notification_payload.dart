part of "push_notification_bloc.dart";

/// Contains the data payload from a Firebase Cloud Messaging notification.
///
/// This class parses and stores custom data sent with push notifications,
/// including display text, timestamps, and deep linking information.
class PushNotificationPayload {
  /// Mobile-specific notification title
  final String titleMobile;

  /// Timestamp when the notification was created on the server
  final String createdAt;

  /// Deep link URL for navigating to specific app screens on mobile
  final String linkMobile;

  /// Raw notification data map containing all custom fields
  final Map<String, dynamic>? data;

  /// Creates a notification payload with the specified fields.
  PushNotificationPayload({
    required this.titleMobile,
    required this.createdAt,
    required this.linkMobile,
    this.data,
  });

  /// Creates a [PushNotificationPayload] from JSON data.
  ///
  /// Handles both JSON maps and JSON strings, returning a payload with
  /// empty strings as defaults if parsing fails.
  factory PushNotificationPayload.fromJson(dynamic json) {
    Map<String, dynamic> jsonMap;
    if (json is Map<String, dynamic>) {
      jsonMap = json;
    } else {
      if (json is String) {
        try {
          jsonMap = jsonDecode(json);
        } catch (error) {
          jsonMap = {};
        }
      } else {
        jsonMap = {};
      }
    }

    return PushNotificationPayload(
      titleMobile: jsonMap["titleMobile"] ?? "",
      createdAt: jsonMap["createdAt"] ?? "",
      linkMobile: jsonMap["linkMobile"] ?? "",
      data: jsonMap,
    );
  }

  /// Convert the PushNotificationPayload instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "titleMobile": titleMobile,
      "createdAt": createdAt,
      "linkMobile": linkMobile,
      "data": data,
    };
  }
}
