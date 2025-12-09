// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:supa_architecture/core/cookie_manager/web_cookie_manager.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/core/persistent_storage/web_persistent_storage.dart';
import 'package:web/web.dart' as web;

import 'supa_architecture_platform_interface.dart';

/// A web implementation of the SupaArchitecturePlatform of the SupaArchitecture plugin.
class SupaArchitectureWeb extends SupaArchitecturePlatform {
  /// Constructs a SupaArchitectureWeb
  SupaArchitectureWeb();

  @override
  final PersistentStorage persistentStorage = WebPersistentStorage();

  static void registerWith(Registrar registrar) {
    SupaArchitecturePlatform.instance = SupaArchitectureWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  @override
  String getBaseUrl() {
    return web.window.location.origin;
  }

  @override
  bool get useFirebase => true;

  @override
  Future<void> initialize({
    bool useFirebase = false,
  }) async {
    super.initialize(
      useFirebase: useFirebase,
    );
    cookieStorage = WebCookieManager();
    secureStorage.initialize();
    await persistentStorage.initialize();
  }
}
