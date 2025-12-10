import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/blocs/blocs.dart';

/// An interceptor that automatically adds language information to HTTP request headers.
///
/// This interceptor extracts the user's preferred language from the authentication state
/// and includes it in API requests, enabling the backend to provide localized responses.
///
/// **Behavior:**
/// - Only adds language header for authenticated users
/// - Safely handles cases where authentication bloc is not registered
/// - Skips empty or invalid language codes
///
/// **Header Added:**
/// - `X-Language`: The user's language code (e.g., "en", "es", "fr")
///
/// **Use Cases:**
/// - Receiving localized error messages from the API
/// - Getting content in the user's preferred language
/// - Analytics and logging based on user language preferences
///
/// **Example Request:**
/// ```
/// GET /api/users
/// X-Language: en-US
/// ```
class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Verify that the authentication bloc is available
    if (GetIt.instance.isRegistered<AuthenticationBloc>()) {
      final authenticationBloc = GetIt.instance.get<AuthenticationBloc>();

      // Only proceed if the user is authenticated
      if (authenticationBloc.state.isAuthenticated) {
        try {
          // Extract the language code from the authenticated user's profile
          final language = (authenticationBloc.state
                  as UserAuthenticatedWithSelectedTenantState)
              .user
              .language
              .value
              .code
              .value;

          // Add language header only if the code is valid
          if (language.isNotEmpty) {
            options.headers['X-Language'] = language;
          }
        } catch (e) {
          // Silently handle any errors in language extraction
          // to prevent disrupting the API call
        }
      }
    }

    // Continue with the request
    handler.next(options);
  }
}
