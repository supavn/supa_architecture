import 'package:flutter/material.dart';

import 'supa_extended_color_token_group.dart';

// Semantic status color token names
const String _default = 'default';
const String _warning = 'warning';
const String _information = 'information';
const String _success = 'success';
const String _error = 'error';

// Tag color token names
const String _blueTag = 'blue';
const String _cyanTag = 'cyan';
const String _geekblueTag = 'geekblue';
const String _goldTag = 'gold';
const String _greenTag = 'green';
const String _limeTag = 'lime';
const String _magentaTag = 'magenta';
const String _orangeTag = 'orange';
const String _purpleTag = 'purple';
const String _redTag = 'red';
const String _volcanoTag = 'volcano';

// Alias status token names (mapped to semantic colors)
const String _processing = 'processing'; // Maps to information
const String _critical = 'critical'; // Maps to error

/// An extended color scheme that provides semantic color tokens for UI components.
///
/// This class extends Flutter's [ThemeExtension] to provide a comprehensive set
/// of color tokens beyond the standard Material Design color scheme. It includes:
///
/// **Semantic Status Colors:**
/// - Warning: For warning messages and alerts
/// - Information: For informational messages and processing states
/// - Success: For success messages and positive feedback
/// - Error: For error messages and critical alerts
/// - Default: For neutral/default states
///
/// **Tag Colors:**
/// A wide variety of tag colors (blue, cyan, geekblue, gold, green, lime,
/// magenta, orange, purple, red, volcano) for categorizing and organizing content.
///
/// Each color category provides three tokens:
/// - Text color: For text content
/// - Background color: For component backgrounds
/// - Border color: For component borders
///
/// This scheme can be integrated into a Flutter [ThemeData] using the
/// [ThemeData.extensions] property, allowing you to access these colors
/// throughout your app via `Theme.of(context).extension<SupaExtendedColorScheme>()`.
///
/// Example usage:
/// ```dart
/// final theme = ThemeData(
///   extensions: <ThemeExtension<dynamic>>[
///     SupaExtendedColorScheme(
///       warningText: Colors.orange.shade900,
///       warningBackground: Colors.orange.shade50,
///       warningBorder: Colors.orange.shade300,
///       // ... other colors
///     ),
///   ],
/// );
/// ```
class SupaExtendedColorScheme extends ThemeExtension<SupaExtendedColorScheme> {
  // Semantic status colors

  /// Text color for warning states and messages.
  final Color warningText;

  /// Background color for warning components.
  final Color warningBackground;

  /// Border color for warning components.
  final Color warningBorder;

  /// Text color for informational states and messages.
  final Color informationText;

  /// Background color for informational components.
  final Color informationBackground;

  /// Border color for informational components.
  final Color informationBorder;

  /// Text color for success states and messages.
  final Color successText;

  /// Background color for success components.
  final Color successBackground;

  /// Border color for success components.
  final Color successBorder;

  /// Text color for default/neutral states.
  final Color defaultText;

  /// Background color for default components.
  final Color defaultBackground;

  /// Border color for default components.
  final Color defaultBorder;

  /// Text color for error states and messages.
  final Color errorText;

  /// Background color for error components.
  final Color errorBackground;

  /// Border color for error components.
  final Color errorBorder;

  // Tag color variants

  /// Text color for blue-tagged components.
  final Color blueTagText;

  /// Background color for blue-tagged components.
  final Color blueTagBackground;

  /// Border color for blue-tagged components.
  final Color blueTagBorder;

  /// Text color for cyan-tagged components.
  final Color cyanTagText;

  /// Background color for cyan-tagged components.
  final Color cyanTagBackground;

  /// Border color for cyan-tagged components.
  final Color cyanTagBorder;

  /// Text color for geekblue-tagged components.
  final Color geekblueTagText;

  /// Background color for geekblue-tagged components.
  final Color geekblueTagBackground;

  /// Border color for geekblue-tagged components.
  final Color geekblueTagBorder;

  /// Text color for gold-tagged components.
  final Color goldTagText;

  /// Background color for gold-tagged components.
  final Color goldTagBackground;

  /// Border color for gold-tagged components.
  final Color goldTagBorder;

  /// Text color for green-tagged components.
  final Color greenTagText;

  /// Background color for green-tagged components.
  final Color greenTagBackground;

  /// Border color for green-tagged components.
  final Color greenTagBorder;

  /// Text color for lime-tagged components.
  final Color limeTagText;

  /// Background color for lime-tagged components.
  final Color limeTagBackground;

  /// Border color for lime-tagged components.
  final Color limeTagBorder;

  /// Text color for magenta-tagged components.
  final Color magentaTagText;

  /// Background color for magenta-tagged components.
  final Color magentaTagBackground;

  /// Border color for magenta-tagged components.
  final Color magentaTagBorder;

  /// Text color for orange-tagged components.
  final Color orangeTagText;

  /// Background color for orange-tagged components.
  final Color orangeTagBackground;

  /// Border color for orange-tagged components.
  final Color orangeTagBorder;

  /// Text color for purple-tagged components.
  final Color purpleTagText;

  /// Background color for purple-tagged components.
  final Color purpleTagBackground;

  /// Border color for purple-tagged components.
  final Color purpleTagBorder;

  /// Text color for red-tagged components.
  final Color redTagText;

  /// Background color for red-tagged components.
  final Color redTagBackground;

  /// Border color for red-tagged components.
  final Color redTagBorder;

  /// Text color for volcano-tagged components.
  final Color volcanoTagText;

  /// Background color for volcano-tagged components.
  final Color volcanoTagBackground;

  /// Border color for volcano-tagged components.
  final Color volcanoTagBorder;

  /// Creates a new [SupaExtendedColorScheme] with all color tokens.
  ///
  /// All parameters are required. Each color category (status or tag) requires
  /// three colors: text, background, and border.
  const SupaExtendedColorScheme({
    required this.warningText,
    required this.warningBackground,
    required this.warningBorder,
    required this.informationText,
    required this.informationBackground,
    required this.informationBorder,
    required this.successText,
    required this.successBackground,
    required this.successBorder,
    required this.defaultText,
    required this.defaultBackground,
    required this.defaultBorder,
    required this.errorText,
    required this.errorBackground,
    required this.errorBorder,
    required this.blueTagText,
    required this.blueTagBackground,
    required this.blueTagBorder,
    required this.cyanTagText,
    required this.cyanTagBackground,
    required this.cyanTagBorder,
    required this.geekblueTagText,
    required this.geekblueTagBackground,
    required this.geekblueTagBorder,
    required this.goldTagText,
    required this.goldTagBackground,
    required this.goldTagBorder,
    required this.greenTagText,
    required this.greenTagBackground,
    required this.greenTagBorder,
    required this.limeTagText,
    required this.limeTagBackground,
    required this.limeTagBorder,
    required this.magentaTagText,
    required this.magentaTagBackground,
    required this.magentaTagBorder,
    required this.orangeTagText,
    required this.orangeTagBackground,
    required this.orangeTagBorder,
    required this.purpleTagText,
    required this.purpleTagBackground,
    required this.purpleTagBorder,
    required this.redTagText,
    required this.redTagBackground,
    required this.redTagBorder,
    required this.volcanoTagText,
    required this.volcanoTagBackground,
    required this.volcanoTagBorder,
  });

