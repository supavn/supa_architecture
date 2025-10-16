import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supa_architecture/core/app_token.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/encryption/hive_encryption_manager.dart';

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

  /// Returns the first interceptor from the list of interceptors.
  @override
  Interceptor get interceptor => _interceptors.first;

  /// List of interceptors for handling cookie injection and extraction.
  List<Interceptor> get _interceptors => [
        InterceptorsWrapper(
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
            final cookies = rawCookies
                .map((raw) => Cookie.fromSetCookieValue(raw))
                .toList();
            saveCookies(uri, cookies);
            handler.next(response);
          },
        ),
      ];

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
  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    final hostKey = uri.host;
    final existingCookies =
        _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{});
    final updatedCookies = Map<String, String>.from(existingCookies ?? {});

    for (final cookie in cookies) {
      updatedCookies[cookie.name] = cookie.value;
    }

    _cookieBox.put(hostKey, updatedCookies);
  }

  /// Retrieves a single cookie by its name for a specific URI.
  @override
  Cookie getSingleCookie(Uri uri, String name) {
    final hostKey = uri.host;
    final cookies = _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{});
    final value = cookies?[name] as String? ?? '';
    return Cookie(name, value);
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
  @override
  String buildUrlWithToken(String url) {
    final uri = Uri.parse(url);
    final tokenCookie = getSingleCookie(uri, AppToken.accessTokenKey);
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        AppToken.accessTokenKey.toLowerCase(): tokenCookie.value,
      },
    ).toString();
  }
}
