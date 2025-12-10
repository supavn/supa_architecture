part of 'api_client.dart';

/// Extension on [DioException] that provides convenient HTTP status code checks.
///
/// This extension adds boolean getters to easily identify common HTTP error responses
/// without manually checking status codes throughout the application.
///
/// **Usage Example:**
/// ```dart
/// try {
///   await dio.get('/api/endpoint');
/// } catch (e) {
///   if (e is DioException) {
///     if (e.isUnauthorized) {
///       // Handle 401 error
///     } else if (e.isForbidden) {
///       // Handle 403 error
///     }
///   }
/// }
/// ```
extension SupaDioException on DioException {
  /// Returns `true` if the response status code is 403 (Forbidden).
  ///
  /// Indicates that the server understood the request but refuses to authorize it.
  bool get isForbidden {
    return response?.statusCode == 403;
  }

  /// Returns `true` if the response status code is 404 (Not Found).
  ///
  /// Indicates that the requested resource could not be found on the server.
  bool get isNotFound {
    return response?.statusCode == 404;
  }

  /// Returns `true` if the response status code is 401 (Unauthorized).
  ///
  /// Indicates that the request requires authentication or the authentication failed.
  bool get isUnauthorized {
    return response?.statusCode == 401;
  }

  /// Returns `true` if the response status code is 400 (Bad Request).
  ///
  /// Indicates that the server cannot process the request due to client error
  /// (e.g., malformed request syntax, invalid parameters).
  bool get isBadRequest {
    return response?.statusCode == 400;
  }
}
