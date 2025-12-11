import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/supa_architecture.dart' hide Image;

/// A widget that displays an image from a file or URL path with automatic
/// authentication and fallback placeholder support.
///
/// This widget handles image loading from the API base URL, automatically
/// includes authentication cookies, and displays a placeholder image if the
/// image fails to load.
///
/// **Usage:**
/// ```dart
/// // Display image from a file
/// AppImage(
///   image: myFile,
///   width: 200,
///   height: 200,
/// )
///
/// // Display image from a path
/// AppImage(
///   imagePath: '/images/avatar.jpg',
///   width: 100,
///   height: 100,
/// )
/// ```
class AppImage extends StatelessWidget {
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();

  CookieManager get cookieManager => GetIt.instance.get<CookieManager>();

  /// The file object containing the image to display.
  ///
  /// If provided, the image URL will be constructed from the file's URL value.
  /// Either [image] or [imagePath] should be provided, but not both.
  final File? image;

  /// The path to the image relative to the API base URL.
  ///
  /// If provided, this path will be appended to the base API URL.
  /// Either [image] or [imagePath] should be provided, but not both.
  final String? imagePath;

  /// The width of the image widget.
  ///
  /// If null, the image will size itself based on its intrinsic dimensions.
  final double? width;

  /// The height of the image widget.
  ///
  /// If null, the image will size itself based on its intrinsic dimensions.
  final double? height;

  /// Creates an [AppImage] widget.
  ///
  /// **Parameters:**
  /// - `image`: The file object containing the image (optional).
  /// - `imagePath`: The path to the image relative to the API base URL (optional).
  /// - `width`: The width of the image widget (optional).
  /// - `height`: The height of the image widget (optional).
  ///
  /// **Note:** Either [image] or [imagePath] should be provided, but not both.
  const AppImage({
    super.key,
    this.image,
    this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final url =
        '${persistentStorage.baseApiUrl}${image?.url.value ?? imagePath}';

    return Image(
      width: width,
      height: height,
      fit: BoxFit.cover,
      image: DioImageProvider(
        imageUrl: Uri.parse(url),
        fallbackAssetPath:
            'packages/supa_architecture/assets/images/image_placeholder.png',
      ),
    );
  }
}
