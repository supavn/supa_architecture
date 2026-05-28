import "package:reactive_forms/reactive_forms.dart";

/// A reactive form for changing a user's password.
///
/// This form is used when an authenticated user wants to change their existing
/// password. It requires the current password, a new password that meets
/// the minimum length requirement, and optionally an OTP code for additional
/// verification.
///
/// The form enforces the following validations:
/// - Current password is required
/// - New password must be at least [minPasswordLength] characters
/// - New password and verification must match
/// - If OTP validation is enabled, OTP code must be a 6-digit number
///
/// **Password requirements:**
/// The new password must contain at least [minPasswordLength] characters.
///
/// **Example usage:**
/// ```dart
/// final form = ChangePasswordForm(enableOtpValidation: true);
/// form.password.value = 'currentPassword';
/// form.newPassword.value = 'newpassw';
/// form.verifyNewPassword.value = 'newpassw';
/// form.otpCode.value = '123456';
/// if (form.valid) {
///   // Submit password change
/// }
/// ```
class ChangePasswordForm extends FormGroup {
  /// Minimum length required for new passwords.
  static const minPasswordLength = 8;

  /// Regular expression pattern for validating OTP codes.
  ///
  /// Matches exactly 6 digits: `^[0-9]{6}$`
  static const otpRegex = r"^[0-9]{6}$";

  /// Creates a [ChangePasswordForm] with optional OTP validation.
  ///
  /// **Parameters:**
  /// - `enableOtpValidation`: If `true`, the OTP code field becomes required
  ///   and must match the pattern `^[0-9]{6}$` (exactly 6 digits).
  ///   Defaults to `false`.
  ///
  /// The form includes cross-field validation to ensure that the new password
  /// and verify new password fields match. The new password must also meet
  /// the minimum length requirement defined by [minPasswordLength].
  ChangePasswordForm({
    bool enableOtpValidation = false,
  }) : super({
          "password": FormControl<String>(
            value: "",
            validators: [
              Validators.required,
            ],
          ),
          "newPassword": FormControl<String>(
            value: "",
            validators: [
              Validators.required,
              Validators.minLength(minPasswordLength),
            ],
          ),
          "verifyNewPassword": FormControl<String>(
            value: "",
            validators: [
              Validators.required,
              Validators.minLength(minPasswordLength),
            ],
          ),
          "otpCode": FormControl<String>(
            value: "",
            validators: [
              if (enableOtpValidation) ...[
                Validators.required,
                Validators.pattern(otpRegex),
              ],
            ],
          ),
        }, validators: [
          Validators.mustMatch(
            "newPassword",
            "verifyNewPassword",
          ),
        ]);

  /// The current password form control.
  ///
  /// This control validates that the current password field is not empty.
  /// Access the value via `password.value` and check validity via `password.valid`.
  FormControl<String> get password =>
      control("password") as FormControl<String>;

  /// The new password form control.
  ///
  /// This control validates that the new password field:
  /// - Is not empty (required)
  /// - Contains at least [minPasswordLength] characters
  /// - Matches the verify new password field (via cross-field validation)
  ///
  /// Access the value via `newPassword.value` and check validity via `newPassword.valid`.
  FormControl<String> get newPassword =>
      control("newPassword") as FormControl<String>;

  /// The new password verification form control.
  ///
  /// This control validates that the verify new password field:
  /// - Is not empty (required)
  /// - Contains at least [minPasswordLength] characters
  /// - Matches the new password field (via cross-field validation)
  ///
  /// Access the value via `verifyNewPassword.value` and check validity via `verifyNewPassword.valid`.
  FormControl<String> get verifyNewPassword =>
      control("verifyNewPassword") as FormControl<String>;

  /// The OTP (One-Time Password) code form control.
  ///
  /// This control is only validated if `enableOtpValidation` was set to `true`
  /// during form construction. When enabled, it requires a 6-digit numeric code
  /// matching the pattern `^[0-9]{6}$`.
  ///
  /// Access the value via `otpCode.value` and check validity via `otpCode.valid`.
  FormControl<String> get otpCode => control("otpCode") as FormControl<String>;
}
