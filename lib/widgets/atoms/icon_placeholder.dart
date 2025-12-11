import 'package:flutter/material.dart';

/// A widget that renders an empty space with specified dimensions.
///
/// This widget is useful for maintaining consistent spacing in layouts where
/// an icon would normally appear, ensuring proper alignment even when no icon
/// is displayed.
///
/// **Usage:**
/// ```dart
/// // Default 24x24 placeholder
/// IconPlaceholder()
///
/// // Custom sized placeholder
/// IconPlaceholder(size: 32)
/// ```
class IconPlaceholder extends StatelessWidget {
  /// The size of the placeholder in logical pixels.
  ///
  /// Both width and height will be set to this value.
  /// Defaults to 24 if not specified.
  final double? size;

  /// Creates an [IconPlaceholder] widget.
  ///
  /// **Parameters:**
  /// - `size`: The size of the placeholder in logical pixels (default is 24).
  const IconPlaceholder({
    super.key,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
