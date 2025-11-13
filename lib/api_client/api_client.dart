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

/// Unified API Client class for handling HTTP requests and file uploads.
abstract class ApiClient {
  CookieManager get cookieStorage => GetIt.instance.get<CookieManager>();
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();
  SecureStorage get secureStorage => GetIt.instance.get<SecureStorage>();

  final Dio dio;

  RefreshInterceptor refreshInterceptor = RefreshInterceptor();

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
    dio.addBaseUrlInterceptor();

    dio.interceptors
      ..add(TimezoneInterceptor())
      ..add(GeneralErrorLogInterceptor())
      ..add(this.refreshInterceptor);
  }

  /// Builds a [MultipartFile] that works across web and native.
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

  /// Builds [FormData] for a single file field.
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

  /// Builds [FormData] for multiple files under the same field.
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
  String get baseUrl;

  /// Downloads content as bytes from a URL.
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

  /// Downloads content to a file.
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
