import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A widget that displays a forbidden access message with navigation fallback.
///
/// This component is used to indicate that the user does not have permission
/// to access a particular page or resource. It displays an image, a message,
/// and a button to navigate back or to a fallback route.
///
/// **Usage:**
/// ```dart
/// ForbiddenComponent(
///   fallbackRoute: '/home',
/// )
/// ```
class ForbiddenComponent extends StatelessWidget {
  /// The route to navigate to if the navigation stack cannot be popped.
  ///
  /// This route is used as a fallback when the user cannot go back in the
  /// navigation history.
  final String fallbackRoute;

  /// Creates a [ForbiddenComponent] widget.
  ///
  /// **Parameters:**
  /// - `fallbackRoute`: The route to navigate to if the navigation stack cannot be popped (required).
  const ForbiddenComponent({super.key, required this.fallbackRoute});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/page_forbidden.png'),
            const SizedBox(height: 16),
            const Text(
              'Bạn không có quyền truy cập trang này.',
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                } else {
                  return GoRouter.of(context).go(fallbackRoute);
                }
              },
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
