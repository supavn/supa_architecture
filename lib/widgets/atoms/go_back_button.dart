import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

/// A button widget that provides navigation back functionality with fallback routing.
///
/// This widget displays a back arrow icon button that:
/// - Executes an optional custom callback when pressed
/// - Pops the current route if the navigation stack allows it
/// - Falls back to navigating to the root route ("/") if the stack cannot be popped
///
/// **Usage:**
/// ```dart
/// // Simple back button
/// GoBackButton()
///
/// // Back button with custom action
/// GoBackButton(
///   onPressed: () {
///     // Custom logic before going back
///   },
/// )
/// ```
class GoBackButton extends StatelessWidget {
  /// Optional callback function executed when the button is pressed.
  ///
  /// This callback is executed before the navigation action. If the navigation
  /// stack can be popped, it will pop; otherwise, it navigates to the root route.
  final VoidCallback? onPressed;

  /// Creates a [GoBackButton] widget.
  ///
  /// **Parameters:**
  /// - `onPressed`: Optional callback function executed when the button is pressed.
  const GoBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CarbonIcons.arrow_left),
      onPressed: () {
        if (onPressed != null) {
          onPressed!.call();
        }
        if (Navigator.of(context).canPop()) {
          return Navigator.of(context).pop();
        }
        return GoRouter.of(context).go("/");
      },
    );
  }
}
