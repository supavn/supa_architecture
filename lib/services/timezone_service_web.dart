// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_util' as jsu;

String _getTimezoneViaIntl() {
  try {
    final intl = jsu.getProperty(jsu.globalThis, 'Intl');
    if (intl == null) return 'UTC';
    final dtfCtor = jsu.getProperty(intl, 'DateTimeFormat');
    final dtf = jsu.callConstructor(dtfCtor, const []);
    final opts = jsu.callMethod(dtf, 'resolvedOptions', const []);
    final tz = jsu.getProperty(opts, 'timeZone');
    if (tz is String && tz.isNotEmpty) return tz;
  } catch (_) {}
  return 'UTC';
}

Future<String> getLocalTimezone() async {
  return _getTimezoneViaIntl();
}
