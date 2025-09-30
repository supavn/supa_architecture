import 'package:flutter/material.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/widgets/atoms/text_status_badge.dart';

class EnumStatusBadge extends StatelessWidget {
  final EnumModel status;

  @Deprecated(
      'Use backgroundColorKey via EnumModel.backgroundColor or theme tokens; this prop will be removed in a future release.')
  final Color? backgroundColor;

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
    );
  }
}