  /// Creates a copy of this color scheme with the given fields replaced.
  ///
  /// Any parameter that is not provided will use the value from the current
  /// instance. This is useful for creating variations of a color scheme or
  /// updating specific colors while keeping others unchanged.
  @override
  ThemeExtension<SupaExtendedColorScheme> copyWith({
    Color? warningText,
    Color? warningBackground,
    Color? warningBorder,
    Color? informationText,
    Color? informationBackground,
    Color? informationBorder,
    Color? successText,
    Color? successBackground,
    Color? successBorder,
    Color? defaultText,
    Color? defaultBackground,
    Color? defaultBorder,
    Color? errorText,
    Color? errorBackground,
    Color? errorBorder,
    Color? blueTagText,
    Color? blueTagBackground,
    Color? blueTagBorder,
    Color? cyanTagText,
    Color? cyanTagBackground,
    Color? cyanTagBorder,
    Color? geekblueTagText,
    Color? geekblueTagBackground,
    Color? geekblueTagBorder,
    Color? goldTagText,
    Color? goldTagBackground,
    Color? goldTagBorder,
    Color? greenTagText,
    Color? greenTagBackground,
    Color? greenTagBorder,
    Color? limeTagText,
    Color? limeTagBackground,
    Color? limeTagBorder,
    Color? magentaTagText,
    Color? magentaTagBackground,
    Color? magentaTagBorder,
    Color? orangeTagText,
    Color? orangeTagBackground,
    Color? orangeTagBorder,
    Color? purpleTagText,
    Color? purpleTagBackground,
    Color? purpleTagBorder,
    Color? redTagText,
    Color? redTagBackground,
    Color? redTagBorder,
    Color? volcanoTagText,
    Color? volcanoTagBackground,
    Color? volcanoTagBorder,
  }) {
    return SupaExtendedColorScheme(
      warningText: warningText ?? this.warningText,
      warningBackground: warningBackground ?? this.warningBackground,
      warningBorder: warningBorder ?? this.warningBorder,
      informationText: informationText ?? this.informationText,
      informationBackground:
          informationBackground ?? this.informationBackground,
      informationBorder: informationBorder ?? this.informationBorder,
      successText: successText ?? this.successText,
      successBackground: successBackground ?? this.successBackground,
      successBorder: successBorder ?? this.successBorder,
      defaultText: defaultText ?? this.defaultText,
      defaultBackground: defaultBackground ?? this.defaultBackground,
      defaultBorder: defaultBorder ?? this.defaultBorder,
      errorText: errorText ?? this.errorText,
      errorBackground: errorBackground ?? this.errorBackground,
      errorBorder: errorBorder ?? this.errorBorder,
      blueTagText: blueTagText ?? this.blueTagText,
      blueTagBackground: blueTagBackground ?? this.blueTagBackground,
      blueTagBorder: blueTagBorder ?? this.blueTagBorder,
      cyanTagText: cyanTagText ?? this.cyanTagText,
      cyanTagBackground: cyanTagBackground ?? this.cyanTagBackground,
      cyanTagBorder: cyanTagBorder ?? this.cyanTagBorder,
      geekblueTagText: geekblueTagText ?? this.geekblueTagText,
      geekblueTagBackground:
          geekblueTagBackground ?? this.geekblueTagBackground,
      geekblueTagBorder: geekblueTagBorder ?? this.geekblueTagBorder,
      goldTagText: goldTagText ?? this.goldTagText,
      goldTagBackground: goldTagBackground ?? this.goldTagBackground,
      goldTagBorder: goldTagBorder ?? this.goldTagBorder,
      greenTagText: greenTagText ?? this.greenTagText,
      greenTagBackground: greenTagBackground ?? this.greenTagBackground,
      greenTagBorder: greenTagBorder ?? this.greenTagBorder,
      limeTagText: limeTagText ?? this.limeTagText,
      limeTagBackground: limeTagBackground ?? this.limeTagBackground,
      limeTagBorder: limeTagBorder ?? this.limeTagBorder,
      magentaTagText: magentaTagText ?? this.magentaTagText,
      magentaTagBackground: magentaTagBackground ?? this.magentaTagBackground,
      magentaTagBorder: magentaTagBorder ?? this.magentaTagBorder,
      orangeTagText: orangeTagText ?? this.orangeTagText,
      orangeTagBackground: orangeTagBackground ?? this.orangeTagBackground,
      orangeTagBorder: orangeTagBorder ?? this.orangeTagBorder,
      purpleTagText: purpleTagText ?? this.purpleTagText,
      purpleTagBackground: purpleTagBackground ?? this.purpleTagBackground,
      purpleTagBorder: purpleTagBorder ?? this.purpleTagBorder,
      redTagText: redTagText ?? this.redTagText,
      redTagBackground: redTagBackground ?? this.redTagBackground,
      redTagBorder: redTagBorder ?? this.redTagBorder,
      volcanoTagText: volcanoTagText ?? this.volcanoTagText,
      volcanoTagBackground: volcanoTagBackground ?? this.volcanoTagBackground,
      volcanoTagBorder: volcanoTagBorder ?? this.volcanoTagBorder,
    );
  }

