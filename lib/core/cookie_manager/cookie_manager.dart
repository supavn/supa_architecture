import 'dart:io';

import 'package:dio/dio.dart';

/// Abstract cookie manager providing platform-specific cookie handling strategies.
///
/// This class serves two main purposes:
/// 1. **Web platforms**: Leverages native browser cookie handling
/// 2. **Mobile platforms**: Provides custom cookie management for libraries that
///    don't support cookie embedding, with token-in-URL capability for backend collaboration
abstract class CookieManager {
  /// Returns a Dio interceptor for automatic cookie handling.
  ///
  /// The interceptor handles:
  /// - Injecting cookies into outgoing requests
  /// - Extracting cookies from incoming responses
  Interceptor get interceptor;

  /// Indicates whether this implementation supports token-in-URL functionality.
  ///
  /// Returns:
  /// - `true` for mobile implementations that support query parameter tokens
  /// - `false` for web implementations that rely on browser cookie handling
  bool get supportsTokenInUrl;

  /// Loads all cookies for the specified URI.
  ///
  /// Returns an empty list if no cookies are found for the URI.
  ///
  /// **Parameters:**
  /// - `uri`: The URI to load cookies for
  ///
  /// **Returns:** List of cookies associated with the URI's host
  List<Cookie> loadCookies(Uri uri);

  /// Retrieves a single cookie by name for the specified URI.
  ///
  /// **Parameters:**
  /// - `uri`: The URI to search cookies for
  /// - `name`: The name of the cookie to retrieve
  ///
  /// **Returns:** The cookie if found, or null if not found
  ///
  /// **Throws:** No exceptions - returns null for missing cookies across all platforms
  Cookie? getSingleCookie(Uri uri, String name);

  /// Saves cookies for the specified URI.
  ///
  /// **Platform behavior:**
  /// - **Web**: Saves to browser's cookie store
  /// - **Mobile**: Saves to local encrypted storage
  ///
  /// **Parameters:**
  /// - `uri`: The URI to associate cookies with
  /// - `cookies`: List of cookies to save
  void saveCookies(Uri uri, List<Cookie> cookies);

  /// Deletes all cookies for the specified URI.
  ///
  /// **Parameters:**
  /// - `uri`: The URI to delete cookies for
  void deleteCookies(Uri uri);

  /// Deletes all stored cookies across all URIs.
  ///
  /// **Platform behavior:**
  /// - **Web**: Clears all cookies for the current domain
  /// - **Mobile**: Clears all cookies from local storage
  void deleteAllCookies();

  /// Builds a URL with authentication token as query parameter.
  ///
  /// **Platform behavior:**
  /// - **Web**: Returns original URL unchanged (relies on browser cookie handling)
  /// - **Mobile**: Appends access token to query parameters for backend collaboration
  ///
  /// **Parameters:**
  /// - `url`: The base URL to potentially modify
  ///
  /// **Returns:**
  /// - Original URL (web platforms)
  /// - URL with token parameter (mobile platforms, if token available)
  ///
  /// **Fallback:** Returns original URL if token extraction fails
  String buildUrlWithToken(String url);
}
