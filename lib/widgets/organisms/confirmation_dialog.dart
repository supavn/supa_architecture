import 'package:flutter/material.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

/// A customizable confirmation dialog widget with icon, title, content, and action buttons.
///
/// This dialog provides a standard way to request user confirmation before
/// performing an action. It supports custom icons, titles, content, and button
/// labels with customizable colors.
///
/// **Usage:**
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ConfirmationDialog(
///     title: 'Delete Item',
///     content: 'Are you sure you want to delete this item?',
///     onConfirm: () {
///       // Handle confirmation
///     },
///     onCancel: () {
///       // Handle cancellation
///     },
///   ),
/// )
/// ```
class ConfirmationDialog extends StatelessWidget {
  /// Function that returns the default text for the OK/confirm button.
  ///
  /// Defaults to 'Tiếp tục' (Continue in Vietnamese).
  static String Function() defaultOkText = () => 'Tiếp tục';

  /// Function that returns the default text for the cancel button.
  ///
  /// Defaults to 'Huỷ' (Cancel in Vietnamese).
  static String Function() defaultCancelText = () => 'Huỷ';

  /// The icon to display at the top of the dialog.
  ///
  /// If not provided, defaults to [Icons.check_circle_outline].
  final IconData? icon;

  /// The title text displayed at the top of the dialog.
  final String title;

  /// The content text displayed in the body of the dialog.
  ///
  /// If both [content] and [child] are provided, both will be displayed.
  final String? content;

  /// Custom widget to display in the dialog body.
  ///
  /// This allows for more complex content than plain text. If both [content]
  /// and [child] are provided, both will be displayed.
  final Widget? child;

  /// The text label for the confirm/OK button.
  ///
  /// If not provided, uses [defaultOkText].
  final String? okText;

  /// The color for the confirm/OK button text and icon.
  final Color? okColor;

  /// Callback function executed when the confirm button is pressed.
  ///
  /// The dialog will automatically close after this callback is executed.
  final VoidCallback onConfirm;

  /// The text label for the cancel button.
  ///
  /// If not provided, uses [defaultCancelText].
  final String? cancelText;

  /// The color for the cancel button text and icon.
  final Color? cancelColor;

  /// Optional callback function executed when the cancel button is pressed.
  ///
  /// The dialog will automatically close after this callback is executed (if provided).
  final VoidCallback? onCancel;

  /// Creates a [ConfirmationDialog] widget.
  ///
  /// **Parameters:**
  /// - `title`: The title text displayed at the top (required).
  /// - `content`: The content text displayed in the body (optional).
  /// - `child`: Custom widget to display in the dialog body (optional).
  /// - `onConfirm`: Callback executed when confirm button is pressed (required).
  /// - `onCancel`: Optional callback executed when cancel button is pressed.
  /// - `okText`: Text label for the confirm button (optional, uses default if not provided).
  /// - `okColor`: Color for the confirm button text and icon (optional).
  /// - `cancelText`: Text label for the cancel button (optional, uses default if not provided).
  /// - `cancelColor`: Color for the cancel button text and icon (optional).
  /// - `icon`: Icon displayed at the top of the dialog (optional, uses default if not provided).
  const ConfirmationDialog({
    super.key,
    required this.title,
    this.content,
    this.child,
    required this.onConfirm,
    this.onCancel,
    this.okText,
    this.okColor,
    this.cancelText,
    this.cancelColor,
    this.icon,
  });

  /// Closes the dialog by popping the navigation stack.
  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      icon: Icon(
        icon ?? Icons.check_circle_outline, // Default icon if none is provided.
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content != null)
            Text(
              content!,
              style: theme.textTheme.bodyMedium,
            ),
          if (child != null) child!, // Embeds custom content if provided.
        ],
      ),
      actions: <Widget>[
        TextButton.icon(
          icon: Icon(
            CarbonIcons.close,
            color: cancelColor,
          ),
          onPressed: () {
            if (onCancel != null) {
              onCancel!(); // Triggers the cancel callback if it exists.
            }
            _closeDialog(context); // Closes the dialog.
          },
          label: Text(
            cancelText ?? defaultCancelText(),
            style: TextStyle(
              color: cancelColor,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            onConfirm(); // Triggers the confirmation callback.
            _closeDialog(context); // Closes the dialog.
          },
          label: Text(
            okText ?? defaultOkText(),
            style: TextStyle(
              color: okColor,
            ),
          ),
          icon: Icon(
            CarbonIcons.checkmark,
            color: okColor,
          ),
        ),
      ],
    );
  }
}
