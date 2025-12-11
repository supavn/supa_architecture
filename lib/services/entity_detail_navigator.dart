import 'package:flutter/widgets.dart';

/// An abstract navigator for handling navigation to entity detail pages.
///
/// This class provides a generic interface for navigating to detail views of
/// entities and retrieving entity data. Implementations should provide
/// platform-specific or entity-type-specific navigation logic.
///
/// Type parameter:
/// - [T]: The type of entity that this navigator handles
///
/// ## Example
///
/// ```dart
/// class UserDetailNavigator extends EntityDetailNavigator<User> {
///   @override
///   Future<void> navigate(BuildContext context) async {
///     Navigator.push(context, MaterialPageRoute(
///       builder: (_) => UserDetailPage(),
///     ));
///   }
///
///   @override
///   Future<User> getEntity(int entityId) async {
///     return await userRepository.getUserById(entityId);
///   }
/// }
/// ```
abstract class EntityDetailNavigator<T> {
  /// Navigates to the detail page for the entity.
  ///
  /// Parameters:
  /// - [context]: The BuildContext to use for navigation
  ///
  /// Implementations should use this context to push a new route or navigate
  /// to the appropriate detail page.
  Future<void> navigate(
    BuildContext context,
  );

  /// Retrieves the entity data by its ID.
  ///
  /// Parameters:
  /// - [entityId]: The unique identifier of the entity to retrieve
  ///
  /// Returns a `Future<T>` containing the entity data.
  ///
  /// Throws:
  /// - May throw exceptions if the entity cannot be found or retrieved.
  Future<T> getEntity(int entityId);
}
