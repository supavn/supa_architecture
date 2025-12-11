import 'package:injectable/injectable.dart';

import 'file_handler_web.dart' if (dart.library.io) 'file_handler_io.dart'
    as platform;

/// A platform-agnostic service for downloading and opening files.
///
/// This class provides a unified interface for downloading files from URLs
/// and opening them using the platform's default application. The actual
/// implementation is provided by platform-specific handlers:
/// - On mobile/desktop (dart:io): Uses `file_handler_io.dart`
/// - On web (dart:html): Uses `file_handler_web.dart`
///
/// This service is registered as a singleton using the `@singleton` annotation,
/// making it available for dependency injection throughout the application.
@singleton
class FileHandler {
  /// Downloads a file from the given URL and opens it with the default application.
  ///
  /// The behavior differs by platform:
  /// - On mobile/desktop: Downloads the file to a temporary directory and opens it
  /// - On web: Triggers a browser download of the file
  ///
  /// Parameters:
  /// - [url]: The URL of the file to download
  /// - [filename]: The name to use for the downloaded file
  ///
  /// Throws:
  /// - May throw exceptions if the download fails or the file cannot be opened.
  Future<void> downloadAndOpen(String url, String filename) async {
    await platform.downloadAndOpenFile(url, filename);
  }
}
