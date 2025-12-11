import 'package:flutter_timezone/flutter_timezone.dart';

/// Gets the local timezone identifier for mobile and desktop platforms.
///
/// Uses the `flutter_timezone` package to retrieve the device's local timezone.
/// This implementation is used when `dart:io` is available (mobile and desktop platforms).
///
/// Returns a `Future<String>` containing the timezone identifier (e.g., "America/New_York",
/// "Europe/London", "Asia/Tokyo").
///
/// Throws:
/// - May throw exceptions if the timezone cannot be determined from the device.
Future<String> getLocalTimezone() async {
  return (await FlutterTimezone.getLocalTimezone()).identifier;
}
