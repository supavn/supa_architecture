import "package:supa_architecture/api_client/api_client.dart";
import "package:supa_architecture/models/models.dart";

/// A repository class for managing user profiles.
///
/// This class extends [ApiClient] and provides methods for handling various
/// profile-related tasks such as switching email, switching notification
/// settings, obtaining OTP, and changing passwords.
class PortalProfileRepository extends ApiClient {
  @override
  String get baseUrl => Uri.parse(persistentStorage.baseApiUrl)
      .replace(
        path: "/rpc/portal/profile",
      )
      .toString();

  /// Switches the email of the specified user.
  ///
  /// **Parameters:**
  /// - `user`: The [AppUser] whose email is to be switched.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the updated [AppUser].
  Future<AppUser> switchEmail(AppUser user) async {
    user.receivingSystemEmail.value = !user.receivingSystemEmail.value;
    return dio
        .post(
          "/switch-email",
          data: user.toJson(),
        )
        .then(
          (response) => response.body<AppUser>(),
        );
  }

  /// Switches the notification settings of the specified user.
  ///
  /// **Parameters:**
  /// - `user`: The [AppUser] whose notification settings are to be switched.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the updated [AppUser].
  Future<AppUser> switchNotification(AppUser user) async {
    user.receivingSystemNotification.value =
        !user.receivingSystemNotification.value;
    return dio
        .post(
          "/switch-notification",
          data: user.toJson(),
        )
        .then(
          (response) => response.body<AppUser>(),
        );
  }

  /// Retrieves an OTP.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the OTP is retrieved.
  Future<void> getOtp() async {
    return dio.post(
      "/get-otp",
      data: {},
    ).then(
      (response) => response.data,
    );
  }

  /// Changes the password using OTP verification.
  ///
  /// **Parameters:**
  /// - `oldPassword`: The current password.
  /// - `newPassword`: The new password.
  /// - `verifyNewPassword`: The new password verification.
  /// - `otpCode`: The OTP code for verification.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the password is changed.
  Future<void> changePasswordOtp({
    required String? password,
    required String? newPassword,
    required String? verifyNewPassword,
    required String? otpCode,
  }) async {
    return dio.post(
      "/change-password-otp",
      data: {
        "password": password,
        "newPassword": newPassword,
        "verifyNewPassword": verifyNewPassword,
        "otpCode": otpCode,
      },
    ).then(
      (response) => response.data,
    );
  }

  Future<List<Language>> singleListLanguage(LanguageFilter filter) async {
    return dio
        .post(
          "/single-list-language",
          data: filter.toJson(),
        )
        .then(
          (response) => response.bodyAsList<Language>(),
        );
  }

  Future<AppUser> updateLanguage(AppUser user) async {
    return dio
        .post(
          "/update-language",
          data: user.toJson(),
        )
        .then(
          (response) => response.body<AppUser>(),
        );
  }

  Future<AppUser> linkGoogleAccount(String idToken) async {
    return dio.post(
      "/link-google-account",
      data: {
        "idToken": idToken,
      },
    ).then(
      (response) => response.body<AppUser>(),
    );
  }

  Future<AppUser> linkMicrosoftAccount(String idToken) async {
    return dio.post(
      "/link-microsoft-account",
      data: {
        "idToken": idToken,
      },
    ).then(
      (response) => response.body<AppUser>(),
    );
  }

  Future<AppUser> linkAppleAccount(String idToken) async {
    return dio.post(
      "/link-apple-account",
      data: {
        "idToken": idToken,
      },
    ).then(
      (response) => response.body<AppUser>(),
    );
  }

  Future<AppUser> unlinkGoogleAccount() async {
    return dio.post(
      "/unlink-google-account",
      data: {},
    ).then(
      (response) => response.body<AppUser>(),
    );
  }

  Future<AppUser> unlinkMicrosoftAccount() async {
    return dio.post(
      "/unlink-microsoft-account",
      data: {},
    ).then(
      (response) => response.body<AppUser>(),
    );
  }

  Future<AppUser> unlinkAppleAccount() async {
    return dio.post(
      "/unlink-apple-account",
      data: {},
    ).then(
      (response) => response.body<AppUser>(),
    );
  }
}
