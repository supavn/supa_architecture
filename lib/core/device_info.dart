import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  /// The name of the device.
  final String deviceName;

  /// The model of the device.
  final String deviceModel;

  /// The operating system of the device.
  final String operatingSystem;

  /// The system version of the device.
  final String systemVersion;

  /// The UUID of the device (if available).
  final String deviceUuid;

  /// Constructs an instance of [DeviceInfo].
  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.operatingSystem,
    required this.systemVersion,
    required this.deviceUuid,
  });

  /// Static method to gather device information for all supported platforms.
  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
      return DeviceInfo(
        deviceName: webInfo.browserName.name,
        deviceModel: webInfo.vendor ?? "Unknown Vendor",
        operatingSystem: "Web",
        systemVersion: webInfo.userAgent ?? "Unknown UserAgent",
        deviceUuid: "Unavailable on Web",
      );
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return DeviceInfo(
        deviceName: androidInfo.device,
        deviceModel: androidInfo.model,
        operatingSystem: "Android",
        systemVersion: androidInfo.version.release,
        deviceUuid: androidInfo.id,
      );
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return DeviceInfo(
        deviceName: iosInfo.name,
        deviceModel: iosInfo.model,
        operatingSystem: "iOS",
        systemVersion: iosInfo.systemVersion,
        deviceUuid: iosInfo.identifierForVendor ?? "Unknown UUID",
      );
    } else if (Platform.isMacOS) {
      final macInfo = await deviceInfoPlugin.macOsInfo;
      return DeviceInfo(
        deviceName: macInfo.computerName,
        deviceModel: "Mac", // macOS does not provide specific model information
        operatingSystem: "macOS",
        systemVersion: macInfo.osRelease,
        deviceUuid: "Unavailable on macOS",
      );
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfoPlugin.windowsInfo;
      return DeviceInfo(
        deviceName: windowsInfo.computerName,
        deviceModel:
            "Windows Device", // Windows does not provide specific model information
        operatingSystem: "Windows",
        systemVersion: windowsInfo.productName,
        deviceUuid: "Unavailable on Windows",
      );
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfoPlugin.linuxInfo;
      return DeviceInfo(
        deviceName: linuxInfo.name,
        deviceModel: linuxInfo.prettyName,
        operatingSystem: "Linux",
        systemVersion: linuxInfo.version ?? "Unknown Version",
        deviceUuid: "Unavailable on Linux",
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
