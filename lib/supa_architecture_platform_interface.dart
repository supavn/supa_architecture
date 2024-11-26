import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/device_info.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';

import 'supa_architecture_method_channel.dart';

abstract class SupaArchitecturePlatform extends PlatformInterface {
  /// The persistent storage service.
  PersistentStorage get persistentStorage;

  late final CookieManager cookieStorage;

  late final DeviceInfo deviceInfo;

  /// Constructs a SupaArchitecturePlatform.
  SupaArchitecturePlatform() : super(token: _token);

  static final Object _token = Object();

  static SupaArchitecturePlatform _instance = MethodChannelSupaArchitecture();

  /// The default instance of [SupaArchitecturePlatform] to use.
  ///
  /// Defaults to [MethodChannelSupaArchitecture].
  static SupaArchitecturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SupaArchitecturePlatform] when
  /// they register themselves.
  static set instance(SupaArchitecturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  String getBaseUrl();

  bool get useFirebase;

  Future<void> initialize();
}
