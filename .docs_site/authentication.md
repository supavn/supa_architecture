---
title: Authentication
layout: default
nav_order: 5
description: "Multi-tenant authentication system with various providers."
permalink: /authentication/
---

# Authentication System

The authentication system is a core component of Supa Architecture, providing a comprehensive solution for handling user authentication across multiple providers and tenants. It supports various authentication methods, token management, and multi-tenant capabilities.

## Purpose and Scope

The authentication system serves several critical functions:

- **Multi-Provider Authentication**: Support for various authentication providers
- **Multi-Tenant Support**: Handle multiple organizations or tenants
- **Token Management**: Automatic token lifecycle management
- **Persistent Sessions**: Remember user authentication state
- **Security**: Secure storage and handling of authentication data
- **Biometric Support**: Integration with device biometric authentication

## Authentication Architecture

The authentication system follows a structured approach with clear separation of concerns:

```
UI Layer (Login Screens)
       ↓
AuthenticationBloc (State Management)
       ↓
PortalAuthenticationRepository (Business Logic)
       ↓
Authentication Providers (External Services)
       ↓
Secure Storage (Token Persistence)
```

### Core Components

1. **AuthenticationBloc**: Manages authentication state and processes events
2. **Authentication Repository**: Handles authentication business logic
3. **Authentication Providers**: Interface with external authentication services
4. **Secure Storage**: Manages token storage and retrieval
5. **Tenant Management**: Handles multi-tenant functionality

## Authentication States

The authentication system uses a comprehensive state model:

```dart
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState { }

class Unauthenticated extends AuthenticationState { }

class Authenticating extends AuthenticationState {
  final String? message;
  const Authenticating({this.message});
}

class Authenticated extends AuthenticationState {
  final AppUser user;
  final String token;
  final CurrentTenant? tenant;
  
  const Authenticated({
    required this.user,
    required this.token,
    this.tenant,
  });
}

class TenantSelection extends AuthenticationState {
  final AppUser user;
  final List<Tenant> availableTenants;
  
  const TenantSelection({
    required this.user,
    required this.availableTenants,
  });
}

class AuthenticationError extends AuthenticationState {
  final String message;
  final String? errorCode;
  
  const AuthenticationError({
    required this.message,
    this.errorCode,
  });
}
```

## Authentication Providers

The framework supports multiple authentication providers:

### 1. Google Sign-In

```dart
class GoogleAuthProvider implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  @override
  Future<AuthResult> authenticate() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      return AuthResult.cancelled();
    }
    
    final GoogleSignInAuthentication auth = await account.authentication;
    
    return AuthResult.success(
      token: auth.accessToken!,
      refreshToken: auth.idToken,
      userInfo: {
        'email': account.email,
        'name': account.displayName,
        'avatar': account.photoUrl,
      },
    );
  }
}
```

### 2. Apple Sign-In

```dart
class AppleAuthProvider implements AuthProvider {
  @override
  Future<AuthResult> authenticate() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    
    return AuthResult.success(
      token: credential.identityToken!,
      refreshToken: credential.authorizationCode,
      userInfo: {
        'email': credential.email,
        'userId': credential.userIdentifier,
      },
    );
  }
}
```

### 3. Microsoft Azure AD

```dart
class MicrosoftAuthProvider implements AuthProvider {
  final AadOAuth _aadOAuth = AadOAuth(Config(
    tenant: Environment.azureTenant,
    clientId: Environment.azureClientId,
    scope: 'openid profile email',
    redirectUri: Environment.azureRedirectUri,
  ));
  
  @override
  Future<AuthResult> authenticate() async {
    final result = await _aadOAuth.login();
    
    if (result.isSuccess) {
      return AuthResult.success(
        token: result.accessToken!,
        refreshToken: result.refreshToken,
      );
    }
    return AuthResult.error('Microsoft login failed');
  }
}
```

### 4. Biometric Authentication

```dart
class BiometricAuthProvider {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  Future<bool> isBiometricAvailable() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }
  
  Future<AuthResult> authenticateWithBiometrics() async {
    final isAuthenticated = await _localAuth.authenticate(
      localizedReason: 'Please authenticate to access your account',
      options: AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    
    if (isAuthenticated) {
      // Retrieve stored credentials
      final token = await _secureStorage.read('biometric_token');
      if (token != null) {
        return AuthResult.success(token: token);
      }
    }
    return AuthResult.cancelled();
  }
}
```

## Multi-Tenant Support

### Tenant Management

```dart
class TenantManager {
  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  
  Future<List<Tenant>> getAvailableTenants(String userId) async {
    final response = await _apiClient.get('/users/$userId/tenants');
    if (response.isSuccess) {
      return (response.data as List)
          .map((json) => Tenant.fromJson(json))
          .toList();
    }
    throw Exception('Failed to fetch tenants');
  }
  
  Future<void> selectTenant(String tenantId) async {
    await _secureStorage.write('selected_tenant_id', tenantId);
    _apiClient.setTenantHeader(tenantId);
  }
}
```

## Token Management

### Token Refresh

```dart
class TokenManager {
  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  
  Future<void> startTokenRefresh() async {
    final token = await _secureStorage.read('auth_token');
    if (token != null) {
      final expiryTime = _getTokenExpiry(token);
      final refreshTime = expiryTime.subtract(Duration(minutes: 5));
      
      if (refreshTime.isAfter(DateTime.now())) {
        // Schedule refresh
        Timer(refreshTime.difference(DateTime.now()), _refreshToken);
      } else {
        await _refreshToken();
      }
    }
  }
  
  Future<void> _refreshToken() async {
    final refreshToken = await _secureStorage.read('refresh_token');
    final response = await _apiClient.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    
    if (response.isSuccess) {
      await _secureStorage.write('auth_token', response.data['access_token']);
      await _secureStorage.write('refresh_token', response.data['refresh_token']);
      _apiClient.setAuthToken(response.data['access_token']);
    }
  }
}
```

## Security Best Practices

### Token Storage

```dart
class SecureTokenStorage {
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final secureStorage = GetIt.instance<SecureStorage>();
    
    await Future.wait([
      secureStorage.write(tokenKey, accessToken),
      secureStorage.write(refreshTokenKey, refreshToken),
    ]);
  }
  
  static Future<AuthTokens?> getTokens() async {
    final secureStorage = GetIt.instance<SecureStorage>();
    
    final results = await Future.wait([
      secureStorage.read(tokenKey),
      secureStorage.read(refreshTokenKey),
    ]);
    
    if (results[0] != null && results[1] != null) {
      return AuthTokens(
        accessToken: results[0]!,
        refreshToken: results[1]!,
      );
    }
    return null;
  }
}
```

---

[Previous: Core Concepts]({{ site.baseurl }}/core-concepts/){: .btn .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Next: State Management]({{ site.baseurl }}/state-management/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }
