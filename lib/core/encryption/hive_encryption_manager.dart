import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveEncryptionManager {
  static const String _migrationCompleteKey = 'hive_migration_completed';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static final Map<String, HiveAesCipher> _cipherCache = {};

  static Future<HiveAesCipher> _getCipher(String keyName) async {
    if (_cipherCache.containsKey(keyName)) {
      return _cipherCache[keyName]!;
    }

    String? keyString = await _secureStorage.read(key: keyName);

    if (keyString == null) {
      final key = Hive.generateSecureKey();
      keyString = base64UrlEncode(key);
      await _secureStorage.write(key: keyName, value: keyString);
    }

    final keyBytes = base64Url.decode(keyString);
    final cipher = HiveAesCipher(keyBytes);
    _cipherCache[keyName] = cipher;

    return cipher;
  }

  static Future<Box<T>> openBoxWithMigration<T>(
    String boxName,
    String encryptionKeyName,
  ) async {
    final isMigrationComplete = await _checkMigrationStatus(boxName);

    if (!isMigrationComplete) {
      await _performMigration<T>(boxName, encryptionKeyName);
    }

    final cipher = await _getCipher(encryptionKeyName);
    return Hive.openBox<T>(boxName, encryptionCipher: cipher);
  }

  static Future<bool> _checkMigrationStatus(String boxName) async {
    final migrationKey = '${_migrationCompleteKey}_$boxName';
    final completed = await _secureStorage.read(key: migrationKey);
    return completed == 'true';
  }

  static Future<bool> _hasUnencryptedData(String boxName) async {
    try {
      final unencryptedBox = await Hive.openBox(boxName);
      final hasData = unencryptedBox.isNotEmpty;
      await unencryptedBox.close();
      return hasData;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _performMigration<T>(
    String boxName,
    String encryptionKeyName,
  ) async {
    try {
      if (!await _hasUnencryptedData(boxName)) {
        await _markMigrationComplete(boxName);
        return;
      }

      debugPrint('Starting migration for box: $boxName');

      final stopwatch = Stopwatch()..start();

      final oldBox = await Hive.openBox<T>(boxName);

      if (oldBox.isEmpty) {
        await oldBox.close();
        await _markMigrationComplete(boxName);
        return;
      }

      // Create a backup of the old data
      final backupData = <dynamic, dynamic>{};
      for (final key in oldBox.keys) {
        final value = oldBox.get(key);
        if (value != null) {
          backupData[key] = value;
        }
      }

      // Close and delete the old unencrypted box
      await oldBox.close();
      await Hive.deleteBoxFromDisk(boxName);

      // Open the new encrypted box with the original name
      final cipher = await _getCipher(encryptionKeyName);
      final newBox = await Hive.openBox<T>(boxName, encryptionCipher: cipher);

      // Restore data to the encrypted box
      for (final entry in backupData.entries) {
        await newBox.put(entry.key, entry.value);
      }

      await newBox.close();

      await _markMigrationComplete(boxName);

      stopwatch.stop();
      debugPrint(
        'Migration completed for $boxName: ${backupData.length} items in ${stopwatch.elapsedMilliseconds}ms',
      );

      _reportMigrationMetrics(boxName, true, stopwatch.elapsed);
    } catch (e) {
      debugPrint('Migration failed for $boxName: $e');
      await _rollbackMigration(boxName, encryptionKeyName);
      _reportMigrationMetrics(boxName, false, Duration.zero);
      rethrow;
    }
  }

  static Future<void> _rollbackMigration(
    String boxName,
    String encryptionKeyName,
  ) async {
    try {
      await _secureStorage.delete(key: '${_migrationCompleteKey}_$boxName');

      debugPrint('Migration rollback completed for $boxName');
    } catch (e) {
      debugPrint('Rollback failed for $boxName: $e');
    }
  }

  static Future<void> _markMigrationComplete(String boxName) async {
    final migrationKey = '${_migrationCompleteKey}_$boxName';
    await _secureStorage.write(key: migrationKey, value: 'true');
  }

  static void _reportMigrationMetrics(
    String boxName,
    bool success,
    Duration duration,
  ) {
    debugPrint(
      'Migration metrics - Box: $boxName, Success: $success, Duration: ${duration.inMilliseconds}ms',
    );
  }

  static void clearCipherCache() {
    _cipherCache.clear();
  }
}

class MigrationException implements Exception {
  final String message;
  final Exception? originalError;

  MigrationException(this.message, {this.originalError});

  @override
  String toString() {
    return 'MigrationException: $message'
        '${originalError != null ? '\nCaused by: ${originalError.toString()}' : ''}';
  }
}
