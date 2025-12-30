import "dart:async";
import "dart:io" as io;

import "package:dio/dio.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:image_picker/image_picker.dart";
import "package:path/path.dart";
import "package:supa_architecture/api_client/dio_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/device_info_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/general_error_log_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/language_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/refresh_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/timezone_interceptor.dart";
import "package:supa_architecture/core/cookie_manager/cookie_manager.dart";
import "package:supa_architecture/core/persistent_storage/persistent_storage.dart";
import "package:supa_architecture/core/secure_storage/secure_storage.dart";
import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/models.dart";

part "dio_exception.dart";
part "http_response.dart";

/// A comprehensive API client for handling HTTP requests, file uploads, and downloads.
///
/// This abstract class provides a unified interface for all API operations in the application,
/// including standard HTTP requests, file uploads (single/multiple), and file downloads.
/// It automatically handles authentication, cookies, device information, and other common
/// request requirements through configurable interceptors.
///
/// **Key Features:**
/// - Cross-platform file upload support (Web and Native)
/// - Automatic cookie management (Native platforms)
/// - Device information headers
/// - Language localization headers
/// - Timezone and timestamp headers
/// - Token refresh handling for authentication
/// - Persistent URL configuration
///
/// **Implementation Requirements:**
/// Subclasses must implement the [baseUrl] getter to specify the API endpoint.
///
/// **Usage Example:**
/// ```dart
/// class MyApiClient extends ApiClient {
///   @override
///   String get baseUrl => 'https://api.example.com';
/// }
///
/// final client = MyApiClient(
///   shouldUseDeviceInfo: true,
///   shouldUseLanguage: true,
/// );
///
/// // Upload a file
/// final file = await client.uploadFile(filePath: '/path/to/file.jpg');
///
/// // Download content
/// final bytes = await client.downloadBytes('https://example.com/image.png');
/// ```
abstract class ApiClient {
  CookieManager get cookieStorage => GetIt.instance.get<CookieManager>();
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();
  SecureStorage get secureStorage => GetIt.instance.get<SecureStorage>();

  /// The Dio HTTP client instance used for all network requests.
  final Dio dio;

  /// The refresh interceptor for handling token refresh on 401 errors.
  RefreshInterceptor refreshInterceptor = RefreshInterceptor();

  /// Creates an [ApiClient] instance with configurable interceptors.
  ///
  /// **Parameters:**
  /// - [shouldUsePersistentUrl]: Enable dynamic base URL switching (default: false)
  /// - [shouldUseDeviceInfo]: Include device information headers (default: false)
  /// - [shouldUseLanguage]: Include user language headers (default: true)
  /// - [refreshInterceptor]: Custom token refresh interceptor (optional)
  ///
  /// **Interceptors Added (in order):**
  /// 1. DeviceInfoInterceptor (if enabled)
  /// 2. LanguageInterceptor (if enabled)
  /// 3. Cookie storage interceptor (native platforms only)
  /// 4. Persistent URL interceptor (if enabled, native platforms only)
  /// 5. TimezoneInterceptor (always added)
  /// 6. GeneralErrorLogInterceptor (always added)
  /// 7. RefreshInterceptor (always added)
  ApiClient({
    bool shouldUsePersistentUrl = false,
    bool shouldUseDeviceInfo = false,
    bool shouldUseLanguage = true,
    RefreshInterceptor? refreshInterceptor,
  }) : dio = Dio() {
    if (refreshInterceptor != null) {
      this.refreshInterceptor = refreshInterceptor;
    }

    dio.options.baseUrl = baseUrl;

    if (shouldUseDeviceInfo) {
      dio.interceptors.add(DeviceInfoInterceptor());
    }

    if (shouldUseLanguage) {
      dio.interceptors.add(LanguageInterceptor());
    }

    dio.addCookieStorageInterceptor();
    if (shouldUsePersistentUrl) {
      dio.addBaseUrlInterceptor();
    }

    dio.interceptors
      ..add(TimezoneInterceptor())
      ..add(GeneralErrorLogInterceptor())
      ..add(this.refreshInterceptor);
  }

