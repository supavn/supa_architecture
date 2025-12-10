part of "authentication_bloc.dart";

/// Base class for all authentication states.
///
/// The authentication state represents the current status of user authentication
/// in the application. States transition based on events like login, logout, and
/// tenant selection.
sealed class AuthenticationState {
  const AuthenticationState();

  /// Returns true if the user is fully authenticated with a selected tenant
  bool get isAuthenticated => this is UserAuthenticatedWithSelectedTenantState;

  /// Returns true if the user is authenticated but needs to select a tenant
  bool get isSelectingTenant =>
      this is UserAuthenticatedWithMultipleTenantsState;

  /// Returns true if an authentication operation is in progress
  bool get isLoading => this is AuthenticationProcessingState;

  /// Returns true if the last authentication operation resulted in an error
  bool get hasError => this is AuthenticationErrorState;
}

/// Initial state before any authentication has been attempted.
///
/// This is the default state when the app starts and no cached session exists.
final class AuthenticationInitialState extends AuthenticationState {}

/// State representing a successfully authenticated user.
///
/// This state is used when authentication succeeds but tenant information
/// hasn't been resolved yet.
final class UserAuthenticatedState extends AuthenticationState {
  /// The authenticated user's profile data
  final AppUser user;

  const UserAuthenticatedState(this.user);
}

/// State when user is authenticated but has access to multiple tenants.
///
/// The application should show a tenant selection UI to let the user
/// choose which tenant context they want to work in.
final class UserAuthenticatedWithMultipleTenantsState
    extends AuthenticationState {
  /// List of tenants the user has access to
  final List<Tenant> tenants;

  const UserAuthenticatedWithMultipleTenantsState({
    required this.tenants,
  });
}

/// Fully authenticated state with both user and tenant information.
///
/// This is the primary authenticated state where the user can access
/// the application with a specific tenant context. The state includes
/// equality comparison to trigger UI updates when user profile data changes.
final class UserAuthenticatedWithSelectedTenantState extends AuthenticationState
    with EquatableMixin {
  /// The authenticated user's profile data
  final AppUser user;

  /// The tenant context the user is currently working in
  final Tenant tenant;

  const UserAuthenticatedWithSelectedTenantState({
    required this.user,
    required this.tenant,
  });

  @override
  List<Object?> get props => [
        tenant,
        tenant.id.value,
        ...user.fields.map(
          (field) => field.value,
        ),
      ];
}

/// State indicating the user has logged out.
///
/// This state is set immediately after logout and typically transitions
/// to [AuthenticationInitialState].
final class AuthenticationLogoutState extends AuthenticationState {}

/// State indicating an authentication operation is in progress.
///
/// This state is used to show loading indicators and prevent concurrent
/// authentication attempts.
final class AuthenticationProcessingState extends AuthenticationState {
  /// The specific authentication action being processed
  final AuthenticationAction action;

  const AuthenticationProcessingState(this.action);
}

/// State representing an authentication error.
///
/// This state contains error information that should be displayed to the user.
final class AuthenticationErrorState extends AuthenticationState {
  /// Error title for display in UI dialogs or snackbars
  final String title;

  /// Detailed error message explaining what went wrong
  final String message;

  /// Optional error object for debugging and logging
  final Object? error;

  const AuthenticationErrorState({
    required this.title,
    required this.message,
    this.error,
  });
}
