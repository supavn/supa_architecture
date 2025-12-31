import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supa_architecture/blocs/authentication/authentication_bloc.dart';

import 'dashboard_screen.dart';
import 'tenant_selection_screen.dart';

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
