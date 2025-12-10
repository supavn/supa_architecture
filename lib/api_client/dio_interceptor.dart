import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supa_architecture/api_client/interceptors/persistent_url_interceptor.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

/// Extension on [Dio] that provides convenient methods for adding common interceptors.
///
/// This extension simplifies the process of adding frequently used interceptors
/// to Dio instances, with platform-specific behavior for web and native platforms.
///
/// **Usage Example:**
/// ```dart
/// final dio = Dio();
/// dio.addCookieStorageInterceptor(); // Adds cookie management (native only)
/// dio.addBaseUrlInterceptor();       // Adds persistent URL handling (native only)
/// ```
extension DioInterceptorExtension on Dio {
  /// Adds a cookie storage interceptor to the Dio instance.
  ///
  /// This method adds an interceptor that automatically manages cookies for HTTP requests.
  /// The interceptor is only added on non-web platforms, as web browsers handle
  /// cookie management automatically.
  ///
  /// **Platform Support:**
  /// - **Native (iOS/Android):** Adds the cookie storage interceptor
  /// - **Web:** No-op, as browsers handle cookies natively
  void addCookieStorageInterceptor() {
    if (!kIsWeb) {
      interceptors
          .add(SupaArchitecturePlatform.instance.cookieStorage.interceptor);
    }
  }

  /// Adds a base URL interceptor to the Dio instance.
  ///
  /// This method adds an interceptor that handles persistent URL configuration,
  /// allowing dynamic base URL changes from stored settings. This is particularly
  /// useful for apps that need to switch between different API environments.
  ///
  /// **Platform Support:**
  /// - **Native (iOS/Android):** Adds the persistent URL interceptor
  /// - **Web:** No-op, as web apps typically use fixed base URLs
  void addBaseUrlInterceptor() {
    if (!kIsWeb) {
      interceptors.add(PersistentUrlInterceptor());
    }
  }
}
