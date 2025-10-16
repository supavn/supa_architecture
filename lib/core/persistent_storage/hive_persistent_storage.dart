import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/core/encryption/hive_encryption_manager.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

/// Persistent storage implementation using Hive for local storage.
class HivePersistentStorage extends PersistentStorage {
  static const String _boxName = 'supa_architecture';
  static const String _authBoxName = 'supa_auth';
  static const String _tenantKey = 'tenant';
  static const String _appUserKey = 'appUser';
  static const String _baseApiUrlKey = 'baseApiUrl';

  late final Box<dynamic> _defaultBox;
  late final Box<dynamic> _authBox;

  bool _isInitialized = false;

  /// Initializes Hive and opens necessary boxes.
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Try to open encrypted boxes with migration
      try {
        _defaultBox = await HiveEncryptionManager.openBoxWithMigration<dynamic>(
          _boxName,
          'hive_storage_encryption_key',
        );
        _authBox = await HiveEncryptionManager.openBoxWithMigration<dynamic>(
          _authBoxName,
          'hive_auth_encryption_key',
        );
      } catch (encryptionError) {
        // Fallback to unencrypted if encryption fails
        debugPrint(
            'Encryption failed, falling back to unencrypted storage: $encryptionError');
        _defaultBox = await Hive.openBox<dynamic>(_boxName);
        _authBox = await Hive.openBox<dynamic>(_authBoxName);
      }

      // Register this instance in GetIt.
      GetIt.instance.registerSingleton<PersistentStorage>(this);
      _isInitialized = true;
    } catch (e) {
      throw HiveInitializationException(
        'Failed to initialize Hive boxes.',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Sets a key-value pair in the default box.
  @override
  void setValue(String key, String value) {
    _defaultBox.put(key, value);
  }

  /// Retrieves a value for the given key from the default box.
  @override
  String? getValue(String key) => _defaultBox.get(key);

  /// Removes a key-value pair from the default box.
  @override
  void removeValue(String key) => _defaultBox.delete(key);

  /// Clears all data from the authentication box.
  @override
  void clear() => _authBox.clear();

  /// Gets the base API URL. If not set, retrieves it from the platform.
  @override
  String get baseApiUrl {
    return _defaultBox.get(_baseApiUrlKey) ??
        SupaArchitecturePlatform.instance.getBaseUrl();
  }

  /// Sets the base API URL.
  @override
  set baseApiUrl(String url) {
    _defaultBox.put(_baseApiUrlKey, url);
  }

  /// Gets the currently stored tenant object.
  @override
  CurrentTenant? get tenant {
    final tenant = _authBox.get(_tenantKey);
    if (tenant != null && tenant is String) {
      try {
        return CurrentTenant()..fromJson(jsonDecode(tenant));
      } catch (error) {
        // Handle JSON parsing error
        debugPrint('Error parsing tenant JSON: $error');
        return null;
      }
    }
    return null;
  }

  /// Stores a tenant object in the authentication box.
  @override
  set tenant(Tenant? tenant) {
    _authBox.put(_tenantKey, tenant?.toString());
  }

  /// Removes the tenant object from the authentication box.
  @override
  void removeTenant() => _authBox.delete(_tenantKey);

  /// Gets the currently stored app user object.
  @override
  AppUser? get appUser {
    final appUser = _authBox.get(_appUserKey);
    if (appUser != null && appUser is String) {
      try {
        return AppUser()..fromJson(jsonDecode(appUser));
      } catch (error) {
        debugPrint('Error parsing appUser JSON: $error');
        return null;
      }
    }
    return null;
  }

  /// Stores an app user object in the authentication box.
  @override
  set appUser(AppUser? appUser) {
    _authBox.put(_appUserKey, appUser?.toString());
  }

  /// Removes the app user object from the authentication box.
  @override
  void removeAppUser() => _authBox.delete(_appUserKey);
}

/// Exception for Hive initialization failures.
class HiveInitializationException implements Exception {
  final String message;
  final Exception? error;

  HiveInitializationException(this.message, {this.error});

  @override
  String toString() {
    return 'HiveInitializationException: $message'
        '${error != null ? '\nCaused by: ${error.toString()}' : ''}';
  }
}
