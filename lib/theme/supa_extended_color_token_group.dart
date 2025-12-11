import 'package:flutter/material.dart';

/// A group of related color tokens used for consistent styling of UI components.
///
/// This class encapsulates three color properties that are typically used together
/// to style components like badges, tags, alerts, and status indicators:
/// - [text]: The color used for text content within the component
/// - [background]: The background color of the component
/// - [border]: The border color of the component
///
/// Example usage:
/// ```dart
/// final tokenGroup = SupaExtendedColorTokenGroup(
///   text: Colors.white,
///   background: Colors.blue,
///   border: Colors.blue.shade700,
/// );
/// ```
class SupaExtendedColorTokenGroup {
  /// The color used for text content within the styled component.
  final Color text;

  /// The background color of the styled component.
  final Color background;

  /// The border color of the styled component.
  final Color border;

  /// Creates a new [SupaExtendedColorTokenGroup] with the specified colors.
  ///
  /// All parameters are required and should be chosen to work harmoniously
  /// together for optimal contrast and readability.
  const SupaExtendedColorTokenGroup({
    required this.text,
    required this.background,
    required this.border,
  });
}
