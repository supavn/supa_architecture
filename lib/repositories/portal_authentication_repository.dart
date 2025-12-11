import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/api_client/api_client.dart';
import 'package:supa_architecture/api_client/dio_interceptor.dart';
import 'package:supa_architecture/core/app_token.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/core/secure_authentication_info.dart';
import 'package:supa_architecture/core/tenant_authentication.dart';
import 'package:supa_architecture/filters/filters.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/utils/platform_utils.dart';

/// Repository for managing portal authentication operations.
///
/// This class extends [ApiClient] and provides methods for user login,
/// logout, token management, profile retrieval, and more.
class PortalAuthenticationRepository extends ApiClient {
  Uri get authenticationUri => Uri.parse(persistentStorage.baseApiUrl)
      .replace(path: '/rpc/portal/mobile/authentication');

  @override
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();

  /// The base URL for the API.
  @override
  String get baseUrl => authenticationUri.toString();

  /// Changes the saved tenant in persistent storage.
  ///
  /// **Parameters:**
  /// - `tenant`: The tenant to be saved.
  void changeSavedTenant(CurrentTenant tenant) {
    persistentStorage.tenant = tenant;
  }

  /// Creates a token for the specified tenant.
  ///
  /// **Parameters:**
  /// - `tenant`: The tenant for which the token is to be created.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the token is created.
  Future<String?> createToken(Tenant tenant) async {
    return dio
        .post(
          '/create-token',
          data: tenant.toJson(),
        )
        .then((response) => response.data?.toString());
  }

  /// Retrieves the profile of the authenticated user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the authenticated [AppUser].
  @Deprecated('Due to change of backend authentication')
  Future<AppUser> getProfile() async {
    final url = Uri.parse(baseUrl)
        .replace(
          path: '/rpc/portal/app-user-profile/get',
        )
        .toString();
    return dio.post(url, data: {}).then(
      (response) {
        response.data['id'] = response.data['userId'];
        return response.body<AppUser>();
      },
    );
  }

  Future<AppUser> getProfileInfo() async {
    final url = Uri.parse(baseUrl)
        .replace(
          path: '/rpc/portal/profile/get-info',
        )
        .toString();
    return dio.post(url, data: {}).then(
      (response) {
        final appUserInfo = response.body<AppUserInfo>();
        return appUserInfo.toAppUser();
      },
    );
  }

  Future<AppUser> updateProfileInfo(AppUser appUser) async {
    final url = Uri.parse(baseUrl)
        .replace(
          path: '/rpc/portal/profile/update-info',
        )
        .toString();
    return dio.post(url, data: appUser.toJson()).then(
      (response) {
        response.data['id'] = response.data['userId'];
        return response.body<AppUser>();
      },
    );
  }

