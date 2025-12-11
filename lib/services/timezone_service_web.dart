import 'dart:js_interop';

/// JavaScript interop class for `Intl.DateTimeFormat`.
///
/// This is used to access the browser's internationalization API for
/// determining the local timezone.
@JS('Intl.DateTimeFormat')
@staticInterop
class _IntlDateTimeFormat {
  external factory _IntlDateTimeFormat();
}

extension _IntlDateTimeFormatExtension on _IntlDateTimeFormat {
  external _ResolvedOptions resolvedOptions();
}

/// JavaScript interop class for resolved options from `Intl.DateTimeFormat`.
@JS()
@staticInterop
class _ResolvedOptions {}

extension _ResolvedOptionsExtension on _ResolvedOptions {
  external JSString? get timeZone;
}

/// Gets the local timezone using the browser's `Intl.DateTimeFormat` API.
///
/// Attempts to retrieve the timezone from the browser's internationalization
/// API. If the timezone cannot be determined, returns 'UTC' as a fallback.
///
/// Returns the timezone identifier as a string (e.g., "America/New_York").
String _getTimezoneViaIntl() {
  try {
    final formatter = _IntlDateTimeFormat();
    final options = formatter.resolvedOptions();
    final tz = options.timeZone?.toDart;
    if (tz != null && tz.isNotEmpty) return tz;
  } catch (_) {}
  return 'UTC';
}

/// Gets the local timezone identifier for web platforms.
///
/// Uses the browser's `Intl.DateTimeFormat` API to determine the local timezone.
/// This implementation is used when `dart:html` is available (web platforms).
///
/// Returns a `Future<String>` containing the timezone identifier (e.g., "America/New_York",
/// "Europe/London", "Asia/Tokyo"). If the timezone cannot be determined, returns 'UTC'.
Future<String> getLocalTimezone() async {
  return _getTimezoneViaIntl();
}
