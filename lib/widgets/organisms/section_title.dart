import 'package:flutter/material.dart';

/// A widget that displays a section title with optional padding.
///
/// This widget renders a title text in uppercase with secondary color styling,
/// commonly used to separate sections in lists or forms. The title is styled
/// using the theme's bodyLarge text style with secondary color.
///
/// **Usage:**
/// ```dart
/// // Section title with default padding
/// SectionTitle(title: 'Settings')
///
/// // Section title without padding
/// SectionTitle(
///   title: 'Profile',
///   showPadding: false,
/// )
/// ```
class SectionTitle extends StatelessWidget {
  /// The title text to display (will be converted to uppercase).
  final String title;

  /// Whether to apply horizontal and vertical padding around the title.
  ///
  /// When true, applies symmetric padding (vertical: 8, horizontal: 16).
  /// Defaults to true.
  final bool showPadding;

  /// Creates a [SectionTitle] widget.
  ///
  /// **Parameters:**
  /// - `title`: The title text to display, will be converted to uppercase (required).
  /// - `showPadding`: Whether to apply padding around the title (defaults to true).
  const SectionTitle({
    super.key,
    required this.title,
    this.showPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: showPadding
          ? const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            )
          : null,
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
