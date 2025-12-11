/// Gets a default timezone identifier (UTC) for platforms without timezone support.
///
/// This is a stub implementation that returns 'UTC' as a fallback when platform-specific
/// timezone detection is not available. This implementation is used when neither
/// `dart:io` nor `dart:html` are available.
///
/// Returns a `Future<String>` containing 'UTC' as the timezone identifier.
Future<String> getLocalTimezone() async {
  return 'UTC';
}
