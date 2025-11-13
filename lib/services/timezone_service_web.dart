import 'dart:js_interop';

@JS('Intl.DateTimeFormat')
@staticInterop
class _IntlDateTimeFormat {
  external factory _IntlDateTimeFormat();
}

extension _IntlDateTimeFormatExtension on _IntlDateTimeFormat {
  external _ResolvedOptions resolvedOptions();
}

@JS()
@staticInterop
class _ResolvedOptions {}

extension _ResolvedOptionsExtension on _ResolvedOptions {
  external JSString? get timeZone;
}

String _getTimezoneViaIntl() {
  try {
    final formatter = _IntlDateTimeFormat();
    final options = formatter.resolvedOptions();
    final tz = options.timeZone?.toDart;
    if (tz != null && tz.isNotEmpty) return tz;
  } catch (_) {}
  return 'UTC';
}

Future<String> getLocalTimezone() async {
  return _getTimezoneViaIntl();
}
