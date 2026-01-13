---
title: Architecture
layout: default
nav_order: 3
description: "Architectural design and patterns used in Supa Architecture framework."
permalink: /architecture/
---

# Architecture

The Supa Architecture framework implements a layered architecture pattern designed for building scalable, maintainable, and testable Flutter applications. This document details the core design principles and architectural components.

## Purpose and Scope

The architecture document details the core design of the Supa Architecture framework, a Flutter plugin for building scalable, multi-tenant applications with:

- **Consistent patterns** across different application types
- **Separation of concerns** for maintainability
- **Platform abstraction** for cross-platform compatibility
- **Scalable design** for enterprise applications

## High-Level Architecture Overview

The framework implements a **five-layer architecture** with clear boundaries and responsibilities:

### 1. UI Layer

- **Purpose**: Flutter widgets for displaying information and capturing user inputs
- **Components**: Atoms, molecules, organisms, pages, and templates
- **Responsibilities**: 
  - Render user interface
  - Capture user interactions
  - Display application state
  - Navigate between screens

### 2. Business Logic Layer

- **Purpose**: BLoCs (Business Logic Components) managing state and logic
- **Components**: BLoCs, Events, States, and business rules
- **Responsibilities**:
  - Process business logic
  - Manage application state
  - Handle user interactions
  - Coordinate between UI and data layers

### 3. Repository Layer

- **Purpose**: Providing a clean API for data access
- **Components**: Repository interfaces and implementations
- **Responsibilities**:
  - Abstract data sources
  - Implement caching strategies
  - Handle data transformation
  - Manage data consistency

### 4. Data Access Layer

- **Purpose**: Handling communication with APIs and storage systems
- **Components**: API clients, storage managers, interceptors
- **Responsibilities**:
  - Execute HTTP requests
  - Manage local storage
  - Handle authentication tokens
  - Process network responses

### 5. Platform Abstraction Layer

- **Purpose**: Providing platform-independent access to platform-specific features
- **Components**: Platform interfaces and implementations
- **Responsibilities**:
  - Abstract platform differences
  - Provide unified APIs
  - Handle platform-specific functionality
  - Ensure cross-platform compatibility

## Data Flow Architecture

The framework uses a **unidirectional data flow pattern**, primarily implementing the BLoC (Business Logic Component) pattern for state management:

```
User Interaction → Event → BLoC → Repository → Data Source
                                     ↓
UI Update ← State ← BLoC ← Repository ← Response
```

### Flow Steps

1. **User Interaction**: User performs an action (tap, input, etc.)
2. **Event Dispatch**: UI widget dispatches an event to the appropriate BLoC
3. **Business Logic Processing**: BLoC processes the event and determines required actions
4. **Repository Call**: BLoC calls repository methods to fetch or modify data
5. **Data Source Access**: Repository communicates with APIs or local storage
6. **Response Processing**: Data flows back through the layers
7. **State Emission**: BLoC emits new state based on the results
8. **UI Update**: UI rebuilds automatically based on the new state

### Benefits

- **Predictability**: Data flows in one direction, making behavior predictable
- **Testability**: Each layer can be tested independently
- **Maintainability**: Changes in one layer have minimal impact on others
- **Debuggability**: State changes can be easily tracked and logged

## Platform Abstraction Layer

The framework uses a **platform abstraction mechanism** with three key components:

### 1. Platform Interface (`SupaArchitecturePlatform`)

- **Abstract base class** defining the interface for platform-specific functionality
- **Common API** across all platforms
- **Feature detection** for platform capabilities

### 2. Native Implementation (`MethodChannelSupaArchitecture`)

- **Method channel communication** with native platform code
- **Native storage implementations** (Hive-based)
- **Platform-specific features** (biometrics, file system access)

### 3. Web Implementation (`SupaArchitectureWeb`)

- **Browser API integration** for web-specific functionality
- **Web storage implementations** (localStorage, sessionStorage)
- **Web-specific adaptations** for missing native features

## Component Integration

