import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/blocs/authentication/authentication_bloc.dart';

class MicrosoftLoginExample extends StatefulWidget {
  const MicrosoftLoginExample({super.key});

  @override
  State<MicrosoftLoginExample> createState() => _MicrosoftLoginExampleState();
}

class _MicrosoftLoginExampleState extends State<MicrosoftLoginExample> {
  late AuthenticationBloc _authBloc;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc();

    // Configure Azure AD OAuth with the navigator key and redirect URI
    _authBloc.configureAzureAD(
      _navigatorKey,
      dotenv.env['AZURE_REDIRECT_URI'] ??
          'https://login.microsoftonline.com/common/oauth2/nativeclient',
    );

    _authBloc.handleInitialize();
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microsoft Login Example',
      navigatorKey: _navigatorKey,
      home: BlocProvider.value(
        value: _authBloc,
        child: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microsoft Login Example'),
        centerTitle: true,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.title}: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserAuthenticatedWithSelectedTenantState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  user: state.user,
                  tenant: state.tenant,
                ),
              ),
            );
          } else if (state is UserAuthenticatedWithMultipleTenantsState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TenantSelectionScreen(
                  tenants: state.tenants,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationProcessingState) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing login...'),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Microsoft Login Button
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(LoginWithMicrosoftEvent());
                    },
                    icon: const Icon(Icons.business, color: Colors.white),
                    label: const Text(
                      'Sign in with Microsoft',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF0078D4), // Microsoft blue
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Google Login Button (for comparison)
                  OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(LoginWithGoogleEvent());
                    },
                    icon: const Icon(Icons.login, color: Colors.blue),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Apple Login Button (for comparison - iOS only)
                  if (Theme.of(context).platform == TargetPlatform.iOS)
                    OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(LoginWithAppleEvent());
                      },
                      icon: const Icon(Icons.apple, color: Colors.black),
                      label: const Text(
                        'Sign in with Apple',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TenantSelectionScreen extends StatelessWidget {
  final List<dynamic> tenants;

  const TenantSelectionScreen({
    super.key,
    required this.tenants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Organization'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select an organization to continue:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final tenant = tenants[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(tenant.name ?? 'Organization ${index + 1}'),
                      subtitle: tenant.description != null
                          ? Text(tenant.description!)
                          : null,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.read<AuthenticationBloc>().add(
                              LoginWithSelectedTenantEvent(tenant: tenant),
                            );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final dynamic user;
  final dynamic tenant;

  const DashboardScreen({
    super.key,
    required this.user,
    required this.tenant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(UserLogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (user.fullName?.value != null)
                      _buildInfoRow('Name', user.fullName!.value!),
                    if (user.email?.value != null)
                      _buildInfoRow('Email', user.email!.value!),
                    if (user.phoneNumber?.value != null)
                      _buildInfoRow('Phone', user.phoneNumber!.value!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organization Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Organization', tenant.name ?? 'N/A'),
                    if (tenant.description != null)
                      _buildInfoRow('Description', tenant.description!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '🎉 Microsoft Login Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'You have successfully authenticated using your Microsoft account.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
