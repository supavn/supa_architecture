import 'package:flutter/material.dart';

/// A centered circular progress indicator widget with customizable size and color.
///
/// This widget displays a loading spinner that is commonly used to indicate
/// that an operation is in progress. It is automatically centered within its
/// parent widget.
///
/// **Usage:**
/// ```dart
/// // Default loading indicator
/// LoadingIndicator()
///
/// // Custom sized and colored indicator
/// LoadingIndicator(
///   size: 48,
///   color: Colors.blue,
/// )
/// ```
class LoadingIndicator extends StatelessWidget {
  /// The size of the loading indicator in logical pixels.
  ///
  /// Both width and height will be set to this value.
  /// Defaults to 32 if not specified.
  final double? size;

  /// The color of the loading indicator.
  ///
  /// If null, the indicator will use the theme's primary color.
  final Color? color;

  /// Creates a [LoadingIndicator] widget.
  ///
  /// **Parameters:**
  /// - `size`: The size of the loading indicator in logical pixels (default is 32).
  /// - `color`: The color of the loading indicator (optional, uses theme primary color if not provided).
  const LoadingIndicator({
    super.key,
    this.size = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
