import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/supa_architecture.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

import 'enum_badges_page.dart';
import 'microsoft_login_example.dart';
import 'supa_color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables for Microsoft OAuth configuration
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env file doesn't exist, continue with empty environment
    // Users should copy .env.example to .env and configure their Azure settings
    debugPrint(
        "Warning: .env file not found. Please copy .env.example to .env and configure your Azure AD settings.");
  }

  await Hive.initFlutter();

  await SupaArchitecturePlatform.instance.initialize(
    useFirebase: false,
  );

  registerModels();
  registerRepositories();

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/badges',
          builder: (context, state) => const EnumBadgesPage(),
        ),
        GoRoute(
          path: '/microsoft-login',
          builder: (context, state) => const MicrosoftLoginExample(),
        ),
      ],
    );

    final ThemeData lightTheme = ThemeData.from(
      colorScheme: lightColorScheme,
      useMaterial3: true,
    ).copyWith(
      extensions: const [lightExtendedColorScheme],
    );

    final ThemeData darkTheme = ThemeData.from(
      colorScheme: darkColorScheme,
      useMaterial3: true,
    ).copyWith(
      extensions: const [darkExtendedColorScheme],
    );

    return MaterialApp.router(
      title: 'Supa Architecture Example',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supa Architecture Examples'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Supa Architecture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore the features and examples below',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFeatureCard(
              context,
              icon: Icons.login,
              title: 'Microsoft Login',
              description:
                  'Example implementation of Microsoft OAuth authentication with Azure AD',
              onTap: () => context.go('/microsoft-login'),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              icon: Icons.label,
              title: 'Enum Badges',
              description:
                  'UI components for displaying status badges and enum values',
              onTap: () => context.go('/badges'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