  /// Builds a [MultipartFile] that works across web and native platforms.
  ///
  /// This method creates a [MultipartFile] instance suitable for file uploads,
  /// handling the differences between web and native platform requirements.
  ///
  /// **Parameters:**
  /// - [filePath]: Path to file (native platforms only)
  /// - [bytes]: File content as bytes (required for web, optional for native)
  /// - [filename]: Custom filename (optional, defaults to extracted or generated name)
  ///
  /// **Platform Behavior:**
  /// - **Web:** Requires [bytes] parameter; [filePath] is ignored
  /// - **Native:** Can use either [filePath] OR [bytes]
  ///
  /// **Throws:**
  /// - [ArgumentError] if required parameters are missing for the platform
  Future<MultipartFile> _buildMultipartFile({
    String? filePath,
    Uint8List? bytes,
    String? filename,
  }) async {
    if (kIsWeb) {
      if (bytes == null) {
        throw ArgumentError(
          "On web, 'bytes' and 'filename' are required for file upload.",
        );
      }
      return MultipartFile.fromBytes(
        bytes,
        filename: filename ?? "upload.bin",
      );
    }

    if (filePath != null) {
      return MultipartFile.fromFile(
        filePath,
        filename: filename ?? basename(filePath),
      );
    }

    if (bytes != null) {
      return MultipartFile.fromBytes(
        bytes,
        filename: filename ?? "upload.bin",
      );
    }

    throw ArgumentError(
      "Provide either 'filePath' or 'bytes' to build a MultipartFile.",
    );
  }

  /// Builds [FormData] for a single file field upload.
  ///
  /// Creates a [FormData] instance containing a single file for upload requests.
  /// This is used internally by the upload methods to prepare form data.
  ///
  /// **Parameters:**
  /// - [filePath]: Path to file (native platforms only)
  /// - [bytes]: File content as bytes (required for web, optional for native)
  /// - [filename]: Custom filename (optional)
  /// - [fieldName]: Form field name for the file (default: "file")
  ///
  /// **Returns:** A [FormData] instance ready for upload
  Future<FormData> _buildSingleFileFormData({
    String? filePath,
    Uint8List? bytes,
    String? filename,
    String fieldName = "file",
  }) async {
    final multipart = await _buildMultipartFile(
      filePath: filePath,
      bytes: bytes,
      filename: filename,
    );
    return FormData.fromMap({fieldName: multipart});
  }

  /// Builds [FormData] for multiple files under the same field name.
  ///
  /// Creates a [FormData] instance containing multiple files for batch upload requests.
  /// All files are added under the same form field name but as separate entries.
  ///
  /// **Parameters:**
  /// - [filePaths]: List of file paths (native platforms only)
  /// - [filesBytes]: List of file contents as bytes (required for web, optional for native)
  /// - [filenames]: List of custom filenames (optional, must match file count if provided)
  /// - [fieldName]: Form field name for all files (default: "files")
  ///
  /// **Platform Behavior:**
  /// - **Web:** Requires [filesBytes]; [filePaths] is ignored
  /// - **Native:** Can use either [filePaths] OR [filesBytes]
  ///
  /// **Throws:**
  /// - [ArgumentError] if required parameters are missing for the platform
  ///
  /// **Returns:** A [FormData] instance with all files ready for upload
  Future<FormData> _buildMultiFilesFormData({
    List<String>? filePaths,
    List<Uint8List>? filesBytes,
    List<String>? filenames,
    String fieldName = "files",
  }) async {
    final formData = FormData();

    if (kIsWeb) {
      if (filesBytes == null || filesBytes.isEmpty) {
        throw ArgumentError(
          "On web, 'filesBytes' (and optional 'filenames') are required.",
        );
      }
      for (int i = 0; i < filesBytes.length; i++) {
        final data = filesBytes[i];
        final name = filenames != null && i < filenames.length
            ? filenames[i]
            : "upload_$i.bin";
        formData.files.add(
          MapEntry(fieldName, MultipartFile.fromBytes(data, filename: name)),
        );
      }
      return formData;
    }

    if (filePaths != null && filePaths.isNotEmpty) {
      for (final path in filePaths) {
        formData.files.add(MapEntry(
          fieldName,
          await MultipartFile.fromFile(path, filename: basename(path)),
        ));
      }
      return formData;
    }

    if (filesBytes != null && filesBytes.isNotEmpty) {
      for (int i = 0; i < filesBytes.length; i++) {
        final data = filesBytes[i];
        final name = filenames != null && i < filenames.length
            ? filenames[i]
            : "upload_$i.bin";
        formData.files.add(
          MapEntry(fieldName, MultipartFile.fromBytes(data, filename: name)),
        );
      }
      return formData;
    }

    throw ArgumentError(
      "Provide either 'filePaths' or 'filesBytes' to build multi-files FormData.",
    );
  }

