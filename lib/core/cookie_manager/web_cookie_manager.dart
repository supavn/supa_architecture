import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:web/web.dart' hide Response;

/// A [CookieManager] implementation for web browsers using `document.cookie`.
///
/// This implementation leverages the browser's native cookie handling and does not
/// support token-in-URL functionality, relying instead on automatic cookie transmission.
class WebCookieManager implements CookieManager {
  @override
  bool get supportsTokenInUrl => false;

  /// Returns a Dio interceptor for handling cookies.
  @override
  Interceptor get interceptor => InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
      );

  /// Handles the `onRequest` phase to add cookies to outgoing requests.
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    final cookies = loadCookies(uri);
    if (cookies.isNotEmpty) {
      options.headers['Cookie'] =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    }
    handler.next(options);
  }

  /// Handles the `onResponse` phase to extract cookies from incoming responses.
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri;
    final rawCookies = response.headers['set-cookie'] ?? [];
    final cookies =
        rawCookies.map((raw) => Cookie.fromSetCookieValue(raw)).toList();
    saveCookies(uri, cookies);
    handler.next(response);
  }

  /// Loads all cookies available for the current domain.
  @override
  List<Cookie> loadCookies(Uri uri) {
    final rawCookies = document.cookie;
    if (rawCookies.isEmpty) return [];
    return rawCookies.split('; ').map((rawCookie) {
      final parts = rawCookie.split('=');
      final name = parts[0].trim();
      final value = parts.length > 1 ? parts[1].trim() : '';
      return Cookie(name, value);
    }).toList();
  }

  /// Saves cookies to the browser for a specific URI.
  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=${cookie.value}; path=/; domain=${uri.host};';
    }
  }

  /// Deletes all cookies for a specific URI.
  @override
  void deleteCookies(Uri uri) {
    final cookies = loadCookies(uri);
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=; path=/; domain=${uri.host}; expires=Thu, 01 Jan 1970 00:00:00 GMT;';
    }
  }

  /// Deletes all cookies globally across the domain.
  @override
  void deleteAllCookies() {
    final cookies = loadCookies(Uri.parse(document.domain));
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=; path=/; domain=${document.domain}; expires=Thu, 01 Jan 1970 00:00:00 GMT;';
    }
  }

  /// Retrieves a single cookie by its name for a specific URI.
  /// Returns null if the cookie is not found.
  @override
  Cookie? getSingleCookie(Uri uri, String name) {
    final rawCookies = document.cookie;
    if (rawCookies.isEmpty) {
      return null;
    }

    try {
      final cookieString = rawCookies
          .split('; ')
          .where((cookie) => cookie.startsWith('$name='))
          .firstOrNull;

      if (cookieString == null || cookieString.isEmpty) {
        return null;
      }

      final value = cookieString.split('=').skip(1).join('=');
      return Cookie(name, value);
    } catch (e) {
      return null;
    }
  }

  /// Builds a URL with the token included as a query parameter.
  ///
  /// On web platforms, this returns the original URL unchanged as the browser
  /// handles cookie authentication automatically.
  @override
  String buildUrlWithToken(String url) {
    // Web implementation relies on browser's native cookie handling
    return url;
  }
}