  /// Linearly interpolates between two color schemes.
  ///
  /// This method is used by Flutter's theme system to animate between different
  /// color schemes, such as when transitioning between light and dark themes.
  ///
  /// The interpolation factor [t] should be between 0.0 and 1.0:
  /// - 0.0 returns this color scheme unchanged
  /// - 1.0 returns [other] color scheme
  /// - Values in between return interpolated colors
  ///
  /// If [other] is null or not a [SupaExtendedColorScheme], this instance
  /// is returned unchanged.
  @override
  ThemeExtension<SupaExtendedColorScheme> lerp(
    covariant ThemeExtension<SupaExtendedColorScheme>? other,
    double t,
  ) {
    if (other is! SupaExtendedColorScheme) {
      return this;
    }

    return SupaExtendedColorScheme(
      warningText: Color.lerp(warningText, other.warningText, t) ?? warningText,
      warningBackground:
          Color.lerp(warningBackground, other.warningBackground, t) ??
              warningBackground,
      warningBorder:
          Color.lerp(warningBorder, other.warningBorder, t) ?? warningBorder,
      informationText: Color.lerp(informationText, other.informationText, t) ??
          informationText,
      informationBackground:
          Color.lerp(informationBackground, other.informationBackground, t) ??
              informationBackground,
      informationBorder:
          Color.lerp(informationBorder, other.informationBorder, t) ??
              informationBorder,
      successText: Color.lerp(successText, other.successText, t) ?? successText,
      successBackground:
          Color.lerp(successBackground, other.successBackground, t) ??
              successBackground,
      successBorder:
          Color.lerp(successBorder, other.successBorder, t) ?? successBorder,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? defaultText,
      defaultBackground:
          Color.lerp(defaultBackground, other.defaultBackground, t) ??
              defaultBackground,
      defaultBorder:
          Color.lerp(defaultBorder, other.defaultBorder, t) ?? defaultBorder,
      errorText: Color.lerp(errorText, other.errorText, t) ?? errorText,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t) ??
          errorBackground,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t) ?? errorBorder,
      blueTagText: Color.lerp(blueTagText, other.blueTagText, t) ?? blueTagText,
      blueTagBackground:
          Color.lerp(blueTagBackground, other.blueTagBackground, t) ??
              blueTagBackground,
      blueTagBorder:
          Color.lerp(blueTagBorder, other.blueTagBorder, t) ?? blueTagBorder,
      cyanTagText: Color.lerp(cyanTagText, other.cyanTagText, t) ?? cyanTagText,
      cyanTagBackground:
          Color.lerp(cyanTagBackground, other.cyanTagBackground, t) ??
              cyanTagBackground,
      cyanTagBorder:
          Color.lerp(cyanTagBorder, other.cyanTagBorder, t) ?? cyanTagBorder,
      geekblueTagText: Color.lerp(geekblueTagText, other.geekblueTagText, t) ??
          geekblueTagText,
      geekblueTagBackground:
          Color.lerp(geekblueTagBackground, other.geekblueTagBackground, t) ??
              geekblueTagBackground,
      geekblueTagBorder:
          Color.lerp(geekblueTagBorder, other.geekblueTagBorder, t) ??
              geekblueTagBorder,
      goldTagText: Color.lerp(goldTagText, other.goldTagText, t) ?? goldTagText,
      goldTagBackground:
          Color.lerp(goldTagBackground, other.goldTagBackground, t) ??
              goldTagBackground,
      goldTagBorder:
          Color.lerp(goldTagBorder, other.goldTagBorder, t) ?? goldTagBorder,
      greenTagText:
          Color.lerp(greenTagText, other.greenTagText, t) ?? greenTagText,
      greenTagBackground:
          Color.lerp(greenTagBackground, other.greenTagBackground, t) ??
              greenTagBackground,
      greenTagBorder:
          Color.lerp(greenTagBorder, other.greenTagBorder, t) ?? greenTagBorder,
      limeTagText: Color.lerp(limeTagText, other.limeTagText, t) ?? limeTagText,
      limeTagBackground:
          Color.lerp(limeTagBackground, other.limeTagBackground, t) ??
              limeTagBackground,
      limeTagBorder:
          Color.lerp(limeTagBorder, other.limeTagBorder, t) ?? limeTagBorder,
      magentaTagText:
          Color.lerp(magentaTagText, other.magentaTagText, t) ?? magentaTagText,
      magentaTagBackground:
          Color.lerp(magentaTagBackground, other.magentaTagBackground, t) ??
              magentaTagBackground,
      magentaTagBorder:
          Color.lerp(magentaTagBorder, other.magentaTagBorder, t) ??
              magentaTagBorder,
      orangeTagText:
          Color.lerp(orangeTagText, other.orangeTagText, t) ?? orangeTagText,
      orangeTagBackground:
          Color.lerp(orangeTagBackground, other.orangeTagBackground, t) ??
              orangeTagBackground,
      orangeTagBorder: Color.lerp(orangeTagBorder, other.orangeTagBorder, t) ??
          orangeTagBorder,
      purpleTagText:
          Color.lerp(purpleTagText, other.purpleTagText, t) ?? purpleTagText,
      purpleTagBackground:
          Color.lerp(purpleTagBackground, other.purpleTagBackground, t) ??
              purpleTagBackground,
      purpleTagBorder: Color.lerp(purpleTagBorder, other.purpleTagBorder, t) ??
          purpleTagBorder,
      redTagText: Color.lerp(redTagText, other.redTagText, t) ?? redTagText,
      redTagBackground:
          Color.lerp(redTagBackground, other.redTagBackground, t) ??
              redTagBackground,
      redTagBorder:
          Color.lerp(redTagBorder, other.redTagBorder, t) ?? redTagBorder,
      volcanoTagText:
          Color.lerp(volcanoTagText, other.volcanoTagText, t) ?? volcanoTagText,
      volcanoTagBackground:
          Color.lerp(volcanoTagBackground, other.volcanoTagBackground, t) ??
              volcanoTagBackground,
      volcanoTagBorder:
          Color.lerp(volcanoTagBorder, other.volcanoTagBorder, t) ??
              volcanoTagBorder,
    );
  }

  /// Retrieves a complete token group by name.
  ///
  /// Returns a [SupaExtendedColorTokenGroup] containing the text, background,
  /// and border colors for the specified token group name.
  ///
  /// Valid names include:
  /// - Semantic statuses: `'default'`, `'warning'`, `'information'`, `'success'`, `'error'`
  /// - Tag colors: `'blue'`, `'cyan'`, `'geekblue'`, `'gold'`, `'green'`, `'lime'`,
  ///   `'magenta'`, `'orange'`, `'purple'`, `'red'`, `'volcano'`
  ///
  /// Throws an [Exception] if an invalid token group name is provided.
  ///
  /// Example:
  /// ```dart
  /// final warningGroup = colorScheme.getTokenGroup('warning');
  /// // Use warningGroup.text, warningGroup.background, warningGroup.border
  /// ```
  SupaExtendedColorTokenGroup getTokenGroup(String name) {
    switch (name) {
      case _warning:
        return SupaExtendedColorTokenGroup(
          text: warningText,
          background: warningBackground,
          border: warningBorder,
        );
      case _information:
        return SupaExtendedColorTokenGroup(
          text: informationText,
          background: informationBackground,
          border: informationBorder,
        );
      case _success:
        return SupaExtendedColorTokenGroup(
          text: successText,
          background: successBackground,
          border: successBorder,
        );
      case _default:
        return SupaExtendedColorTokenGroup(
          text: defaultText,
          background: defaultBackground,
          border: defaultBorder,
        );
      case _error:
        return SupaExtendedColorTokenGroup(
          text: errorText,
          background: errorBackground,
          border: errorBorder,
        );
      case _blueTag:
        return SupaExtendedColorTokenGroup(
          text: blueTagText,
          background: blueTagBackground,
          border: blueTagBorder,
        );
      case _cyanTag:
        return SupaExtendedColorTokenGroup(
          text: cyanTagText,
          background: cyanTagBackground,
          border: cyanTagBorder,
        );
      case _geekblueTag:
        return SupaExtendedColorTokenGroup(
          text: geekblueTagText,
          background: geekblueTagBackground,
          border: geekblueTagBorder,
        );
      case _goldTag:
        return SupaExtendedColorTokenGroup(
          text: goldTagText,
          background: goldTagBackground,
          border: goldTagBorder,
        );
      case _greenTag:
        return SupaExtendedColorTokenGroup(
          text: greenTagText,
          background: greenTagBackground,
          border: greenTagBorder,
        );
      case _limeTag:
        return SupaExtendedColorTokenGroup(
          text: limeTagText,
          background: limeTagBackground,
          border: limeTagBorder,
        );
      case _magentaTag:
        return SupaExtendedColorTokenGroup(
          text: magentaTagText,
          background: magentaTagBackground,
          border: magentaTagBorder,
        );
      case _orangeTag:
        return SupaExtendedColorTokenGroup(
          text: orangeTagText,
          background: orangeTagBackground,
          border: orangeTagBorder,
        );
      case _purpleTag:
        return SupaExtendedColorTokenGroup(
          text: purpleTagText,
          background: purpleTagBackground,
          border: purpleTagBorder,
        );
      case _redTag:
        return SupaExtendedColorTokenGroup(
          text: redTagText,
          background: redTagBackground,
          border: redTagBorder,
        );
      case _volcanoTag:
        return SupaExtendedColorTokenGroup(
          text: volcanoTagText,
          background: volcanoTagBackground,
          border: volcanoTagBorder,
        );
      default:
        throw Exception('Invalid token group name: $name');
    }
  }

  /// Gets the text color for a given semantic key.
  ///
  /// Returns the appropriate text color based on the provided [key]. Supports
  /// both semantic status keys and tag color keys.
  ///
  /// Valid keys:
  /// - Status keys: `'default'`, `'warning'`, `'information'`, `'processing'`,
  ///   `'success'`, `'error'`, `'critical'`
  /// - Tag keys: `'blue'`, `'cyan'`, `'geekblue'`, `'gold'`, `'green'`, `'lime'`,
  ///   `'magenta'`, `'orange'`, `'purple'`, `'red'`, `'volcano'`
  ///
  /// Note: `'processing'` maps to `'information'` and `'critical'` maps to `'error'`.
  /// If an unknown key is provided, returns the default text color.
  ///
  /// Example:
  /// ```dart
  /// final textColor = colorScheme.getTextColor('success');
  /// ```
  Color getTextColor(String key) {
    switch (key) {
      case _warning:
        return warningText;
      case _processing:
        return informationText;
      case _information:
        return informationText;
      case _success:
        return successText;
      case _critical:
        return errorText;
      case _error:
        return errorText;
      case _default:
        return defaultText;
      case _blueTag:
        return blueTagText;
      case _cyanTag:
        return cyanTagText;
      case _geekblueTag:
        return geekblueTagText;
      case _goldTag:
        return goldTagText;
      case _greenTag:
        return greenTagText;
      case _limeTag:
        return limeTagText;
      case _magentaTag:
        return magentaTagText;
      case _orangeTag:
        return orangeTagText;
      case _purpleTag:
        return purpleTagText;
      case _redTag:
        return redTagText;
      case _volcanoTag:
        return volcanoTagText;
      default:
        return defaultText;
    }
  }

  /// Gets the background color for a given semantic key.
  ///
  /// Returns the appropriate background color based on the provided [key].
  /// Supports both semantic status keys and tag color keys.
  ///
  /// Valid keys:
  /// - Status keys: `'default'`, `'warning'`, `'information'`, `'processing'`,
  ///   `'success'`, `'error'`, `'critical'`
  /// - Tag keys: `'blue'`, `'cyan'`, `'geekblue'`, `'gold'`, `'green'`, `'lime'`,
  ///   `'magenta'`, `'orange'`, `'purple'`, `'red'`, `'volcano'`
  ///
  /// Note: `'processing'` maps to `'information'` and `'critical'` maps to `'error'`.
  /// If an unknown key is provided, returns the default background color.
  ///
  /// Example:
  /// ```dart
  /// final bgColor = colorScheme.getBackgroundColor('error');
  /// ```
  Color getBackgroundColor(String key) {
    switch (key) {
      case _warning:
        return warningBackground;
      case _processing:
        return informationBackground;
      case _information:
        return informationBackground;
      case _success:
        return successBackground;
      case _critical:
        return errorBackground;
      case _error:
        return errorBackground;
      case _default:
      case 'defaultColor': // Kept for backward compatibility
        return defaultBackground;
      case _blueTag:
        return blueTagBackground;
      case _cyanTag:
        return cyanTagBackground;
      case _geekblueTag:
        return geekblueTagBackground;
      case _goldTag:
        return goldTagBackground;
      case _greenTag:
        return greenTagBackground;
      case _limeTag:
        return limeTagBackground;
      case _magentaTag:
        return magentaTagBackground;
      case _orangeTag:
        return orangeTagBackground;
      case _purpleTag:
        return purpleTagBackground;
      case _redTag:
        return redTagBackground;
      case _volcanoTag:
        return volcanoTagBackground;
      default:
        return defaultBackground;
    }
  }

  /// Gets the border color for a given semantic key.
  ///
  /// Returns the appropriate border color based on the provided [key].
  /// Supports both semantic status keys and tag color keys.
  ///
  /// Valid keys:
  /// - Status keys: `'default'`, `'warning'`, `'information'`, `'processing'`,
  ///   `'success'`, `'error'`, `'critical'`
  /// - Tag keys: `'blue'`, `'cyan'`, `'geekblue'`, `'gold'`, `'green'`, `'lime'`,
  ///   `'magenta'`, `'orange'`, `'purple'`, `'red'`, `'volcano'`
  ///
  /// Note: `'processing'` maps to `'information'` and `'critical'` maps to `'error'`.
  /// If an unknown key is provided, returns the default border color.
  ///
  /// Example:
  /// ```dart
  /// final borderColor = colorScheme.getBorderColor('warning');
  /// ```
  Color getBorderColor(String key) {
    switch (key) {
      case _warning:
        return warningBorder;
      case _processing:
        return informationBorder;
      case _information:
        return informationBorder;
      case _success:
        return successBorder;
      case _critical:
        return errorBorder;
      case _error:
        return errorBorder;
      case _default:
      case 'defaultColor': // Kept for backward compatibility
        return defaultBorder;
      case _blueTag:
        return blueTagBorder;
      case _cyanTag:
        return cyanTagBorder;
      case _geekblueTag:
        return geekblueTagBorder;
      case _goldTag:
        return goldTagBorder;
      case _greenTag:
        return greenTagBorder;
      case _limeTag:
        return limeTagBorder;
      case _magentaTag:
        return magentaTagBorder;
      case _orangeTag:
        return orangeTagBorder;
      case _purpleTag:
        return purpleTagBorder;
      case _redTag:
        return redTagBorder;
      case _volcanoTag:
        return volcanoTagBorder;
      default:
        return defaultBorder;
    }
  }
}
