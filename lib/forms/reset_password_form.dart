import "package:reactive_forms/reactive_forms.dart";

/// A reactive form for resetting a user's password.
///
/// This form is used when a user needs to set a new password, typically after
/// requesting a password reset. It includes fields for the new password,
/// password confirmation, and optionally an OTP (One-Time Password) code for
/// additional security verification.
///
/// The form ensures that:
/// - Both password fields are required
/// - The password and confirm password fields match
/// - If OTP validation is enabled, the OTP code is a required 6-digit number
///
/// **Example usage:**
/// ```dart
/// final form = ResetPasswordForm(enableOtpValidation: true);
/// form.password.value = 'newPassword123';
/// form.confirmPassword.value = 'newPassword123';
/// form.otpCode.value = '123456';
/// if (form.valid) {
///   // Submit password reset
/// }
/// ```
class ResetPasswordForm extends FormGroup {
  /// Creates a [ResetPasswordForm] with optional OTP validation.
  ///
  /// **Parameters:**
  /// - `enableOtpValidation`: If `true`, the OTP code field becomes required
  ///   and must match the pattern `^[0-9]{6}$` (exactly 6 digits).
  ///   Defaults to `false`.
  ///
  /// The form includes cross-field validation to ensure that the password
  /// and confirm password fields match.
  ResetPasswordForm({
    bool enableOtpValidation = false,
  }) : super(
          {
            "password": FormControl<String>(
              value: "",
              validators: [
                Validators.required,
              ],
            ),
            "confirmPassword": FormControl<String>(
              value: "",
              validators: [
                Validators.required,
              ],
            ),
            "otpCode": FormControl<String>(
              value: "",
              validators: [
                if (enableOtpValidation) ...[
                  Validators.required,
                  Validators.pattern(r"^[0-9]{6}$"),
                ],
              ],
            ),
          },
          validators: [
            Validators.mustMatch(
              "password",
              "confirmPassword",
            ),
          ],
        );

  /// The new password form control.
  ///
  /// This control validates that the password field is not empty.
  /// Access the value via `password.value` and check validity via `password.valid`.
  FormControl<String> get password =>
      control("password") as FormControl<String>;

  /// The password confirmation form control.
  ///
  /// This control validates that the confirm password field is not empty
  /// and matches the password field (via cross-field validation).
  /// Access the value via `confirmPassword.value` and check validity via `confirmPassword.valid`.
  FormControl<String> get confirmPassword =>
      control("confirmPassword") as FormControl<String>;

  /// The OTP (One-Time Password) code form control.
  ///
  /// This control is only validated if `enableOtpValidation` was set to `true`
  /// during form construction. When enabled, it requires a 6-digit numeric code.
  /// Access the value via `otpCode.value` and check validity via `otpCode.valid`.
  FormControl<String> get otpCode => control("otpCode") as FormControl<String>;
}
