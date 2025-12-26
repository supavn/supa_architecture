import 'package:web/web.dart';

/// Downloads a file from the given URL in the web browser.
///
/// This is the platform-specific implementation for web platforms (when `dart:html`
/// is available). It creates a temporary anchor element with the download attribute
/// and programmatically clicks it to trigger the browser's download functionality.
///
/// Parameters:
/// - [url]: The URL of the file to download
/// - [filename]: The suggested filename for the download (browser may override this)
///
/// Note: The file will be downloaded by the browser, but won't automatically open
/// as on mobile/desktop platforms. Users can open the downloaded file manually.
Future<void> downloadAndOpenFile(String url, String filename) async {
  final anchor = document.createElement('a') as HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
}

/// Opens a file from the given path in a new browser tab.
///
/// This is the platform-specific implementation for web platforms.
/// It opens the file/URL in a new browser tab using window.open.
///
/// Parameters:
/// - [filePath]: The URL path of the file to open
///
/// Note: The file will open in a new tab. Browser pop-up blockers may
/// prevent this from working unless called in response to a user action.
Future<void> openFile(String filePath) async {
  window.open(filePath, '_blank');
}
