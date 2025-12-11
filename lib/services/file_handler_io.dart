import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supa_architecture/supa_architecture.dart';

/// Internal repository class for downloading files via the API.
///
/// Extends `ApiClient` to provide file download functionality using the
/// base API URL from persistent storage.
class _FileRepository extends ApiClient {
  @override
  String get baseUrl => persistentStorage.baseApiUrl;
}

/// Singleton instance of the file repository.
final _repository = _FileRepository();

/// Downloads a file from the given URL and opens it with the default application.
///
/// This is the platform-specific implementation for mobile and desktop platforms
/// (when `dart:io` is available). The file is downloaded to the temporary directory
/// and then opened using the platform's default application for that file type.
///
/// Parameters:
/// - [url]: The URL of the file to download
/// - [filename]: The name to use for the downloaded file
///
/// If the download fails or the file cannot be retrieved, the function returns
/// without opening anything. If the file is successfully downloaded, it is
/// automatically opened using the system's default application.
Future<void> downloadAndOpenFile(String url, String filename) async {
  final savedPath = await getTemporaryDirectory();
  final ioFile = await _repository.downloadFile(
    url: url,
    savePath: savedPath.path,
    filename: filename,
  );

  if (ioFile != null) {
    OpenFile.open(ioFile.path);
  }
}
