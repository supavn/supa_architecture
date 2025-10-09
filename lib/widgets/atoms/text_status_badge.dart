import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';

/// A badge widget to display status with automatic text color adjustment
/// based on the background color's luminance.
class TextStatusBadge extends StatelessWidget {
  /// Determines whether the text color should be black or white
  /// based on the luminance of the background color.
  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  final String status;

  /// Either provide explicit [color] or a [textColorKey] (token key or hex '#xxxxxx').
  final Color? color;

  /// Token key or hex for text color (e.g., 'warning' or '#FFFFFF').
  final String? textColorKey;

  /// Token key or hex for background color (preferred over deprecated [backgroundColor]).
  final String? backgroundColorKey;

  /// Either provide explicit [backgroundColor] or a [backgroundColorKey] (token key or hex '#xxxxxx').
  // @Deprecated(
  //     'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
  final Color backgroundColor;

  /// Optional explicit border color. Prefer [borderColorKey] for tokens/hex.
  final Color? borderColor;

  /// Token key or hex for border color.
  final String? borderColorKey;

  const TextStatusBadge({
    super.key,
    required this.status,
    // @Deprecated(
    //     'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
    this.backgroundColor = const Color(0xFFFDDC69), // Default background color
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
        resolvedBackgroundColor ?? backgroundColor;
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