  /// Lists the tenants associated with the authenticated user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> listTenant({
    TenantFilter? filter,
  }) async {
    return dio
        .post(
          '/list-tenant',
          data: filter?.toJson() ?? {},
        )
        .then(
          (response) => response.bodyAsList<Tenant>(),
        );
  }

  /// Counts the number of tenants associated with the authenticated user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the number of tenants.
  Future<int> countTenant() async {
    return dio.post(
      '/count-tenant',
      data: {},
    ).then(
      (response) => (response.data as num).toInt(),
    );
  }

  /// Loads the authentication details from persistent storage.
  ///
  /// **Returns:**
  /// - A [TenantAuthentication] object if authentication details are found, otherwise `null`.
  Future<TenantAuthentication?> loadAuthentication() async {
    final tenant = persistentStorage.tenant;
    final appUser = persistentStorage.appUser;

    if (tenant != null && appUser != null) {
      return TenantAuthentication(tenant, appUser);
    }

    return null;
  }

  /// Logs in the user using username and password.
  ///
  /// **Parameters:**
  /// - `username`: The username of the user.
  /// - `password`: The password of the user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> login(
    String username,
    String password,
  ) async {
    return dio.post(
      '/login',
      data: {
        'username': username,
        'password': password,
        'osName': kIsWeb
            ? 'WEB'
            : PlatformUtils.select(
                android: 'Android',
                ios: 'iOS',
                macos: 'macOS',
                fallback: 'Web',
              ),
      },
    ).then((response) {
      return response.bodyAsList<Tenant>();
    });
  }

  /// Logs in the user using Apple ID.
  ///
  /// **Parameters:**
  /// - `idToken`: The ID token from Apple.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> loginWithApple(String idToken) async {
    return dio.post(
      '/apple-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Logs in the user using biometric authentication.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> loginWithBiometric() async {
    await refreshToken();
    return listTenant();
  }

  /// Logs in the user using Google account.
  ///
  /// **Parameters:**
  /// - `idToken`: The ID token from Google.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> loginWithGoogle(String idToken) async {
    return dio.post(
      '/google-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Logs in the user using Microsoft account.
  ///
  /// **Parameters:**
  /// - `idToken`: The ID token from Microsoft.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> loginWithMicrosoft(String idToken) async {
    return dio.post(
      '/microsoft-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Logs out the user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating whether the logout was successful.
  Future<dynamic> logout() async {
    try {
      await _removePersistentAuthentication();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return dio.post(
      '/logout',
      data: {},
    ).then((response) => response.data);
  }

  /// Refreshes the authentication token.
  ///
  /// **Parameters:**
  /// - `refreshToken`: The refresh token.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the token is refreshed.
  Future<void> refreshToken({String? refreshToken}) async {
    final dio = Dio();
    dio.addCookieStorageInterceptor();
    dio.addBaseUrlInterceptor();

    final refreshTokenUrl = Uri.parse(persistentStorage.baseApiUrl)
        .replace(path: '/rpc/portal/authentication/refresh-token')
        .toString();

    return dio
        .post(
          refreshTokenUrl,
          data: {},
          options: Options(
            headers: refreshToken != null
                ? {'cookie': 'RefreshToken=$refreshToken'}
                : null,
          ),
        )
        .then((response) => response.data);
  }

  /// Saves the authentication information.
  ///
  /// **Parameters:**
  /// - `appUser`: The authenticated user.
  /// - `tenant`: The authenticated tenant.
  Future<void> saveAuthentication(AppUser appUser, CurrentTenant tenant) async {
    // Persist tenant and appUser across all platforms (web and native)
    persistentStorage.tenant = tenant;
    persistentStorage.appUser = appUser;

    // Try to capture tokens from cookies (available on both web and native if set)
    final cookies = cookieStorage.loadCookies(authenticationUri);

    final accessToken = cookies.firstWhere(
      (cookie) => cookie.name == AppToken.accessTokenKey,
      orElse: () => Cookie(AppToken.accessTokenKey, ''),
    );
    final refreshToken = cookies.firstWhere(
      (cookie) => cookie.name == AppToken.refreshTokenKey,
      orElse: () => Cookie(AppToken.refreshTokenKey, ''),
    );

    final SecureAuthenticationInfo authInfo = SecureAuthenticationInfo(
      refreshToken: refreshToken.value,
      accessToken: accessToken.value.isEmpty ? null : accessToken.value,
      tenantId: tenant.id.value,
    );
    await secureStorage.saveAuthenticationInfo(authInfo);
  }

  /// Removes the authentication information.
  Future<void> _removePersistentAuthentication() async {
    persistentStorage.removeAppUser();
    persistentStorage.removeTenant();
  }

  /// Initiates the forgot password process.
  ///
  /// **Parameters:**
  /// - `email`: The email of the user.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a string message.
  Future<String> forgotPassword(
    String email,
  ) async {
    return dio.post('/forgot-password', data: {
      'email': email,
    }).then((response) => response.data);
  }

  /// Completes the forgot password process using OTP.
  ///
  /// **Parameters:**
  /// - `content`: The content of the request.
  /// - `password`: The new password.
  /// - `otpCode`: The OTP code.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant].
  Future<List<Tenant>> forgotPasswordOtp(
    String content,
    String password,
    String otpCode,
  ) async {
    return dio.post('/forgot-with-otp', data: {
      'content': content,
      'password': password,
      'otpCode': otpCode,
    }).then((response) => response.bodyAsList<Tenant>());
  }
}
