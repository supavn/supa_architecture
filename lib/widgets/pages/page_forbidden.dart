import 'package:flutter/material.dart';
import 'package:supa_architecture/widgets/atoms/go_back_button.dart';
import 'package:supa_architecture/widgets/organisms/forbidden_component.dart';

/// A full page widget that displays a forbidden access screen.
///
/// This page is used when a user attempts to access a resource they don't
/// have permission to view. It includes an app bar with a back button and
/// a [ForbiddenComponent] in the body that displays the forbidden message
/// and navigation options.
///
/// **Usage:**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => PageForbidden()),
/// )
/// ```
class PageForbidden extends StatelessWidget {
  const PageForbidden({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Truy cập bị chặn'),
        leading: const GoBackButton(),
      ),
      body: const ForbiddenComponent(
        fallbackRoute: '/',
      ),
    );
  }
}
