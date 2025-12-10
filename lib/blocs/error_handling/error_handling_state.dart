part of "error_handling_bloc.dart";

/// Base class for all error handling states.
abstract class ErrorHandlingState {}

/// Initial state before error handling has been initialized.
class ErrorHandlingInitial extends ErrorHandlingState {}

/// State indicating error handling systems have been configured.
///
/// After initialization, the error handling bloc will automatically capture
/// Flutter framework errors and platform errors.
class ErrorHandlingInitialized extends ErrorHandlingState {}

/// State indicating an error has been successfully captured and reported.
class ErrorCaptured extends ErrorHandlingState {
  /// The error that was captured and reported
  final dynamic error;

  /// Creates an [ErrorCaptured] state with the given error.
  ErrorCaptured(this.error);
}

/// State indicating error capture or reporting failed.
///
/// This state is used when the error handling system itself encounters
/// an error while trying to report an exception.
class ErrorHandlingFailed extends ErrorHandlingState {
  /// Description of what went wrong during error handling
  final String errorMessage;

  /// Creates an [ErrorHandlingFailed] state with the given message.
  ErrorHandlingFailed(this.errorMessage);
}