The framework exports key components in a structured manner:

### Core Exports

```dart
// Main framework entry point
export 'api_client/api_client.dart';
export 'blocs/blocs.dart';
export 'exceptions/exceptions.dart';
export 'json/json.dart';
export 'models/models.dart';
export 'repositories/repositories.dart';
export 'widgets/widgets.dart';
```

### Integration Points

1. **BLoC-Repository Integration**: BLoCs depend on repository interfaces
2. **Repository-API Integration**: Repositories use API clients for data access
3. **Widget-BLoC Integration**: Widgets observe BLoC states and dispatch events
4. **Model-JSON Integration**: Models use the JSON system for serialization
5. **Platform-Core Integration**: Core services use platform abstractions

## Initialization Process

Applications must initialize the framework before use through a structured process:

### 1. Feature Flag Configuration

```dart
// Configure framework features
bool enableFirebase = true;
bool enableSentry = true;
```

### 2. Platform-Specific Initialization

```dart
// Create appropriate implementations based on platform
if (kIsWeb) {
  // Web-specific initialization
  cookieManager = WebCookieManager();
  persistentStorage = WebPersistentStorage();
} else {
  // Native platform initialization
  cookieManager = HiveCookieManager();
  persistentStorage = HivePersistentStorage();
}
```

### 3. Core Service Setup

```dart
// Initialize core services
await SupaArchitecture.initialize(
  cookieManager: cookieManager,
  persistentStorage: persistentStorage,
  secureStorage: secureStorage,
  enableFirebase: enableFirebase,
  enableSentry: enableSentry,
);
```

### 4. Dependency Registration

```dart
// Register services with dependency injection
GetIt.instance.registerSingleton<ApiClient>(apiClient);
GetIt.instance.registerSingleton<AuthRepository>(authRepository);
```

## Architectural Patterns

### 1. Repository Pattern

- **Interface segregation** for different data concerns
- **Implementation flexibility** for different data sources
- **Caching strategies** at the repository level
- **Error handling** abstraction

### 2. BLoC Pattern

- **Event-driven architecture** for user interactions
- **State management** with immutable state objects
- **Reactive programming** with streams
- **Separation of concerns** between UI and business logic

### 3. Dependency Injection

- **Service locator pattern** with GetIt
- **Interface-based dependencies** for testability
- **Lazy initialization** for performance
- **Scope management** for different service lifetimes

### 4. Platform Interface Pattern

- **Abstract interface** for cross-platform APIs
- **Platform-specific implementations** for native features
- **Feature detection** for optional capabilities
- **Graceful degradation** when features are unavailable

## Error Handling Strategy

### 1. Layered Error Handling

- **UI Layer**: Display user-friendly error messages
- **BLoC Layer**: Process and categorize errors
- **Repository Layer**: Handle data-specific errors
- **API Layer**: Process HTTP and network errors

### 2. Global Error Management

- **Centralized error logging** with Sentry integration
- **Error categorization** by severity and type
- **Recovery strategies** for different error types
- **User notification** for actionable errors

### 3. Error Types

- **Network errors**: Connectivity and HTTP issues
- **Authentication errors**: Token and permission issues
- **Validation errors**: Data format and constraint violations
- **Business logic errors**: Domain-specific rule violations

## Performance Considerations

### 1. State Management

- **Efficient state updates** with minimal rebuilds
- **State persistence** for critical data
- **Memory management** for large datasets
- **Background processing** for heavy operations

### 2. Data Access

- **Caching strategies** to reduce network requests
- **Lazy loading** for large datasets
- **Pagination** for list-based data
- **Background sync** for offline capability

### 3. Platform Optimization

- **Platform-specific optimizations** where beneficial
- **Bundle size optimization** for web platforms
- **Memory usage optimization** for mobile platforms
- **Performance monitoring** with integrated tools

---

[Previous: Overview]({{ site.baseurl }}/overview/){: .btn .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Next: Core Concepts]({{ site.baseurl }}/core-concepts/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }
