part of "authentication_bloc.dart";

/// Base class for all authentication-related events.
///
/// Events represent user actions or system triggers that can change
/// the authentication state of the application.
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

/// Initializes the authentication flow and resets to the login screen.
final class AuthenticationInitializeEvent extends AuthenticationEvent {}

/// Indicates that an authentication action is currently being processed.
///
/// This event is used to show loading states during authentication operations.
final class AuthenticationProcessingEvent extends AuthenticationEvent {
  /// The specific authentication action being performed
  final AuthenticationAction action;

  const AuthenticationProcessingEvent(this.action);
}

/// Triggers Google OAuth sign-in flow.
final class LoginWithGoogleEvent extends AuthenticationEvent {}

/// Triggers Apple ID sign-in flow.
final class LoginWithAppleEvent extends AuthenticationEvent {}

/// Triggers Microsoft OAuth (Azure AD) sign-in flow.
final class LoginWithMicrosoftEvent extends AuthenticationEvent {}

/// Triggers email and password authentication.
final class LoginWithPasswordEvent extends AuthenticationEvent {
  /// User's email address
  final String email;

  /// User's password
  final String password;

  const LoginWithPasswordEvent(
    this.email,
    this.password,
  );
}

/// Triggers biometric authentication using saved credentials.
///
/// This uses the device's fingerprint, face recognition, or other
/// biometric authentication method to log in with stored credentials.
final class LoginWithSavedLoginEvent extends AuthenticationEvent {}

/// Restores a previously saved authentication session.
///
/// This event is triggered when the app loads cached authentication
/// data from local storage, allowing the user to remain logged in
/// across app restarts.
final class UsingSavedAuthenticationEvent extends AuthenticationEvent {
  /// The tenant associated with the saved session
  final Tenant tenant;

  /// The authenticated user's profile data
  final AppUser user;

  const UsingSavedAuthenticationEvent({
    required this.tenant,
    required this.user,
  });
}

/// Completes authentication by selecting a specific tenant.
///
/// After successful login, if the user has access to multiple tenants,
/// this event is triggered when they select which tenant to use.
final class LoginWithSelectedTenantEvent extends AuthenticationEvent {
  /// The tenant selected by the user
  final Tenant tenant;

  const LoginWithSelectedTenantEvent({
    required this.tenant,
  });
}

/// Transitions to tenant selection when user has multiple tenant access.
///
/// This event is triggered after successful authentication when the user
/// has access to more than one tenant and needs to choose which one to use.
final class LoginWithMultipleTenantsEvent extends AuthenticationEvent {
  /// List of tenants the user has access to
  final List<Tenant> tenants;

  const LoginWithMultipleTenantsEvent(this.tenants);
}

/// Triggers user logout and clears the current session.
final class UserLogoutEvent extends AuthenticationEvent {}

/// Reports an authentication error.
///
/// This event is used to display error messages to the user when
/// an authentication operation fails.
final class AuthenticationErrorEvent extends AuthenticationEvent {
  /// Error title for display in UI
  final String title;

  /// Detailed error message for the user
  final String message;

  /// Optional error object for debugging
  final Object? error;

  const AuthenticationErrorEvent({
    required this.title,
    required this.message,
    this.error,
  });
}

/// Updates the current user's profile information.
///
/// This event is triggered when user profile data changes and needs
/// to be reflected in the authentication state.
final class UpdateAppUserProfileEvent extends AuthenticationEvent {
  /// Updated user profile data
  final AppUser user;

  const UpdateAppUserProfileEvent(this.user);
}

/// Toggles the user's email notification preference.
///
/// Updates whether the user wants to receive system notifications via email.
final class AppUserSwitchEmailEvent extends AuthenticationEvent {
  const AppUserSwitchEmailEvent();
}

/// Toggles the user's push notification preference.
///
/// Updates whether the user wants to receive system notifications via push.
final class AppUserSwitchNotificationEvent extends AuthenticationEvent {
  const AppUserSwitchNotificationEvent();
}
