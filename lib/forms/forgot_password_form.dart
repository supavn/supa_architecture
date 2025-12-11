import "package:reactive_forms/reactive_forms.dart";

/// A reactive form for requesting a password reset.
///
/// This form is used when a user has forgotten their password and needs to
/// request a password reset link or code via email. The form validates that
/// the provided email address is both present and in a valid email format.
///
/// **Example usage:**
/// ```dart
/// final form = ForgotPasswordForm();
/// form.email.value = 'user@example.com';
/// if (form.valid) {
///   // Send password reset request
/// }
/// ```
class ForgotPasswordForm extends FormGroup {
  /// Creates a [ForgotPasswordForm] with an empty email field.
  ///
  /// The email field is initialized as empty and requires both a non-empty
  /// value and a valid email format to pass validation.
  ForgotPasswordForm()
      : super({
          "email": FormControl<String>(
            value: "",
            validators: [
              Validators.required,
              Validators.email,
            ],
          ),
        });

  /// The email form control.
  ///
  /// This control validates that the email field is:
  /// - Not empty (required)
  /// - In a valid email format
  ///
  /// Access the value via `email.value` and check validity via `email.valid`.
  FormControl<String> get email => control("email") as FormControl<String>;
}
