---
title: Core Concepts
layout: default
nav_order: 4
description: "Core architectural concepts and patterns in Supa Architecture."
permalink: /core-concepts/
---

# Core Concepts

The core concepts document outlines the foundational architectural principles of the `supa_architecture` framework, designed to create scalable and maintainable Flutter applications.

## Key Architectural Principles

1. **Layered Architecture**: Clear separation between UI, business logic, and data layers
2. **Separation of Concerns**: Each component has a single, well-defined responsibility
3. **Unidirectional Data Flow**: Predictable state management and data flow
4. **Dependency Injection**: Loosely coupled components for better testability
5. **Cross-Platform Abstraction**: Consistent API across all supported platforms

## Architectural Patterns

### Layered Architecture

The framework implements a clear multi-layer architecture:

1. **UI Layer**: Flutter widgets for rendering and user interaction
2. **Business Logic Layer**: BLoCs managing state and logic
3. **Repository Layer**: Mediating data access
4. **Data Access Layer**: Handling API and storage communication

### BLoC Pattern Implementation

The framework uses the Business Logic Component (BLoC) pattern with:

- **Events**: Triggered by user actions or system events
- **BLoC**: Processes events and updates state
- **States**: Represent data snapshots at specific points in time
- **Repositories**: Interface with data sources and external services

```dart
// Example BLoC structure
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleRepository repository;
  
  ExampleBloc({required this.repository}) : super(ExampleInitial()) {
    on<ExampleEventTriggered>(_onEventTriggered);
  }
  
  Future<void> _onEventTriggered(
    ExampleEventTriggered event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    try {
      final result = await repository.fetchData();
      emit(ExampleSuccess(data: result));
    } catch (error) {
      emit(ExampleError(message: error.toString()));
    }
  }
}
```

### Repository Pattern

Repositories provide an abstract interface to data sources, encapsulating:

- Data fetching from multiple sources (API, cache, local storage)
- Local data caching and updates
- Authentication and authorization management
- Service-specific data operations

### JSON Model System

A robust serialization system featuring:

- **Type-safe field definitions**: Strongly typed field declarations
- **Automatic serialization/deserialization**: JSON to Dart object conversion
- **Field validation**: Built-in validation for data integrity
- **Copy with modification capabilities**: Immutable object updates
- **Support for complex nested objects**: Hierarchical data structures

```dart
// Example JSON model
class UserModel extends JsonModel {
  static const JsonField<String> nameField = JsonField('name');
  static const JsonField<String> emailField = JsonField('email');
  static const JsonField<int> ageField = JsonField('age');
  
  String get name => getValue(nameField);
  String get email => getValue(emailField);
  int get age => getValue(ageField);
  
  UserModel copyWith({String? name, String? email, int? age}) {
    return UserModel()
      ..setValue(nameField, name ?? this.name)
      ..setValue(emailField, email ?? this.email)
      ..setValue(ageField, age ?? this.age);
  }
}
```

### Platform Abstraction

Implemented through a platform interface pattern:

- **Platform interface**: Defines common functionality across platforms
- **Platform-specific implementations**: Handle platform differences
- **Consistent API**: Uniform interface regardless of target platform

## Authentication System

Comprehensive authentication features:

- **Multiple authentication providers**: Google, Apple, Microsoft, custom providers
- **Multi-tenant support**: Support for multiple organizations/tenants
- **Token management and refresh**: Automatic token lifecycle management
- **Persistent login sessions**: Remember user authentication state
- **Biometric authentication support**: Fingerprint, Face ID integration

## Cross-Cutting Concerns

### 1. Error Handling

- **Structured error information**: Consistent error data structures
- **Sentry and Firebase Crashlytics integration**: Automatic error reporting
- **Global error handling**: Centralized error management across the application

### 2. Navigation

- **Declarative routing with GoRouter**: Type-safe, declarative navigation
- **Deep linking support**: Handle external links and navigation state
- **Authentication-aware routing**: Route protection based on authentication state

### 3. Notification System

- **Firebase Messaging integration**: Push notification support
- **In-app notification handling**: Local notification management
- **BLoC-based state management**: Reactive notification state handling

## Data Flow

The framework follows a unidirectional data flow pattern:

1. **User Action**: User interacts with UI components
2. **Event Dispatch**: UI dispatches events to BLoCs
3. **Business Logic**: BLoCs process events and call repositories
4. **Data Access**: Repositories fetch data from APIs or storage
5. **State Update**: BLoCs emit new states based on data
6. **UI Update**: UI rebuilds based on new state

This pattern ensures predictable state management and makes the application easier to debug and test.

## Dependency Injection

The framework uses dependency injection to:

- Decouple components from their dependencies
- Enable easy testing with mock implementations
- Provide configurable service implementations
- Support different implementations for different environments

---

[Previous: Architecture]({{ site.baseurl }}/architecture/){: .btn .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Next: Authentication]({{ site.baseurl }}/authentication/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }
