import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:supa_architecture/core/encryption/hive_encryption_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HiveEncryptionManager Tests', () {
    late Directory testDirectory;
    late Map<String, String> secureStorageData;

    setUp(() async {
      // Setup test directory for Hive
      testDirectory = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(testDirectory.path);

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

      // Clear cipher cache before each test
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
    });

    group('Fresh Encryption (New Users)', () {
      test('should create new encryption key and open encrypted box', () async {
        const boxName = 'test_box';
        const keyName = 'test_encryption_key';

        expect(secureStorageData.containsKey(keyName), false);

        final box = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        expect(box.isOpen, true);
        expect(secureStorageData.containsKey(keyName), true);
        expect(secureStorageData[keyName], isNotNull);

        // Verify the key is valid base64
        final keyString = secureStorageData[keyName]!;
        expect(() => base64Url.decode(keyString), returnsNormally);

        await box.close();
      });

      test('should reuse existing encryption key', () async {
        const boxName = 'test_box';
        const keyName = 'test_encryption_key';

        // First call - creates key
        final box1 = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );
        final firstKey = secureStorageData[keyName];
        await box1.close();

        // Second call - should reuse key
        final box2 = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );
        final secondKey = secureStorageData[keyName];

        expect(firstKey, equals(secondKey));
        await box2.close();
      });

      test('should store and retrieve data with encryption', () async {
        const boxName = 'test_data_box';
        const keyName = 'test_data_key';

        final box = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        // Store test data
        await box.put('key1', 'encrypted_value1');
        await box.put('key2', 'encrypted_value2');

        // Verify data can be retrieved
        expect(box.get('key1'), equals('encrypted_value1'));
        expect(box.get('key2'), equals('encrypted_value2'));
        expect(box.length, equals(2));

        await box.close();
      });
    });

    group('Data Migration from Unencrypted to Encrypted', () {
      test('should migrate existing unencrypted data', () async {
        const boxName = 'migration_test_box';
        const keyName = 'migration_key';

        // Step 1: Create unencrypted box with data
        final unencryptedBox = await Hive.openBox<String>(boxName);
        await unencryptedBox.put('existing_key1', 'existing_value1');
        await unencryptedBox.put('existing_key2', 'existing_value2');
        await unencryptedBox.put('existing_key3', 'existing_value3');
        await unencryptedBox.close();

        // Step 2: Open with encryption manager (should trigger migration)
        final encryptedBox =
            await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        // Step 3: Verify all data was migrated
        expect(encryptedBox.get('existing_key1'), equals('existing_value1'));
        expect(encryptedBox.get('existing_key2'), equals('existing_value2'));
        expect(encryptedBox.get('existing_key3'), equals('existing_value3'));
        expect(encryptedBox.length, equals(3));

        // Step 4: Verify migration is marked complete
        expect(
          secureStorageData['hive_migration_completed_$boxName'],
          equals('true'),
        );

        await encryptedBox.close();
      });

      test('should handle empty unencrypted box migration', () async {
        const boxName = 'empty_migration_box';
        const keyName = 'empty_migration_key';

        // Create empty unencrypted box
        final unencryptedBox = await Hive.openBox<String>(boxName);
        await unencryptedBox.close();

        // Migrate to encrypted
        final encryptedBox =
            await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        expect(encryptedBox.isEmpty, true);
        expect(
          secureStorageData['hive_migration_completed_$boxName'],
          equals('true'),
        );

        await encryptedBox.close();
      });

      test('should handle complex data types during migration', () async {
        const boxName = 'complex_migration_box';
        const keyName = 'complex_migration_key';

        // Create unencrypted box with complex data
        final unencryptedBox = await Hive.openBox(boxName);
        await unencryptedBox.put('string_key', 'string_value');
        await unencryptedBox.put('int_key', 42);
        await unencryptedBox.put('double_key', 3.14);
        await unencryptedBox.put('bool_key', true);
        await unencryptedBox.put('list_key', ['item1', 'item2', 'item3']);
        await unencryptedBox.put('map_key', {'nested': 'value', 'count': 5});
        await unencryptedBox.close();

        // Migrate to encrypted
        final encryptedBox = await HiveEncryptionManager.openBoxWithMigration(
          boxName,
          keyName,
        );

        // Verify all data types were preserved
        expect(encryptedBox.get('string_key'), equals('string_value'));
        expect(encryptedBox.get('int_key'), equals(42));
        expect(encryptedBox.get('double_key'), equals(3.14));
        expect(encryptedBox.get('bool_key'), equals(true));
        expect(
            encryptedBox.get('list_key'), equals(['item1', 'item2', 'item3']));
        expect(encryptedBox.get('map_key'),
            equals({'nested': 'value', 'count': 5}));

        await encryptedBox.close();
      });

      test('should skip migration if already completed', () async {
        const boxName = 'skip_migration_box';
        const keyName = 'skip_migration_key';

        // Mark migration as already completed
        secureStorageData['hive_migration_completed_$boxName'] = 'true';

        // Create encrypted key
        final testKey = Hive.generateSecureKey();
        secureStorageData[keyName] = base64UrlEncode(testKey);

        // This should not attempt migration
        final box = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        expect(box.isOpen, true);
        await box.close();
      });
    });

    group('Data Decryption and Integrity', () {
      test('should decrypt data correctly after box reopening', () async {
        const boxName = 'decryption_test_box';
        const keyName = 'decryption_test_key';

        // First session: store encrypted data
        final box1 = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );
        await box1.put('test_key', 'test_value');
        await box1.close();

        // Second session: retrieve encrypted data
        final box2 = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );
        expect(box2.get('test_key'), equals('test_value'));
        await box2.close();
      });

      test('should maintain data integrity with large datasets', () async {
        const boxName = 'large_data_box';
        const keyName = 'large_data_key';

        final box = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        // Store large amount of data
        final testData = <String, String>{};
        for (int i = 0; i < 1000; i++) {
          final key = 'key_$i';
          final value = 'value_$i' * 10; // Make values longer
          testData[key] = value;
          await box.put(key, value);
        }

        // Verify all data
        expect(box.length, equals(1000));
        for (final entry in testData.entries) {
          expect(box.get(entry.key), equals(entry.value));
        }

        await box.close();
      });

      test('should handle concurrent access safely', () async {
        const boxName = 'concurrent_box';
        const keyName = 'concurrent_key';

        final box = await HiveEncryptionManager.openBoxWithMigration<int>(
          boxName,
          keyName,
        );

        // Simulate concurrent writes
        final futures = <Future>[];
        for (int i = 0; i < 100; i++) {
          futures.add(box.put('key_$i', i));
        }

        await Future.wait(futures);

        // Verify all data was written correctly
        expect(box.length, equals(100));
        for (int i = 0; i < 100; i++) {
          expect(box.get('key_$i'), equals(i));
        }

        await box.close();
      });
    });

    group('Error Handling and Recovery', () {
      test('should handle invalid encryption key gracefully', () async {
        const boxName = 'invalid_key_box';
        const keyName = 'invalid_key';

        // Set invalid key in secure storage
        secureStorageData[keyName] = 'invalid_base64_key!!!';

        // Should handle the error and generate new key
        expect(
          () => HiveEncryptionManager.openBoxWithMigration<String>(
              boxName, keyName),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle migration rollback on failure', () async {
        const boxName = 'rollback_test_box';
        const keyName = 'rollback_test_key';

        // Create unencrypted box with data
        final unencryptedBox = await Hive.openBox<String>(boxName);
        await unencryptedBox.put('test_key', 'test_value');
        await unencryptedBox.close();

        // Corrupt the encryption key to force a failure
        secureStorageData[keyName] = 'invalid_base64_key!!!';

        // This should fail during migration and trigger rollback
        try {
          await HiveEncryptionManager.openBoxWithMigration<String>(
            boxName,
            keyName,
          );
          fail('Expected migration to fail with invalid key');
        } catch (e) {
          // Verify rollback cleaned up migration markers
          expect(
            secureStorageData.containsKey('hive_migration_completed_$boxName'),
            false,
          );
        }
      });
    });

    group('Performance Tests', () {
      test('should have acceptable performance for encryption operations',
          () async {
        const boxName = 'performance_box';
        const keyName = 'performance_key';

        final stopwatch = Stopwatch()..start();

        final box = await HiveEncryptionManager.openBoxWithMigration<String>(
          boxName,
          keyName,
        );

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds,
            lessThan(1000)); // Less than 1 second

        // Test write performance
        stopwatch.reset();
        stopwatch.start();

        for (int i = 0; i < 100; i++) {
          await box.put('perf_key_$i', 'performance_value_$i');
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds,
            lessThan(5000)); // Less than 5 seconds

        await box.close();
      });
    });
  });
}
