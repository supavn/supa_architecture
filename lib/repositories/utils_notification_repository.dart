import "package:dio/dio.dart";
import "package:supa_architecture/api_client/api_client.dart";
import "package:supa_architecture/core/device_notification_token.dart";
import "package:supa_architecture/filters/filters.dart";
import "package:supa_architecture/models/models.dart";
import "package:supa_architecture/repositories/base_repository.dart";

/// A repository class for managing user notifications.
///
/// This class extends [BaseRepository] and provides methods for handling
/// various notification tasks such as creating and deleting notification tokens,
/// listing read and unread notifications, counting read and unread notifications,
/// and marking notifications as read.
class UtilsNotificationRepository
    extends BaseRepository<UserNotification, UserNotificationFilter> {
  UtilsNotificationRepository({
    super.shouldUseDeviceInfo = true,
    super.shouldUsePersistentUrl,
  });

  @override
  String get baseUrl => Uri.parse(persistentStorage.baseApiUrl)
      .replace(
        path: "/rpc/utils-notification/notification",
      )
      .toString();

  Options _getTokenHeaders(DeviceNotificationToken deviceNotificationToken) {
    return Options(
      headers: {
        'X-Device-UUID': deviceNotificationToken.deviceId,
      },
    );
  }

  /// Creates a notification token for the device.
  ///
  /// **Parameters:**
  /// - `deviceNotificationToken`: The [DeviceNotificationToken] to create.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating the success of the operation.
  Future<bool> createToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          "/create-token",
          data: deviceNotificationToken.toJson(),
          options: _getTokenHeaders(deviceNotificationToken),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Deletes a notification token for the device.
  ///
  /// **Parameters:**
  /// - `deviceNotificationToken`: The [DeviceNotificationToken] to delete.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating the success of the operation.
  Future<bool> deleteToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          "/delete-token",
          data: deviceNotificationToken.toJson(),
          options: _getTokenHeaders(deviceNotificationToken),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Lists read notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the read notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [UserNotification]s.
  Future<List<UserNotification>> listRead(UserNotificationFilter filter) async {
    return dio
        .post(
          "/list-read",
          data: filter.toJson(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  /// Lists unread notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the unread notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [UserNotification]s.
  Future<List<UserNotification>> listUnread(
      UserNotificationFilter filter) async {
    return dio
        .post(
          "/list-unread",
          data: filter.toJson(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  /// Counts read notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the read notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of read notifications.
  Future<int> countRead(UserNotificationFilter filter) async {
    return dio
        .post(
          "/count-read",
          data: filter.toJson(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  /// Counts unread notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the unread notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of unread notifications.
  Future<int> countUnread(UserNotificationFilter filter) async {
    return dio
        .post(
          "/count-unread",
          data: filter.toJson(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  /// Marks a notification as read.
  ///
  /// **Parameters:**
  /// - `userNotification`: The [UserNotification] to mark as read.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a string response.
  Future<String> read(UserNotification userNotification) async {
    return dio
        .post(
          "/read",
          data: userNotification.toJson(),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Marks all notifications as read.
  ///
  /// **Returns:**
  /// - A [Future] that completes when all notifications are marked as read.
  Future<void> readAll() async {
    return dio.post(
      "/read-all",
      data: {},
    ).then(
      (response) => response.data,
    );
  }
}
