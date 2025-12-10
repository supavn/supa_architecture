import 'package:dio/dio.dart';
import 'package:supa_architecture/supa_architecture.dart';

/// An interceptor that dynamically modifies the base URL for HTTP requests.
///
/// This interceptor allows the application to use a persistent base URL stored
/// in local storage, enabling dynamic switching between different API environments
/// (e.g., development, staging, production) without requiring app rebuilds.
///
/// **How it works:**
/// 1. Retrieves the stored base API URL from persistent storage
/// 2. Replaces the host of the original request URL with the stored host
/// 3. Preserves the original path and other URL components
///
/// **Use Cases:**
/// - Switching between development and production APIs
/// - Supporting multiple tenants with different API endpoints
/// - Testing against different server environments
///
/// **Example:**
/// ```dart
/// // Original request: https://api.example.com/v1/users
/// // Stored base URL: https://staging.example.com
/// // Final request: https://staging.example.com/v1/users
/// ```
class PersistentUrlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Parse the original base URL to preserve path components
    final baseUri = Uri.parse(options.baseUrl);

    // Get the persistent base URL from storage
    final persistentUri = Uri.parse(persistentStorage.baseApiUrl);

    // Create a new URL with the persistent host but original path
    final modifiedUrl = Uri.parse(options.baseUrl)
        .replace(
          host: persistentUri.host,
          path: baseUri.path,
        )
        .toString();

    // Continue with the modified request
    handler.next(options.copyWith(baseUrl: modifiedUrl));
  }
}
