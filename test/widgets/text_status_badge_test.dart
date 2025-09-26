import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';
import 'package:supa_architecture/widgets/atoms/text_status_badge.dart';

SupaExtendedColorScheme buildTestScheme() {
  // Simple deterministic colors
  Color c(int v) => Color(0xFF000000 | v);
  return SupaExtendedColorScheme(
    warningText: c(0x111111),
    warningBackground: c(0xAAAAAA),
    warningBorder: c(0xBBBBBB),
    informationText: c(0x121212),
    informationBackground: c(0xCCCCCC),
    informationBorder: c(0xCDCDCD),
    successText: c(0x131313),
    successBackground: c(0xDDDDDD),
    successBorder: c(0xDEDEDE),
    defaultText: c(0x141414),
    defaultBackground: c(0xEEEEEE),
    defaultBorder: c(0xEFEFEF),
    errorText: c(0x151515),
    errorBackground: c(0xABABAB),
    errorBorder: c(0xACACAC),
    blueTagText: c(0x161616),
    blueTagBackground: c(0xA1A1A1),
    blueTagBorder: c(0xA2A2A2),
    cyanTagText: c(0x171717),
    cyanTagBackground: c(0xA3A3A3),
    cyanTagBorder: c(0xA4A4A4),
    geekblueTagText: c(0x181818),
    geekblueTagBackground: c(0xA5A5A5),
    geekblueTagBorder: c(0xA6A6A6),
    goldTagText: c(0x191919),
    goldTagBackground: c(0xA7A7A7),
    goldTagBorder: c(0xA8A8A8),
    greenTagText: c(0x1A1A1A),
    greenTagBackground: c(0xA9A9A9),
    greenTagBorder: c(0xAAAAAA),
    limeTagText: c(0x1B1B1B),
    limeTagBackground: c(0xB1B1B1),
    limeTagBorder: c(0xB2B2B2),
    magentaTagText: c(0x1C1C1C),
    magentaTagBackground: c(0xB3B3B3),
    magentaTagBorder: c(0xB4B4B4),
    orangeTagText: c(0x1D1D1D),
    orangeTagBackground: c(0xB5B5B5),
    orangeTagBorder: c(0xB6B6B6),
    purpleTagText: c(0x1E1E1E),
    purpleTagBackground: c(0xB7B7B7),
    purpleTagBorder: c(0xB8B8B8),
    redTagText: c(0x1F1F1F),
    redTagBackground: c(0xB9B9B9),
    redTagBorder: c(0xBABABA),
    volcanoTagText: c(0x202020),
    volcanoTagBackground: c(0xBCBCBC),
    volcanoTagBorder: c(0xBDBDBD),
  );
}

ThemeData buildTheme() {
  return ThemeData(extensions: <ThemeExtension<dynamic>>[buildTestScheme()]);
}

void main() {
  testWidgets('resolves token keys for text/background/border', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: const Scaffold(
          body: TextStatusBadge(
            status: 'Processing',
            textColorKey: 'information',
            backgroundColorKey: 'information',
            borderColorKey: 'information',
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as ShapeDecoration;
    final bg = decoration.color as Color;
    final side = (decoration.shape as RoundedRectangleBorder).side;

    final scheme = buildTestScheme();
    expect(bg, equals(scheme.informationBackground));
    expect(side.color, equals(scheme.informationBorder));

    final text = tester.widget<Text>(find.text('Processing'));
    expect(text.style?.color, equals(scheme.informationText));
  });

  testWidgets('resolves hex for text/background/border', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextStatusBadge(
            status: 'Hex',
            textColorKey: '#0000FF',
            backgroundColorKey: '#00FF00',
            borderColorKey: '#FF0000',
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as ShapeDecoration;
    final bg = decoration.color as Color;
    final side = (decoration.shape as RoundedRectangleBorder).side;
    expect(bg, equals(const Color(0xFF00FF00)));
    expect(side.color, equals(const Color(0xFFFF0000)));

    final text = tester.widget<Text>(find.text('Hex'));
    expect(text.style?.color, equals(const Color(0xFF0000FF)));
  });

  testWidgets('defaults to theme default group when no keys provided',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: const Scaffold(
          body: TextStatusBadge(
            status: 'Default',
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as ShapeDecoration;
    final bg = decoration.color as Color;
    final side = (decoration.shape as RoundedRectangleBorder).side;

    final scheme = buildTestScheme();
    expect(bg, equals(scheme.defaultBackground));
    expect(side.color, equals(scheme.defaultBorder));
    final text = tester.widget<Text>(find.text('Default'));
    expect(text.style?.color, equals(scheme.defaultText));
  });
}