  /// The base URL for API requests.
  ///
  /// This must be implemented by subclasses to specify the API endpoint.
  /// Example: "https://api.example.com/v1"
  String get baseUrl;

  /// Downloads content as bytes from a URL.
  ///
  /// Performs a GET request to download content and returns the raw bytes.
  /// Useful for downloading images, documents, or other binary content.
  ///
  /// **Parameters:**
  /// - [url]: The URL to download content from (can be absolute or relative to baseUrl)
  ///
  /// **Returns:** The downloaded content as [Uint8List]
  ///
  /// **Throws:** [DioException] if the download fails
  ///
  /// **Example:**
  /// ```dart
  /// final bytes = await client.downloadBytes('/files/document.pdf');
  /// final file = File('document.pdf');
  /// await file.writeAsBytes(bytes);
  /// ```
  Future<Uint8List> downloadBytes(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Downloads content directly to a file on the local file system.
  ///
  /// Performs a GET request and saves the response directly to disk without
  /// loading the entire content into memory. Ideal for large files.
  ///
  /// **Parameters:**
  /// - [url]: The URL to download content from (can be absolute or relative to baseUrl)
  /// - [savePath]: Directory path where the file should be saved
  /// - [filename]: Name of the file to create
  ///
  /// **Returns:**
  /// - [File] instance if download succeeds (status 200)
  /// - `null` if download fails or status is not 200
  ///
  /// **Example:**
  /// ```dart
  /// final file = await client.downloadFile(
  ///   url: '/files/large-document.pdf',
  ///   savePath: '/Downloads',
  ///   filename: 'document.pdf',
  /// );
  /// if (file != null) {
  ///   print('Downloaded to: ${file.path}');
  /// }
  /// ```
  Future<io.File?> downloadFile({
    required String url,
    required String savePath,
    required String filename,
  }) async {
    final filePath = join(savePath, filename);
    try {
      final response = await dio.download(url, filePath);
      return response.statusCode == 200 ? io.File(filePath) : null;
    } catch (e) {
      return null;
    }
  }

  /// Uploads a single file.
  ///
  /// On web, provide [bytes] and [filename]. On native, you can provide either
  /// a [filePath] or [bytes] (with optional [filename]).
  Future<File> uploadFile({
    String? filePath,
    Uint8List? bytes,
    String uploadUrl = "/upload-file",
    String? filename,
  }) async {
    try {
      final formData = await _buildSingleFileFormData(
        filePath: filePath,
        bytes: bytes,
        filename: filename,
      );
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files.
  ///
  /// On web, provide [filesBytes] and optional [filenames]. On native, you can
  /// provide either [filePaths] or [filesBytes].
  Future<List<File>> uploadFiles({
    List<String>? filePaths,
    List<Uint8List>? filesBytes,
    List<String>? filenames,
    String uploadUrl = "/multi-upload-file",
  }) async {
    try {
      final formData = await _buildMultiFilesFormData(
        filePaths: filePaths,
        filesBytes: filesBytes,
        filenames: filenames,
      );
      final response = await dio.post(uploadUrl, data: formData);
      return response.bodyAsList<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads a file using [XFile].
  ///
  /// **Deprecated:** This method will be removed in a future version.
  /// Use [uploadFile] instead. Extract data from [XFile] and pass it:
  /// ```dart
  /// await uploadFile(
  ///   filePath: file.path,  // or bytes: await file.readAsBytes()
  ///   filename: file.name,
  ///   uploadUrl: uploadUrl,
  /// );
  /// ```
  @Deprecated(
    'Use uploadFile instead. This method will be removed in v2.0.0. '
    'Extract file.path/bytes and file.name from XFile and pass to uploadFile.',
  )
  Future<File> uploadFileFromImagePicker(
    XFile file, {
    String uploadUrl = "/upload-file",
  }) async {
    try {
      final formData = await _buildSingleFileFormData(
        bytes: kIsWeb ? await file.readAsBytes() : null,
        filePath: kIsWeb ? null : file.path,
        filename: file.name,
      );
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files using [XFile].
  ///
  /// **Deprecated:** This method will be removed in a future version.
  /// Use [uploadFiles] instead. Extract data from [XFile] list and pass it:
  /// ```dart
  /// final paths = files.map((f) => f.path).toList();
  /// final names = files.map((f) => f.name).toList();
  /// await uploadFiles(
  ///   filePaths: paths,  // or filesBytes: await Future.wait(files.map((f) => f.readAsBytes()))
  ///   filenames: names,
  ///   uploadUrl: uploadUrl,
  /// );
  /// ```
  @Deprecated(
    'Use uploadFiles instead. This method will be removed in v2.0.0. '
    'Extract file paths/bytes and names from XFile list and pass to uploadFiles.',
  )
  Future<List<File>> uploadFilesFromImagePicker(
    List<XFile> files, {
    String uploadUrl = "/multi-upload-file",
  }) async {
    try {
      if (kIsWeb) {
        final bytesList = await Future.wait(files.map((f) => f.readAsBytes()));
        final names = files.map((f) => f.name).toList();
        final formData = await _buildMultiFilesFormData(
          filesBytes: bytesList,
          filenames: names,
        );
        final response = await dio.post(uploadUrl, data: formData);
        return response.bodyAsList<File>();
      } else {
        final paths = files.map((f) => f.path).toList();
        final names = files.map((f) => f.name).toList();
        final formData = await _buildMultiFilesFormData(
          filePaths: paths,
          filenames: names,
        );
        final response = await dio.post(uploadUrl, data: formData);
        return response.bodyAsList<File>();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads a file using [PlatformFile].
  ///
  /// **Deprecated:** This method will be removed in a future version.
  /// Use [uploadFile] instead. Extract data from [PlatformFile] and pass it:
  /// ```dart
  /// await uploadFile(
  ///   bytes: file.bytes,  // or filePath: file.path
  ///   filename: file.name,
  ///   uploadUrl: uploadUrl,
  /// );
  /// ```
  @Deprecated(
    'Use uploadFile instead. This method will be removed in v2.0.0. '
    'Extract file.bytes/path and file.name from PlatformFile and pass to uploadFile.',
  )
  Future<File> uploadFileFromFilePicker(
    PlatformFile file, {
    String uploadUrl = "/upload-file",
  }) async {
    try {
      final formData = await _buildSingleFileFormData(
        bytes: kIsWeb ? file.bytes : null,
        filePath: kIsWeb ? null : file.path,
        filename: file.name,
      );
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files using [PlatformFile].
  ///
  /// **Deprecated:** This method will be removed in a future version.
  /// Use [uploadFiles] instead. Extract data from [PlatformFile] list and pass it:
  /// ```dart
  /// final bytesList = files.map((f) => f.bytes).whereType<Uint8List>().toList();
  /// final paths = files.map((f) => f.path!).toList();
  /// final names = files.map((f) => f.name).toList();
  /// await uploadFiles(
  ///   filesBytes: bytesList,  // or filePaths: paths
  ///   filenames: names,
  ///   uploadUrl: uploadUrl,
  /// );
  /// ```
  @Deprecated(
    'Use uploadFiles instead. This method will be removed in v2.0.0. '
    'Extract file bytes/paths and names from PlatformFile list and pass to uploadFiles.',
  )
  Future<List<File>> uploadFilesFromFilePicker(
    List<PlatformFile> files, {
    String uploadUrl = "/multi-upload-file",
  }) async {
    try {
      if (kIsWeb) {
        final bytesList =
            files.map((f) => f.bytes).whereType<Uint8List>().toList();
        final names = files.map((f) => f.name).toList();
        final formData = await _buildMultiFilesFormData(
          filesBytes: bytesList,
          filenames: names,
        );
        final response = await dio.post(uploadUrl, data: formData);
        return response.bodyAsList<File>();
      } else {
        final paths = files.map((f) => f.path!).toList();
        final names = files.map((f) => f.name).toList();
        final formData = await _buildMultiFilesFormData(
          filePaths: paths,
          filenames: names,
        );
        final response = await dio.post(uploadUrl, data: formData);
        return response.bodyAsList<File>();
      }
    } catch (e) {
      rethrow;
    }
  }
}
