import "package:reactive_forms/reactive_forms.dart";

/// A reactive form for user authentication/login.
///
/// This form manages the validation and submission of user login credentials.
/// It contains two required fields: username and password.
///
/// **Example usage:**
/// ```dart
/// final form = LoginForm('user@example.com', '');
/// if (form.valid) {
///   // Submit login credentials
/// }
/// ```
class LoginForm extends FormGroup {
  /// Creates a [LoginForm] with initial values for username and password.
  ///
  /// Both fields are required and must be non-empty for the form to be valid.
  ///
  /// **Parameters:**
  /// - `initialUsername`: The initial username value (typically empty or pre-filled).
  /// - `initialPassword`: The initial password value (typically empty for security).
  LoginForm(String initialUsername, String initialPassword)
      : super({
          "username": FormControl<String>(
            value: initialUsername,
            validators: [
              Validators.required,
            ],
          ),
          "password": FormControl<String>(
            value: initialPassword,
            validators: [
              Validators.required,
            ],
          ),
        });

  /// The username form control.
  ///
  /// This control validates that the username field is not empty.
  /// Access the value via `username.value` and check validity via `username.valid`.
  FormControl<String> get username =>
      control("username") as FormControl<String>;

  /// The password form control.
  ///
  /// This control validates that the password field is not empty.
  /// Access the value via `password.value` and check validity via `password.valid`.
  FormControl<String> get password =>
      control("password") as FormControl<String>;
}
