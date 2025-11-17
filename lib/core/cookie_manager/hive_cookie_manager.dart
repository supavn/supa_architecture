import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supa_architecture/core/app_token.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/encryption/hive_encryption_manager.dart';

/// Mobile cookie manager using Hive for local storage with encryption support.
///
/// This implementation provides:
/// - Encrypted cookie storage using Hive
/// - Token-in-URL capability for non-HTTP libraries
/// - Automatic cookie injection/extraction via Dio interceptors
/// - Proper handling of duplicate set-cookie headers
/// - One-time migration for data consistency
class HiveCookieManager implements CookieManager {
  /// Factory method to create and register a [HiveCookieManager] instance.
  static Future<HiveCookieManager> create() async {
    try {
      final box = await HiveEncryptionManager.openBoxWithMigration<
          Map<dynamic, dynamic>>(
        'supa_cookies',
        'hive_cookies_encryption_key',
      );
      final hiveCookieManager = HiveCookieManager(box);
      GetIt.instance.registerSingleton<CookieManager>(hiveCookieManager);
      return hiveCookieManager;
    } catch (e) {
      final box = await Hive.openBox<Map<dynamic, dynamic>>('supa_cookies');
      final hiveCookieManager = HiveCookieManager(box);
      GetIt.instance.registerSingleton<CookieManager>(hiveCookieManager);
      return hiveCookieManager;
    }
  }

  final Box<Map<dynamic, dynamic>> _cookieBox;

  /// Constructs a [HiveCookieManager] with the given Hive box.
  HiveCookieManager(this._cookieBox);

  @override
  bool get supportsTokenInUrl => true;

  /// Returns the interceptor for handling cookie injection and extraction.
  @override
  Interceptor get interceptor => InterceptorsWrapper(
        onRequest: (options, handler) {
          final uri = options.uri;
          final cookies = loadCookies(uri);
          final cookieHeader = cookies
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; ');
          if (cookieHeader.isNotEmpty) {
            options.headers['Cookie'] = cookieHeader;
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          final uri = response.requestOptions.uri;
          final rawCookies = response.headers['set-cookie'] ?? [];

          if (rawCookies.isNotEmpty) {
            try {
              final cookies = rawCookies
                  .map((raw) => Cookie.fromSetCookieValue(raw))
                  .toList();

              // Check for duplicate cookie names and log warning if found
              final cookieNames = cookies.map((c) => c.name).toList();
              final uniqueNames = cookieNames.toSet();
              if (cookieNames.length != uniqueNames.length) {
                // Log duplicate detection for debugging
                final duplicates = cookieNames
                    .where((name) =>
                        cookieNames.where((n) => n == name).length > 1)
                    .toSet();
                debugPrint(
                    'Warning: Duplicate set-cookie headers detected for: ${duplicates.join(', ')}. Using last occurrence.');
              }

              saveCookies(uri, cookies);
            } catch (e) {
              // Log cookie parsing errors but don't break the request flow
              debugPrint('Error parsing set-cookie headers: $e');
            }
          }

          handler.next(response);
        },
      );

  /// Loads cookies for a specific URI.
  @override
  List<Cookie> loadCookies(Uri uri) {
    final hostKey = uri.host;
    final storedCookies =
        _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{});
    if (storedCookies is Map) {
      return storedCookies.entries
          .map((entry) => Cookie(entry.key as String, entry.value as String))
          .toList();
    }
    return [];
  }

  /// Saves cookies for a specific URI.
  ///
  /// Handles duplicate cookie names by keeping the last occurrence,
  /// which follows standard HTTP cookie behavior.
  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    if (cookies.isEmpty) return;

