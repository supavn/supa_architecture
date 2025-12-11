import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/widgets/atoms/text_status_badge.dart';

/// A badge widget that displays status information from an [EnumModel].
///
/// This widget automatically extracts color and background color information
/// from the [EnumModel] and renders it using [TextStatusBadge]. If the color
/// is a hex value and no background color is provided, it automatically
/// creates a semi-transparent background using the color value.
///
/// **Usage:**
/// ```dart
/// EnumStatusBadge(
///   status: myEnumModel,
/// )
/// ```
class EnumStatusBadge extends StatelessWidget {
  /// The enum model containing status information including name, color, and background color.
  final EnumModel status;

  /// The explicit background color for the badge.
  ///
  /// **Deprecated:** Use [EnumModel.backgroundColor] or theme tokens instead.
  /// This property will be removed in a future release.
  @Deprecated(
      'Use backgroundColorKey via EnumModel.backgroundColor or theme tokens; this prop will be removed in a future release.')
  final Color? backgroundColor;

  /// Creates an [EnumStatusBadge] widget.
  ///
  /// **Parameters:**
  /// - `status`: The enum model containing status information (required).
  /// - `backgroundColor`: Explicit background color (deprecated, use EnumModel.backgroundColor instead).
  ///
  /// **Note:** The widget automatically handles color resolution:
  /// - If the color is a hex value and no background color is provided, it creates a semi-transparent background
  /// - If the color is a theme token and no background color is provided, it reuses the color token for the background
  const EnumStatusBadge({
    super.key,
    required this.status,
    @Deprecated(
        'Use backgroundColorKey via EnumModel.backgroundColor or theme tokens; this prop will be removed in a future release.')
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final String? colorKey = status.color.rawValue?.trim();
    final String? bgRaw = status.backgroundColor.rawValue?.trim();
    final bool hasBg = bgRaw != null && bgRaw.isNotEmpty;
    final bool colorIsHex = colorKey != null && colorKey.startsWith('#');

    Color? calculatedBgColor;
    Color? calculatedBorderColor;

    if (!hasBg && colorIsHex) {
      final Color baseColor = HexColor.fromHex(colorKey);
      calculatedBgColor = baseColor.withAlpha(26);
      calculatedBorderColor = baseColor.withAlpha(26);
    }

    // If backgroundColor missing and color is a token (not hex), reuse color for background
    final String? effectiveBgKey = hasBg
        ? bgRaw
        : (colorKey != null && colorKey.isNotEmpty && !colorIsHex
            ? colorKey
            : null);

    return TextStatusBadge(
      status: status.name.rawValue ?? 'Đang tải',
      textColorKey: colorKey ?? 'default',
      backgroundColorKey: effectiveBgKey,
      borderColorKey: effectiveBgKey,
      backgroundColor: calculatedBgColor,
      borderColor: calculatedBorderColor,
    );
  }
}
