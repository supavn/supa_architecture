part of "authentication_bloc.dart";

/// Represents the different authentication actions that can be performed.
///
/// This enum is used to track which authentication operation is currently
/// in progress, allowing the UI to display appropriate loading states and messages.
enum AuthenticationAction {
  /// Initial authentication setup and saved session check
  initialize,

  /// Sign in using Google OAuth
  loginWithGoogle,

  /// Sign in using Apple ID
  loginWithApple,

  /// Sign in using Microsoft OAuth (Azure AD)
  loginWithMicrosoft,

  /// Sign in using device biometrics (fingerprint, face recognition)
  loginWithBiometrics,

  /// Sign in using email and password credentials
  loginWithPassword,

  /// Sign out and clear session
  logout,
}
