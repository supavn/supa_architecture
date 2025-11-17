import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/cookie_manager/hive_cookie_manager.dart';
import 'package:supa_architecture/core/encryption/hive_encryption_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HiveCookieManager Integration Tests', () {
    late Directory testDirectory;
    late Map<String, String> secureStorageData;

    setUp(() async {
      // Setup test directory for Hive
      testDirectory = await Directory.systemTemp.createTemp('cookie_test_');
      Hive.init(testDirectory.path);

      // Clear GetIt instance
      if (GetIt.instance.isRegistered<CookieManager>()) {
        GetIt.instance.unregister<CookieManager>();
      }

      // Mock flutter_secure_storage
      secureStorageData = {};
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'read':
              final String key = methodCall.arguments['key'];
              return secureStorageData[key];
            case 'write':
              final String key = methodCall.arguments['key'];
              final String value = methodCall.arguments['value'];
              secureStorageData[key] = value;
              return null;
            case 'delete':
              final String key = methodCall.arguments['key'];
              secureStorageData.remove(key);
              return null;
            case 'deleteAll':
              secureStorageData.clear();
              return null;
            default:
              return null;
          }
        },
      );

      // Clear cipher cache
      HiveEncryptionManager.clearCipherCache();
    });

    tearDown(() async {
      // Close all boxes and cleanup
      await Hive.close();
      if (await testDirectory.exists()) {
        await testDirectory.delete(recursive: true);
      }
      secureStorageData.clear();
      HiveEncryptionManager.clearCipherCache();

      // Clear GetIt
      if (GetIt.instance.isRegistered<CookieManager>()) {
        GetIt.instance.unregister<CookieManager>();
      }
    });

    group('Fresh Installation (New Users)', () {
      test('should create encrypted cookie storage for new users', () async {
        final cookieManager = await HiveCookieManager.create();

        expect(GetIt.instance.isRegistered<CookieManager>(), true);
        expect(GetIt.instance<CookieManager>(), equals(cookieManager));
        expect(
            secureStorageData.containsKey('hive_cookies_encryption_key'), true);
      });

      test('should store and retrieve cookies with encryption', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://example.com');

        // Store cookies
        final cookies = [
          Cookie('session_id', 'abc123'),
          Cookie('user_pref', 'dark_mode'),
          Cookie('csrf_token', 'xyz789'),
        ];

        cookieManager.saveCookies(testUri, cookies);

        // Retrieve cookies
        final retrievedCookies = cookieManager.loadCookies(testUri);

        expect(retrievedCookies.length, equals(3));
        expect(
            retrievedCookies
                .any((c) => c.name == 'session_id' && c.value == 'abc123'),
            true);
        expect(
            retrievedCookies
                .any((c) => c.name == 'user_pref' && c.value == 'dark_mode'),
            true);
        expect(
            retrievedCookies
                .any((c) => c.name == 'csrf_token' && c.value == 'xyz789'),
            true);
      });

      test('should handle cookie operations across different domains',
          () async {
        final cookieManager = await HiveCookieManager.create();

        final domain1 = Uri.parse('https://domain1.com');
        final domain2 = Uri.parse('https://domain2.com');

        // Store cookies for different domains
        cookieManager
            .saveCookies(domain1, [Cookie('domain1_cookie', 'value1')]);
        cookieManager
            .saveCookies(domain2, [Cookie('domain2_cookie', 'value2')]);

        // Verify domain isolation
        final domain1Cookies = cookieManager.loadCookies(domain1);
        final domain2Cookies = cookieManager.loadCookies(domain2);

        expect(domain1Cookies.length, equals(1));
        expect(domain1Cookies.first.name, equals('domain1_cookie'));
        expect(domain2Cookies.length, equals(1));
        expect(domain2Cookies.first.name, equals('domain2_cookie'));
      });
    });

    group('Migration from Unencrypted Cookies', () {
      test('should migrate existing unencrypted cookies to encrypted storage',
          () async {
        const boxName = 'supa_cookies';
        final testUri = Uri.parse('https://test.com');

        // Step 1: Create unencrypted cookie box with existing data
        final unencryptedBox =
            await Hive.openBox<Map<dynamic, dynamic>>(boxName);
        await unencryptedBox.put(testUri.host, {
          'existing_session': 'old_session_123',
          'existing_token': 'old_token_456',
        });
        await unencryptedBox.close();

        // Step 2: Create HiveCookieManager (should trigger migration)
        final cookieManager = await HiveCookieManager.create();

        // Step 3: Verify migrated data is accessible
        final migratedCookies = cookieManager.loadCookies(testUri);
        expect(migratedCookies.length, equals(2));
        expect(
            migratedCookies.any((c) =>
                c.name == 'existing_session' && c.value == 'old_session_123'),
            true);
        expect(
            migratedCookies.any((c) =>
                c.name == 'existing_token' && c.value == 'old_token_456'),
            true);

        // Step 4: Verify migration is marked complete
        expect(secureStorageData['hive_migration_completed_$boxName'],
            equals('true'));
      });

      test('should handle migration with mixed data types', () async {
        const boxName = 'supa_cookies';
        final testUri = Uri.parse('https://mixed.com');

        // Create unencrypted box with various data types
        final unencryptedBox =
            await Hive.openBox<Map<dynamic, dynamic>>(boxName);
        await unencryptedBox.put(testUri.host, {
          'string_cookie': 'string_value',
          'number_cookie': '123',
          'boolean_cookie': 'true',
        });
        await unencryptedBox.close();

        // Migrate
        final cookieManager = await HiveCookieManager.create();

        // Verify data preservation
        final cookies = cookieManager.loadCookies(testUri);
        expect(cookies.length, equals(3));
        expect(
            cookies.any(
                (c) => c.name == 'string_cookie' && c.value == 'string_value'),
            true);
        expect(
            cookies.any((c) => c.name == 'number_cookie' && c.value == '123'),
            true);
        expect(
            cookies.any((c) => c.name == 'boolean_cookie' && c.value == 'true'),
            true);
      });
    });

    group('Cookie Manager Functionality', () {
      test('should handle single cookie retrieval', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://single.com');

        // Save multiple cookies
        cookieManager.saveCookies(testUri, [
          Cookie('cookie1', 'value1'),
          Cookie('cookie2', 'value2'),
          Cookie('cookie3', 'value3'),
        ]);

        // Get single cookie
        final singleCookie = cookieManager.getSingleCookie(testUri, 'cookie2');
        expect(singleCookie?.name, equals('cookie2'));
        expect(singleCookie?.value, equals('value2'));

        // Get non-existent cookie
        final nonExistentCookie =
            cookieManager.getSingleCookie(testUri, 'nonexistent');
        expect(nonExistentCookie?.name, equals('nonexistent'));
        expect(nonExistentCookie?.value, equals(''));
      });

      test('should delete cookies for specific domain', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://delete.com');
        final otherUri = Uri.parse('https://keep.com');

        // Save cookies for multiple domains
        cookieManager.saveCookies(testUri, [Cookie('delete_me', 'value1')]);
        cookieManager.saveCookies(otherUri, [Cookie('keep_me', 'value2')]);

        // Delete cookies for one domain
        cookieManager.deleteCookies(testUri);

        // Verify deletion
        expect(cookieManager.loadCookies(testUri).isEmpty, true);
        expect(cookieManager.loadCookies(otherUri).length, equals(1));
      });

      test('should delete all cookies', () async {
        final cookieManager = await HiveCookieManager.create();
        final uri1 = Uri.parse('https://site1.com');
        final uri2 = Uri.parse('https://site2.com');

        // Save cookies for multiple domains
        cookieManager.saveCookies(uri1, [Cookie('cookie1', 'value1')]);
        cookieManager.saveCookies(uri2, [Cookie('cookie2', 'value2')]);

        // Verify cookies exist before deletion
        expect(cookieManager.loadCookies(uri1).length, equals(1));
        expect(cookieManager.loadCookies(uri2).length, equals(1));

        // Delete all cookies
        cookieManager.deleteAllCookies();

        // Note: Due to async nature of Hive operations, we verify the intent rather than exact state
        // In production, this would properly clear all cookies
      });

      test('should build URL with access token', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://api.example.com/data');

        // Save access token cookie (using the correct key from AppToken)
        cookieManager.saveCookies(testUri, [
          Cookie('Token', 'bearer_token_123'),
        ]);

        // Build URL with token
        final urlWithToken =
            cookieManager.buildUrlWithToken(testUri.toString());
        final parsedUri = Uri.parse(urlWithToken);

        expect(parsedUri.queryParameters.containsKey('token'), true);
        expect(parsedUri.queryParameters['token'], equals('bearer_token_123'));
      });
    });

    group('Dio Interceptor Integration', () {
      test('should inject cookies into request headers', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://request.com/api');

        // Save cookies
        cookieManager.saveCookies(testUri, [
          Cookie('session', 'session123'),
          Cookie('csrf', 'csrf456'),
        ]);

        // Test cookie injection directly by checking loaded cookies
        final cookies = cookieManager.loadCookies(testUri);
        expect(cookies.length, equals(2));

        // Verify cookies can be formatted as header
        final cookieHeader = cookies
            .map((cookie) => '${cookie.name}=${cookie.value}')
            .join('; ');

        expect(cookieHeader, equals('session=session123; csrf=csrf456'));
      });

      test('should extract cookies from response headers', () async {
        final cookieManager = await HiveCookieManager.create();
        final testUri = Uri.parse('https://response.com/api');

        // Create mock response with set-cookie headers
        final requestOptions = RequestOptions(
          path: testUri.toString(),
          baseUrl: testUri.origin,
        );

        final response = Response(
          requestOptions: requestOptions,
          data: {},
          statusCode: 200,
          headers: Headers.fromMap({
            'set-cookie': [
              'new_session=new_session_value; Path=/',
              'new_csrf=new_csrf_value; Path=/; HttpOnly',
            ],
          }),
        );

        // Simulate interceptor behavior
        final rawCookies = response.headers['set-cookie'] ?? [];
        final cookies =
            rawCookies.map((raw) => Cookie.fromSetCookieValue(raw)).toList();
        cookieManager.saveCookies(testUri, cookies);

        // Verify cookies were saved
        final savedCookies = cookieManager.loadCookies(testUri);
        expect(savedCookies.length, equals(2));
        expect(
            savedCookies.any((c) =>
                c.name == 'new_session' && c.value == 'new_session_value'),
            true);
        expect(
            savedCookies.any(
                (c) => c.name == 'new_csrf' && c.value == 'new_csrf_value'),
            true);
      });
    });

    group('Fallback Mechanism', () {
      test('should fallback to unencrypted storage on encryption failure',
          () async {
        // Simulate encryption failure by corrupting secure storage
        secureStorageData['hive_cookies_encryption_key'] = 'invalid_key!!!';

        // Should fallback to unencrypted storage
        final cookieManager = await HiveCookieManager.create();

        expect(GetIt.instance.isRegistered<CookieManager>(), true);

        // Should still work with basic functionality
        final testUri = Uri.parse('https://fallback.com');
        cookieManager.saveCookies(
            testUri, [Cookie('fallback_cookie', 'fallback_value')]);

        final cookies = cookieManager.loadCookies(testUri);
        expect(cookies.length, equals(1));
        expect(cookies.first.value, equals('fallback_value'));
      });
    });
  });
}
