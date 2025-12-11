/// Conditional exports for platform-specific timezone service implementations.
///
/// This file provides a unified interface for getting the local timezone across
/// different platforms:
/// - Mobile/Desktop (dart:io): Exports `timezone_service_mobile.dart`
/// - Web (dart:html): Exports `timezone_service_web.dart`
/// - Stub/Default: Exports `timezone_service_stub.dart` (returns UTC)
///
/// All implementations provide a `getLocalTimezone()` function that returns
/// the local timezone identifier as a `Future<String>`.
library;

export 'timezone_service_stub.dart'
    if (dart.library.io) 'timezone_service_mobile.dart'
    if (dart.library.html) 'timezone_service_web.dart';