    final hostKey = uri.host;
    final existingCookies =
        _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{});
    final updatedCookies = Map<String, String>.from(existingCookies ?? {});

    // Process cookies in order, with later cookies overriding earlier ones
    // This ensures consistent behavior when backend sends duplicate set-cookie headers
    for (final cookie in cookies) {
      // Only update if the cookie has a meaningful value
      if (cookie.name.isNotEmpty) {
        updatedCookies[cookie.name] = cookie.value;
      }
    }

    _cookieBox.put(hostKey, updatedCookies);
  }

  /// Retrieves a single cookie by its name for a specific URI.
  /// Returns null if the cookie is not found.
  @override
  Cookie? getSingleCookie(Uri uri, String name) {
    final hostKey = uri.host;
    final cookies = _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{});
    final value = cookies?[name] as String?;

    if (value == null || value.isEmpty) {
      return null;
    }

    return Cookie(name, value);
  }

  /// Retrieves all cookies with the specified name for debugging purposes.
  ///
  /// This is useful for investigating duplicate cookie scenarios.
  /// In normal operation, use [getSingleCookie] which returns the current value.
  List<Cookie> getCookiesByName(Uri uri, String name) {
    final cookies = loadCookies(uri);
    return cookies.where((cookie) => cookie.name == name).toList();
  }

  /// Performs one-time migration to ensure cookie data consistency.
  ///
  /// This method should be called during app initialization to:
  /// - Check if migration has already been performed
  /// - Clean up any inconsistent legacy cookie data
  /// - Mark migration as complete to prevent future runs
  ///
  /// **Important**: This will cause users to be logged out ONCE during upgrade.
  Future<void> performCookieMigration() async {
    const migrationKey = 'cookie_migration_v1_completed';

    // Check if migration already performed
    final migrationCompleted = _cookieBox.get(migrationKey);
    if (migrationCompleted != null) {
      return; // Migration already done
    }

    debugPrint('Performing one-time cookie migration...');

    try {
      // Get all stored hosts
      final allKeys =
          _cookieBox.keys.where((key) => key != migrationKey).toList();
      var migratedHosts = 0;
      var corruptedHosts = 0;

      for (final hostKey in allKeys) {
        final storedCookies = _cookieBox.get(hostKey);

        if (storedCookies == null) {
          continue;
        }

        // Clean up this host's cookies
        final cleanedCookies = <String, String>{};
        var hadCorruption = false;

        for (final entry in storedCookies.entries) {
          final key = entry.key;
          final value = entry.value;

          // Skip invalid entries
          if (key == null ||
              key is! String ||
              key.isEmpty ||
              value == null ||
              value is! String) {
            hadCorruption = true;
            continue;
          }

          cleanedCookies[key] = value;
        }

        if (hadCorruption) {
          corruptedHosts++;
          if (cleanedCookies.isNotEmpty) {
            // Save cleaned data
            _cookieBox.put(hostKey, cleanedCookies);
          } else {
            // No valid data, remove entirely (will cause logout)
            _cookieBox.delete(hostKey);
          }
        }

        migratedHosts++;
      }

      // Mark migration as completed
      await _cookieBox.put(migrationKey, <String, String>{'completed': 'true'});

      if (corruptedHosts > 0) {
        debugPrint(
            'Cookie migration completed: $migratedHosts hosts processed, $corruptedHosts had corruption (user may need to re-login)');
      } else {
        debugPrint(
            'Cookie migration completed: $migratedHosts hosts processed, no corruption found');
      }
    } catch (e) {
      debugPrint('Cookie migration failed: $e');
      // Don't mark as completed if migration failed
      rethrow;
    }
  }

  /// Cleans up any corrupted or inconsistent cookie data for a specific URI.
  ///
  /// This method ensures data integrity by:
  /// - Validating all stored cookie entries
  /// - Removing any entries with empty/null keys or values
  /// - Rebuilding the storage map to ensure consistency
  void cleanupCookies(Uri uri) {
    final hostKey = uri.host;
    final storedCookies = _cookieBox.get(hostKey);

    if (storedCookies == null) {
      return;
    }

    final cleanedCookies = <String, String>{};
    var hadCorruption = false;

    for (final entry in storedCookies.entries) {
      final key = entry.key;
      final value = entry.value;

      // Skip invalid entries
      if (key == null ||
          key is! String ||
          key.isEmpty ||
          value == null ||
          value is! String) {
        hadCorruption = true;
        continue;
      }

      cleanedCookies[key] = value;
    }

    // Only update storage if we found corruption
    if (hadCorruption) {
      debugPrint('Cleaned up corrupted cookie data for host: $hostKey');
      _cookieBox.put(hostKey, cleanedCookies);
    }
  }

  /// Deletes all cookies for a specific URI.
  @override
  void deleteCookies(Uri uri) {
    final hostKey = uri.host;
    _cookieBox.delete(hostKey);
  }

  /// Deletes all cookies stored in the Hive box.
  @override
  void deleteAllCookies() {
    _cookieBox.clear();
  }

  /// Constructs a URL with an appended access token query parameter.
  ///
  /// Returns the original URL if:
  /// - Token extraction fails
  /// - Token is null or empty
  /// - URL parsing fails
  @override
  String buildUrlWithToken(String url) {
    try {
      final uri = Uri.parse(url);
      final tokenCookie = getSingleCookie(uri, AppToken.accessTokenKey);

      // Return original URL if no token found
      if (tokenCookie == null || tokenCookie.value.isEmpty) {
        return url;
      }

      return uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          AppToken.accessTokenKey.toLowerCase(): tokenCookie.value,
        },
      ).toString();
    } catch (e) {
      // Graceful degradation - return original URL on any error
      return url;
    }
  }
}
