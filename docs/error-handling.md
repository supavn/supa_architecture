---
title: Error Handling
layout: default
nav_order: 7
description: "Comprehensive error handling system with Sentry integration."
permalink: /error-handling/
---

# Error Handling

The Supa Architecture framework provides a comprehensive error handling system designed to capture, categorize, and report errors across the entire application stack. The system ensures robust error management while maintaining application stability and providing meaningful feedback to users.

## Purpose and Scope

The error handling system serves several critical functions:

- **Structured Error Management**: Consistent error representation across the application
- **Global Error Tracking**: Centralized error capture and reporting
- **User Experience**: Graceful error handling with meaningful user feedback
- **Development Support**: Detailed error information for debugging and monitoring
- **Integration**: Seamless integration with external error reporting services

## Error Handling Architecture

The framework implements a layered error handling approach:

```
Application Layer (UI)
       ↓
Business Logic Layer (BLoCs)
       ↓
Repository Layer
       ↓
Data Access Layer (API/Storage)
       ↓
External Services
```

Each layer handles errors appropriate to its scope while allowing critical errors to bubble up to higher layers.

## Core Error Components

### SupaException Hierarchy

The framework defines a structured exception hierarchy for consistent error handling:

```dart
abstract class SupaException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  const SupaException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });
}
```

### Specific Exception Types

#### Network Exceptions

```dart
class NetworkException extends SupaException {
  final int? statusCode;
  final String? endpoint;
  
  const NetworkException({
    required String message,
    this.statusCode,
    this.endpoint,
  });
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'Request timed out',
    String? endpoint,
  }) : super(message: message, endpoint: endpoint, code: 'TIMEOUT');
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    String message = 'No internet connection',
  }) : super(message: message, code: 'NO_INTERNET');
}
```

#### Authentication Exceptions

```dart
class AuthenticationException extends SupaException {
  const AuthenticationException({
    required String message,
    String? code,
  });
}

class TokenExpiredException extends AuthenticationException {
  const TokenExpiredException({
    String message = 'Authentication token has expired',
  }) : super(message: message, code: 'TOKEN_EXPIRED');
}

class UnauthorizedException extends AuthenticationException {
  const UnauthorizedException({
    String message = 'Unauthorized access',
  }) : super(message: message, code: 'UNAUTHORIZED');
}
```

#### Validation Exceptions

```dart
class ValidationException extends SupaException {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationException({
    required String message,
    required this.fieldErrors,
    String? code,
  });
}

class BusinessRuleException extends SupaException {
  const BusinessRuleException({
    required String message,
    String? code,
  });
}
```

## Global Error Handling

### ErrorHandlingBloc

The framework includes a dedicated BLoC for global error management:

```dart
class ErrorHandlingBloc extends Bloc<ErrorHandlingEvent, ErrorHandlingState> {
  final ErrorReportingService _errorReportingService;
  final Logger _logger;
  
  ErrorHandlingBloc({
    required ErrorReportingService errorReportingService,
    required Logger logger,
  }) : super(ErrorHandlingInitial()) {
    on<ReportError>(_onReportError);
  }
  
  Future<void> _onReportError(
    ReportError event,
    Emitter<ErrorHandlingState> emit,
  ) async {
    // Log error locally
    _logger.error(
      event.error.message,
      error: event.error.originalError,
      stackTrace: event.error.stackTrace,
    );
    
    // Report to external services
    await _errorReportingService.reportError(
      event.error,
      context: event.context,
      userId: event.userId,
    );
  }
}
```

## Error Reporting Integration

### Sentry Integration

```dart
class SentryErrorReportingService implements ErrorReportingService {
  @override
  Future<void> initialize({required String dsn}) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = Environment.current;
        options.tracesSampleRate = 0.1;
      },
    );
  }
  
  @override
  Future<void> reportError(
    SupaException error, {
    Map<String, dynamic>? context,
    String? userId,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: error.stackTrace,
      withScope: (scope) {
        if (userId != null) {
          scope.setUser(SentryUser(id: userId));
        }
        
        if (context != null) {
          scope.setContexts('additional_context', context);
        }
        
        scope.setTag('error_code', error.code ?? 'unknown');
        scope.setLevel(SentryLevel.error);
      },
    );
  }
}
```

### Firebase Crashlytics Integration

```dart
class FirebaseCrashlyticsService implements ErrorReportingService {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }
  
  @override
  Future<void> reportError(
    SupaException error, {
    Map<String, dynamic>? context,
    String? userId,
  }) async {
    if (userId != null) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
    
    await FirebaseCrashlytics.instance.recordError(
      error,
      error.stackTrace,
      reason: error.message,
    );
  }
}
```

## Layer-Specific Error Handling

### API Layer Error Handling

```dart
class ApiClient {
  Future<HttpResponse<T>> request<T>({
    required String method,
    required String path,
  }) async {
    try {
      final response = await _dio.request(path);
      return HttpResponse.success(response.data);
    } on DioException catch (e) {
      final supaException = _mapDioException(e);
      return HttpResponse.error(supaException);
    }
  }
  
  SupaException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return TimeoutException(endpoint: e.requestOptions.path);
      case DioExceptionType.connectionError:
        return NoInternetException();
      default:
        return NetworkException(message: e.message ?? 'Unknown error');
    }
  }
}
```

### Repository Layer Error Handling

```dart
abstract class BaseRepository {
  Future<Result<T>> safeCall<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      final result = await operation();
      return Result.success(result);
    } on SupaException catch (e) {
      return Result.error(e);
    } catch (e, stackTrace) {
      final supaException = SupaException(
        message: 'Repository operation failed: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
      return Result.error(supaException);
    }
  }
}
```

## UI Error Handling

### Error Display Components

```dart
class ErrorMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 8),
          Text(message),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
```

### Global Error Handler

```dart
class GlobalErrorHandler extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorHandlingBloc, ErrorHandlingState>(
      listener: (context, state) {
        if (state is ErrorHandlingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${state.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: child,
    );
  }
}
```

## Best Practices

### 1. Error Context

Always provide meaningful context when reporting errors:

```dart
void reportErrorWithContext(SupaException error) {
  final context = {
    'user_id': currentUser?.id,
    'screen': currentRoute,
    'timestamp': DateTime.now().toIso8601String(),
    'app_version': packageInfo.version,
    'platform': Platform.operatingSystem,
  };
  
  errorBloc.add(ReportError(error: error, context: context));
}
```

### 2. Error Recovery

```dart
class ErrorRecoveryService {
  static Future<bool> attemptRecovery(SupaException error) async {
    switch (error.code) {
      case 'TOKEN_EXPIRED':
        return await _refreshToken();
      case 'NO_INTERNET':
        return await _waitForConnection();
      default:
        return false;
    }
  }
}
```

---

[Previous: State Management]({{ site.baseurl }}/state-management/){: .btn .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/supavn/supa_architecture){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }
