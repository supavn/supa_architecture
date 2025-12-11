/// A mixin that provides functionality for managing password field visibility
/// in text input widgets.
///
/// This mixin is typically used with Flutter text field widgets (such as
/// [TextField] or [TextFormField]) to enable users to toggle between showing
/// and hiding password characters. It maintains the visibility state and
/// provides a method to toggle it.
///
/// Example usage:
/// ```dart
/// class LoginForm extends StatefulWidget {
///   @override
///   _LoginFormState createState() => _LoginFormState();
/// }
///
/// class _LoginFormState extends State<LoginForm> with PasswordFieldMixin {
///   @override
///   Widget build(BuildContext context) {
///     return TextField(
///       obscureText: !isShowPassword,
///       decoration: InputDecoration(
///         suffixIcon: IconButton(
///           icon: Icon(isShowPassword ? Icons.visibility : Icons.visibility_off),
///           onPressed: toggleShowPassword,
///         ),
///       ),
///     );
///   }
/// }
/// ```
mixin PasswordFieldMixin {
  /// Indicates whether the password text is currently visible to the user.
  ///
  /// When `true`, the password characters are displayed in plain text.
  /// When `false`, the password characters are obscured (typically shown as dots).
  ///
  /// This value should be used with the `obscureText` property of text input
  /// widgets, typically as `obscureText: !isShowPassword`.
  bool isShowPassword = false;

  /// Toggles the visibility state of the password field.
  ///
  /// This method switches the [isShowPassword] value between `true` and `false`,
  /// allowing users to show or hide password characters in the input field.
  ///
  /// Typically called from an icon button's `onPressed` callback in the text
  /// field's suffix icon.
  void toggleShowPassword() {
    isShowPassword = !isShowPassword;
  }
}
