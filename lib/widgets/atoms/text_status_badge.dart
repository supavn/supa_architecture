import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';

/// A customizable badge widget for displaying status text with automatic
/// text color adjustment based on background luminance.
///
/// This widget supports multiple ways to specify colors:
/// - Direct color values via [color], [backgroundColor], and [borderColor]
/// - Theme token keys via [textColorKey], [backgroundColorKey], and [borderColorKey]
/// - Hex color strings (e.g., '#FF0000') via the key parameters
///
/// The text color automatically adjusts to black or white based on the
/// background color's luminance for optimal readability.
///
/// **Usage:**
/// ```dart
/// // Using theme tokens
/// TextStatusBadge(
///   status: 'Active',
///   backgroundColorKey: 'success',
///   textColorKey: 'onSuccess',
/// )
///
/// // Using hex colors
/// TextStatusBadge(
///   status: 'Pending',
///   backgroundColorKey: '#FFA500',
/// )
///
/// // Using direct colors
/// TextStatusBadge(
///   status: 'Inactive',
///   backgroundColor: Colors.grey,
///   color: Colors.white,
/// )
/// ```
class TextStatusBadge extends StatelessWidget {
  /// Determines the appropriate text color (black or white) based on the
  /// background color's luminance for optimal readability.
  ///
  /// Returns black if the background luminance is greater than 0.5,
  /// otherwise returns white.
  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  /// The status text to display in the badge.
  final String status;

  /// The explicit text color for the status text.
  ///
  /// If not provided, the color will be determined from [textColorKey] or
  /// automatically calculated based on background luminance.
  final Color? color;

  /// Theme token key or hex color string for the text color.
  ///
  /// Examples: 'warning', 'error', '#FFFFFF', '#000000'
  /// If this is a hex string (starts with '#'), it will be parsed as a hex color.
  /// Otherwise, it will be resolved from the theme's extended color scheme.
  final String? textColorKey;

  /// Theme token key or hex color string for the background color.
  ///
  /// This is the preferred way to specify background color over [backgroundColor].
  /// Examples: 'success', 'warning', '#FF0000'
  /// If this is a hex string (starts with '#'), it will be parsed as a hex color.
  /// Otherwise, it will be resolved from the theme's extended color scheme.
  final String? backgroundColorKey;

  /// The explicit background color for the badge.
  ///
  /// **Deprecated:** Use [backgroundColorKey] or theme tokens instead.
  /// This property will be removed in a future release.
  // @Deprecated(
  //     'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
  final Color? backgroundColor;

  /// The explicit border color for the badge.
  ///
  /// Prefer [borderColorKey] for theme tokens or hex colors.
  final Color? borderColor;

  /// Theme token key or hex color string for the border color.
  ///
  /// Examples: 'outline', '#CCCCCC'
  /// If this is a hex string (starts with '#'), it will be parsed as a hex color.
  /// Otherwise, it will be resolved from the theme's extended color scheme.
  final String? borderColorKey;

  /// Creates a [TextStatusBadge] widget.
  ///
  /// **Parameters:**
  /// - `status`: The status text to display (required).
  /// - `color`: Explicit text color (optional, defaults to black).
  /// - `textColorKey`: Theme token key or hex string for text color (optional).
  /// - `backgroundColorKey`: Theme token key or hex string for background color (preferred).
  /// - `backgroundColor`: Explicit background color (deprecated, use backgroundColorKey instead).
  /// - `borderColor`: Explicit border color (optional).
  /// - `borderColorKey`: Theme token key or hex string for border color (optional).
  ///
  /// **Note:** Color resolution priority:
  /// 1. Explicit color values ([color], [backgroundColor], [borderColor])
  /// 2. Theme token keys or hex strings ([textColorKey], [backgroundColorKey], [borderColorKey])
  /// 3. Default theme tokens ('default' group) if no keys provided
  /// 4. Automatic text color calculation based on background luminance
  const TextStatusBadge({
    super.key,
    required this.status,
    // @Deprecated(
    //     'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
    this.backgroundColor, // Default background color
    this.color = const Color(0xFF000000), // Default text color
    this.textColorKey,
    this.backgroundColorKey,
    this.borderColor,
    this.borderColorKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeExtension =
        Theme.of(context).extension<SupaExtendedColorScheme>();

    Color? resolvedBackgroundColor;
    Color? resolvedTextColor;
    Color? resolvedBorderColor;

    bool isHex(String? v) => v != null && v.trim().startsWith('#');

    String? normalizeKey(String? key) {
      if (key == null) return null;
      final trimmed = key.trim();
      if (trimmed.isEmpty) return null;
      return trimmed.toLowerCase();
    }

    final String? textKey = normalizeKey(textColorKey);
    final String? bgKey = normalizeKey(backgroundColorKey);
    final String? borderKey = normalizeKey(borderColorKey);

    if (bgKey != null) {
      if (isHex(bgKey)) {
        resolvedBackgroundColor = HexColor.fromHex(bgKey);
      } else if (themeExtension != null) {
        resolvedBackgroundColor = themeExtension.getBackgroundColor(bgKey);
      }
    }

    if (textKey != null) {
      if (isHex(textKey)) {
        resolvedTextColor = HexColor.fromHex(textKey);
      } else if (themeExtension != null) {
        resolvedTextColor = themeExtension.getTextColor(textKey);
      }
    }

    if (borderKey != null) {
      if (isHex(borderKey)) {
        resolvedBorderColor = HexColor.fromHex(borderKey);
      } else if (themeExtension != null) {
        resolvedBorderColor = themeExtension.getBorderColor(borderKey);
      }
    }

    // Default to 'default' token group if neither key provided
    if (bgKey == null &&
        textKey == null &&
        borderKey == null &&
        themeExtension != null) {
      resolvedBackgroundColor = themeExtension.getBackgroundColor('default');
      resolvedTextColor = themeExtension.getTextColor('default');
      resolvedBorderColor = themeExtension.getBorderColor('default');
    }

    final Color effectiveBackgroundColor =
        resolvedBackgroundColor ?? backgroundColor ?? const Color(0xFFFDDC69);
    final Color effectiveTextColor = resolvedTextColor ??
        color ??
        getTextColorBasedOnBackground(effectiveBackgroundColor);
    final Color effectiveBorderColor =
        borderColor ?? resolvedBorderColor ?? Colors.transparent;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      decoration: ShapeDecoration(
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: effectiveBorderColor,
            width: 1,
          ),
        ),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: effectiveTextColor,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
