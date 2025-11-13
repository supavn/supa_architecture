import "dart:async";

import "package:dio/dio.dart";
import "package:get_it/get_it.dart";
import "package:supa_architecture/api_client/dio_interceptor.dart";
import "package:supa_architecture/blocs/blocs.dart";
import "package:supa_architecture/repositories/portal_authentication_repository.dart";

/// An interceptor for handling HTTP 401 errors and refreshing tokens.
///
/// When a 401 Unauthorized response is received, this interceptor attempts to:
/// - Refresh the authentication token.
/// - Retry the original request.
/// If the token refresh fails, the user is logged out, and cookies and storage are cleared.
class RefreshInterceptor extends Interceptor {
  /// A completer to ensure token refresh is handled only once at a time.
  static Completer<void>? _refreshCompleter;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If no ongoing refresh operation, start one.
      if (_refreshCompleter == null) {
        _refreshCompleter = Completer<void>();
        try {
          await onRefresh(); // Refresh token
          _refreshCompleter?.complete();
        } catch (e) {
          _refreshCompleter?.completeError(e);
        } finally {
          _refreshCompleter = null;
        }
      }

      // Wait for the refresh operation to complete
      try {
        await _refreshCompleter?.future;
        // Retry the failed request
        final dio = Dio();
        dio.addCookieStorageInterceptor();
        dio.addBaseUrlInterceptor();
        // Clone and retry the request
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (_) {
        // If token refresh failed, log out the user and clean up
        onRefreshFailed();
        return handler.next(err);
      }
    } else {
      // Pass all other errors to the next handler
      return handler.next(err);
    }
  }

  /// Handles the token refresh operation.
  ///
  /// Retrieves a new authentication token from the repository.
  Future<void> onRefresh() async {
    final repository = GetIt.instance.get<PortalAuthenticationRepository>();
    await repository.refreshToken();
  }

  /// Handles user logout and cleanup when token refresh fails.
  void onRefreshFailed() {
    final getIt = GetIt.instance;
    getIt.get<AuthenticationBloc>().add(UserLogoutEvent());
  }
}
