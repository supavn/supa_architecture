import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/supa_architecture.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

import 'example_app.dart';

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
