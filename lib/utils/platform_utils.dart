import 'dart:io';

/// Utility class for platform-specific value selection.
///
/// This class provides a convenient way to select different values based on
/// the current platform (Android, iOS, macOS, Windows, Linux, or Fuchsia).
/// It's useful for platform-specific UI customization, API endpoints, or
/// feature flags.
///
/// Example usage:
/// ```dart
/// // Select platform-specific colors
/// final primaryColor = PlatformUtils.select<Color>(
///   android: Colors.green,
///   ios: Colors.blue,
///   macos: Colors.purple,
///   fallback: Colors.grey,
/// );
///
/// // Select platform-specific strings
/// final welcomeMessage = PlatformUtils.select<String>(
///   android: 'Welcome to Android!',
///   ios: 'Welcome to iOS!',
///   fallback: 'Welcome!',
/// );
///
/// // Select platform-specific API endpoints
/// final apiUrl = PlatformUtils.select<String>(
///   android: 'https://api.example.com/android',
///   ios: 'https://api.example.com/ios',
///   fallback: 'https://api.example.com/default',
/// );
/// ```
class PlatformUtils {
  /// Selects a platform-specific value based on the current platform.
  ///
  /// This method checks the current platform and returns the corresponding
  /// value if provided. The platform check order is:
  /// 1. Android
  /// 2. iOS
  /// 3. macOS
  /// 4. Windows
  /// 5. Linux
  /// 6. Fuchsia
  ///
  /// If the current platform doesn't match any provided platform-specific
  /// value, or if the matching platform's value is `null`, the [fallback]
  /// value is returned.
  ///
  /// Parameters:
  /// - [android]: Value to return if running on Android.
  /// - [ios]: Value to return if running on iOS.
  /// - [macos]: Value to return if running on macOS.
  /// - [windows]: Value to return if running on Windows.
  /// - [linux]: Value to return if running on Linux.
  /// - [fuchsia]: Value to return if running on Fuchsia.
  /// - [fallback]: Required fallback value returned when no platform-specific
  ///   value matches or is provided.
  ///
  /// Returns the platform-specific value if available, otherwise [fallback].
  ///
  /// Example:
  /// ```dart
  /// final theme = PlatformUtils.select<ThemeData>(
  ///   android: ThemeData.light(),
  ///   ios: ThemeData.dark(),
  ///   fallback: ThemeData.system(),
  /// );
  /// ```
  static T select<T>({
    T? android,
    T? ios,
    T? macos,
    T? windows,
    T? linux,
    T? fuchsia,
    required T fallback,
  }) {
    if (Platform.isAndroid && android != null) return android;
    if (Platform.isIOS && ios != null) return ios;
    if (Platform.isMacOS && macos != null) return macos;
    if (Platform.isWindows && windows != null) return windows;
    if (Platform.isLinux && linux != null) return linux;
    if (Platform.isFuchsia && fuchsia != null) return fuchsia;
    return fallback;
  }
}
