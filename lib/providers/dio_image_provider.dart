import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:supa_architecture/api_client/interceptors/device_info_interceptor.dart';
import 'package:supa_architecture/api_client/interceptors/refresh_interceptor.dart';
import 'package:supa_architecture/api_client/interceptors/timezone_interceptor.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

/// A custom [ImageProvider] implementation that uses [Dio] to fetch images from network URLs
/// with automatic fallback to a local asset image when network requests fail.
///
/// This provider extends Flutter's [ImageProvider] to leverage Dio's advanced HTTP capabilities,
/// including:
/// - Custom interceptors for device information, timezone, and token refresh
/// - Cookie storage integration (on non-web platforms)
/// - Automatic error handling with graceful fallback to asset images
///
/// The provider is designed to work seamlessly with Flutter's image loading system,
/// allowing it to be used with [Image] widgets or other image-consuming widgets.
///
/// Example usage:
/// ```dart
/// Image(
///   image: DioImageProvider(
///     imageUrl: Uri.parse('https://example.com/image.jpg'),
///     fallbackAssetPath: 'assets/images/placeholder.png',
///   ),
/// )
/// ```
class DioImageProvider extends ImageProvider<DioImageProvider> {
  /// The Dio HTTP client instance used for network requests.
  ///
  /// This instance is automatically configured with interceptors for device info,
  /// timezone, token refresh, and cookie storage (on non-web platforms).
  final Dio dio;

  /// The network URL from which to fetch the image.
  ///
  /// This must be a valid HTTP or HTTPS URL that points to an image resource.
  final Uri imageUrl;

  /// The path to the fallback asset image that will be used if the network request fails.
  ///
  /// This should be a valid asset path as registered in your `pubspec.yaml` file.
  /// For example: `'assets/images/placeholder.png'`
  final String fallbackAssetPath;

  /// Creates a new [DioImageProvider] instance.
  ///
  /// The provider will attempt to load the image from [imageUrl] first. If that fails
  /// for any reason (network error, invalid response, etc.), it will automatically
  /// fall back to loading the image from [fallbackAssetPath].
  ///
  /// The internal [Dio] instance is automatically configured with the following interceptors:
  /// - [DeviceInfoInterceptor]: Adds device information to requests
  /// - [TimezoneInterceptor]: Adds timezone information to requests
  /// - [RefreshInterceptor]: Handles token refresh logic
  /// - Cookie storage interceptor (on non-web platforms only)
  ///
  /// Parameters:
  /// - [imageUrl]: The network URL of the image to load
  /// - [fallbackAssetPath]: The asset path to use if the network image fails to load
  DioImageProvider({
    required this.imageUrl,
    required this.fallbackAssetPath,
  }) : dio = Dio() {
    if (!kIsWeb) {
      dio.interceptors.add(
        SupaArchitecturePlatform.instance.cookieStorage.interceptor,
      );
    }
    dio.interceptors.add(DeviceInfoInterceptor());
    dio.interceptors.add(TimezoneInterceptor());
    dio.interceptors.add(RefreshInterceptor());
  }

  /// Returns a synchronous future containing this provider instance as the key.
  ///
  /// This method is required by [ImageProvider] and is used by Flutter's image
  /// loading system to identify and cache image instances.
  @override
  Future<DioImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImageProvider>(this);
  }

  /// Loads the image and returns an [ImageStreamCompleter] that will provide
  /// the decoded image data.
  ///
  /// This method is called by Flutter's image loading system when an image
  /// needs to be loaded. It delegates the actual loading to [_loadAsync].
  ///
  /// Parameters:
  /// - [key]: The image provider key (this instance)
  /// - [decode]: The decoder callback provided by Flutter for decoding image bytes
  ///
  /// Returns an [ImageStreamCompleter] that will complete with the loaded image.
  @override
  ImageStreamCompleter loadImage(
    DioImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  /// Asynchronously loads the image from the network URL or falls back to the asset image.
  ///
  /// This method first attempts to fetch the image from [imageUrl] using the configured
  /// [Dio] instance. If the network request succeeds, the image bytes are decoded and
  /// returned as an [ImageInfo] object.
  ///
  /// If the network request fails for any reason (network error, timeout, invalid response,
  /// etc.), the method catches the error, logs it for debugging purposes, and automatically
  /// falls back to loading the image from [fallbackAssetPath] using Flutter's asset system.
  ///
  /// The fallback mechanism ensures that the UI always displays an image, even when network
  /// conditions are poor or the remote image is unavailable.
  ///
  /// Parameters:
  /// - [key]: The image provider key (this instance)
  /// - [decode]: The decoder callback provided by Flutter for decoding image bytes
  ///
  /// Returns an [ImageInfo] object containing the decoded image, either from the network
  /// or from the fallback asset.
  ///
  /// Throws:
  /// - If both the network request and the asset loading fail, the exception from
  ///   the asset loading will be thrown.
  Future<ImageInfo> _loadAsync(
    DioImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Attempt to load the image from the network URL using Dio.
      final response = await dio.get<List<int>>(
        imageUrl.toString(),
        options: Options(responseType: ResponseType.bytes),
      );

      // Validate that the response contains image data.
      if (response.data == null) {
        throw Exception("Network response contains no image data.");
      }

      // Convert the response data to Uint8List and decode it.
      final Uint8List bytes = Uint8List.fromList(response.data!);
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return ImageInfo(image: frameInfo.image);
    } catch (e, stackTrace) {
      // Log the error for debugging purposes.
      debugPrint('Failed to load network image: $imageUrl. Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Fall back to loading the image from the asset bundle.
      // This ensures the UI always has an image to display, even when network fails.
      final ByteData assetData = await rootBundle.load(fallbackAssetPath);
      final Uint8List bytes = assetData.buffer.asUint8List();

      // Decode the asset image using the same decoder callback.
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return ImageInfo(image: frameInfo.image);
    }
  }

  /// Equality operator for comparing two [DioImageProvider] instances.
  ///
  /// Two providers are considered equal if they have the same [imageUrl] and
  /// [fallbackAssetPath]. This is used by Flutter's image caching system to
  /// determine if two providers refer to the same image resource.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    final DioImageProvider typedOther = other as DioImageProvider;
    return imageUrl == typedOther.imageUrl &&
        fallbackAssetPath == typedOther.fallbackAssetPath;
  }

  /// Returns a hash code based on [imageUrl] and [fallbackAssetPath].
  ///
  /// This is used in conjunction with [operator ==] to support efficient
  /// lookups in hash-based collections like [Set] and [Map].
  @override
  int get hashCode => Object.hash(imageUrl, fallbackAssetPath);

  /// Returns a string representation of this provider for debugging purposes.
  ///
  /// The string includes the provider type, the image URL, and the fallback asset path.
  @override
  String toString() {
    return '${objectRuntimeType(this, "DioImageProvider")}'
        '(url: $imageUrl, fallback: $fallbackAssetPath)';
  }
}
