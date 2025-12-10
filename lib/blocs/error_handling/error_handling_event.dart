part of "error_handling_bloc.dart";

/// Base class for all error handling events.
abstract class ErrorHandlingEvent {}

/// Initializes error handling and crash reporting systems.
///
/// This event sets up automatic error capture for Flutter framework errors
/// and platform-level errors. It should be called during app initialization.
class InitializeErrorHandling extends ErrorHandlingEvent {}

/// Manually captures and reports an exception.
///
/// Use this event to explicitly report errors that are caught in try-catch
/// blocks but should still be logged to crash reporting services.
///
/// **Example:**
/// ```dart
/// try {
///   await riskyOperation();
/// } catch (error) {
///   errorHandlingBloc.captureException(error);
/// }
/// ```
class CaptureException extends ErrorHandlingEvent {
  /// The exception or error to report to crash analytics services
  final dynamic error;

  /// Creates a [CaptureException] event with the given error.
  CaptureException(this.error);
}
