import 'package:flutter/material.dart';

/// A widget that displays an empty state with an image, title, and optional subtitle.
///
/// This component is commonly used to indicate that a list or view has no data
/// to display. It provides a centered layout with an image, title text, and
/// optional subtitle text.
///
/// **Usage:**
/// ```dart
/// // Default empty state
/// EmptyComponent()
///
/// // Custom empty state
/// EmptyComponent(
///   title: 'No items found',
///   subtitle: 'Try adjusting your filters',
///   imageUrl: 'assets/images/custom_empty.png',
///   width: 200,
///   height: 200,
/// )
/// ```
class EmptyComponent extends StatelessWidget {
  /// The default image path for empty states.
  ///
  /// Can be changed globally using [setDefaultImage].
  static String _emptyStateImage =
      'packages/supa_architecture/assets/images/empty_state.png';

  /// Sets the default image path for all [EmptyComponent] instances.
  ///
  /// This allows you to customize the default empty state image globally.
  static void setDefaultImage(String defaultImage) {
    _emptyStateImage = defaultImage;
  }

  /// The title text displayed below the image.
  ///
  /// Defaults to 'Chưa có dữ liệu' (No data in Vietnamese) if not provided.
  final String title;

  /// The width of the empty state image in logical pixels.
  ///
  /// If null, the image will use its intrinsic width.
  final double? width;

  /// The height of the empty state image in logical pixels.
  ///
  /// If null, the image will use its intrinsic height.
  final double? height;

  /// Optional subtitle text displayed below the title.
  ///
  /// Defaults to 'Keep up the good work!' if not provided.
  final String? subtitle;

  /// The path to the image asset to display.
  ///
  /// If not provided, uses the default empty state image set via
  /// [setDefaultImage] or the package default.
  final String? imageUrl;

  /// Creates an [EmptyComponent] widget.
  ///
  /// **Parameters:**
  /// - `title`: The title text displayed below the image (defaults to 'Chưa có dữ liệu').
  /// - `subtitle`: Optional subtitle text displayed below the title (defaults to 'Keep up the good work!').
  /// - `imageUrl`: Path to the image asset (optional, uses default if not provided).
  /// - `width`: Width of the image in logical pixels (optional).
  /// - `height`: Height of the image in logical pixels (optional).
  const EmptyComponent({
    super.key,
    this.title = 'Chưa có dữ liệu',
    this.subtitle = 'Keep up the good work!',
    this.imageUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            width: width,
            height: height,
            image: AssetImage(
              imageUrl ?? _emptyStateImage,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }
}
