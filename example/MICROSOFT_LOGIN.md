# Microsoft Login Example

This example demonstrates how to implement Microsoft OAuth authentication using Azure AD with the Supa Architecture library.

## Overview

The Microsoft login feature integrates with Azure Active Directory (Azure AD) to provide secure authentication for your Flutter application. This implementation supports:

- Microsoft OAuth 2.0 authentication flow
- Multi-tenant application support
- Automatic tenant selection for single-tenant users
- Manual tenant selection for multi-tenant users
- Session persistence and restoration
- Logout functionality

## Prerequisites

Before running the example, you need to set up an Azure AD application:

### 1. Azure AD App Registration

1. Go to the [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** > **App registrations**
3. Click **New registration**
4. Configure your application:
   - **Name**: Your app name (e.g., "My Flutter App")
   - **Supported account types**: Choose based on your needs
   - **Redirect URI**: 
     - Platform: **Mobile and desktop applications**
     - URI: `https://login.microsoftonline.com/common/oauth2/nativeclient`
5. Click **Register**

### 2. Get Required Configuration Values

After registration, note down these values from your Azure AD app:

- **Application (client) ID**: Found on the Overview page
- **Directory (tenant) ID**: Found on the Overview page
- **Object ID**: Found on the Overview page (optional)

### 3. Configure API Permissions

1. Go to **API permissions** in your Azure AD app
2. Ensure these permissions are granted:
   - `openid` (Sign users in)
   - `profile` (View users' basic profile)
   - `offline_access` (Maintain access to data you have given it access to)

## Setup Instructions

### 1. Environment Configuration

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your Azure AD configuration:
   ```env
   AZURE_TENANT_ID=your-tenant-id-here
   AZURE_CLIENT_ID=your-client-id-here
   AZURE_REDIRECT_URI=https://login.microsoftonline.com/common/oauth2/nativeclient
   BASE_API_URL=https://your-api-url.com
   ```

### 2. Dependencies

The required dependencies are already included in the main library:

```yaml
dependencies:
  aad_oauth: ^1.0.1
  flutter_dotenv: ^5.2.1
  flutter_bloc: ^9.1.1
```

### 3. Run the Example

```bash
flutter pub get
flutter run
```

## Code Implementation

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/blocs/authentication/authentication_bloc.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthenticationBloc _authBloc;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc();
    
    // Configure Azure AD OAuth
    _authBloc.configureAzureAD(
      _navigatorKey,
      dotenv.env['AZURE_REDIRECT_URI'] ?? 'https://login.microsoftonline.com/common/oauth2/nativeclient',
    );
    
    _authBloc.handleInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: BlocProvider.value(
        value: _authBloc,
        child: LoginScreen(),
      ),
    );
  }
}
```

### Login Button

```dart
ElevatedButton.icon(
  onPressed: () {
    context.read<AuthenticationBloc>().add(LoginWithMicrosoftEvent());
  },
  icon: Icon(Icons.business, color: Colors.white),
  label: Text('Sign in with Microsoft'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF0078D4), // Microsoft blue
  ),
)
```

### State Management

```dart
BlocListener<AuthenticationBloc, AuthenticationState>(
  listener: (context, state) {
    if (state is AuthenticationErrorState) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.title}: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (state is UserAuthenticatedWithSelectedTenantState) {
      // Navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            user: state.user,
            tenant: state.tenant,
          ),
        ),
      );
    } else if (state is UserAuthenticatedWithMultipleTenantsState) {
      // Show tenant selection
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TenantSelectionScreen(
            tenants: state.tenants,
          ),
        ),
      );
    }
  },
  child: YourLoginWidget(),
)
```

## Authentication Flow

1. **User taps "Sign in with Microsoft"**
2. **OAuth configuration is validated** using environment variables
3. **Azure AD login page opens** in a WebView
4. **User enters Microsoft credentials**
5. **Azure AD redirects back** with authorization code
6. **Backend processes the token** and returns tenant information
7. **Tenant selection** (if multiple tenants) or automatic login (single tenant)
8. **User profile and session** are established

## Error Handling

The authentication bloc handles various error scenarios:

- **Invalid credentials**: Shows error message from Azure AD
- **Network issues**: Displays connection error
- **Configuration errors**: Shows setup-related errors
- **User cancellation**: Returns to login screen

## Multi-Tenant Support

If your Azure AD application supports multiple tenants:

1. After successful authentication, users will see a tenant selection screen
2. Users can choose which organization to access
3. The selected tenant determines the user's permissions and data access

## Logout

```dart
ElevatedButton(
  onPressed: () {
    context.read<AuthenticationBloc>().add(UserLogoutEvent());
  },
  child: Text('Logout'),
)
```

## Troubleshooting

### Common Issues

1. **"AADSTS50011: The reply URL specified in the request does not match"**
   - Ensure your redirect URI in Azure AD matches exactly: `https://login.microsoftonline.com/common/oauth2/nativeclient`

2. **"Configuration error"**
   - Check that all required environment variables are set in `.env`
   - Verify your Azure AD application settings

3. **"Network error"**
   - Ensure your backend API is running and accessible
   - Check your `BASE_API_URL` configuration

4. **"No tenants found"**
   - Verify the user has access to at least one tenant/organization
   - Check Azure AD permissions and group assignments

### Debug Mode

Enable debug logging by running:
```bash
flutter run --debug
```

Check the console for detailed authentication flow information.

## Security Considerations

1. **Never commit `.env` files** containing real credentials to version control
2. **Use different Azure AD apps** for development and production
3. **Implement proper token refresh** handling in your backend
4. **Validate tokens server-side** before trusting user authentication
5. **Use HTTPS** for all API communications

## Backend Integration

Your backend should handle the Microsoft token validation and user management. The authentication bloc sends the ID token to your configured `BASE_API_URL` endpoints:

- `POST /auth/microsoft` - Microsoft login
- `POST /auth/token` - Create tenant-specific token
- `GET /auth/profile` - Get user profile information
- `POST /auth/logout` - Logout user

## Additional Features

- **Session persistence**: Automatically restores user sessions on app restart
- **Biometric authentication**: Can be combined with local authentication
- **Multiple OAuth providers**: Supports Google and Apple login alongside Microsoft
- **Profile management**: Update user preferences and notification settings

For more information, see the complete example implementation in `lib/microsoft_login_example.dart`.