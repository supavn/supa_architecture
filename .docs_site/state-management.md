---
title: State Management
layout: default
nav_order: 6
description: "BLoC pattern implementation for state management in Supa Architecture."
permalink: /state-management/
---

# State Management

The Supa Architecture framework uses the BLoC (Business Logic Component) pattern extensively for state management, following a unidirectional data flow that makes applications easier to reason about and test.

## BLoC Pattern Implementation

The framework separates presentation from business logic using a structured approach that promotes maintainability and testability.

### Core Characteristics

The BLoC pattern separates presentation from business logic, with:

- **Events**: Triggered by user actions or external systems
- **BLoC**: Processes events and updates state accordingly
- **States**: Represent snapshots of data that the UI displays
- **Repositories**: Interface with data sources to retrieve or manipulate data

### Architecture Flow

```
UI Components → Events → BLoC → Repositories → Data Sources
            ←        ←      ←             ←
           States   BLoC   Repositories  Data Sources
```

The data flows unidirectionally through the following steps:

1. **User Interaction**: User performs an action in the UI
2. **Event Dispatch**: UI dispatches an event to the corresponding BLoC
3. **Event Processing**: BLoC processes the event and determines required actions
4. **Repository Call**: BLoC calls repository methods to fetch or modify data
5. **Data Access**: Repository communicates with APIs or local storage
6. **Response Processing**: Data flows back through the layers
7. **State Emission**: BLoC emits new state based on the results
8. **UI Update**: UI rebuilds automatically based on the new state

### Key Benefits

This pattern ensures:

1. **Separation of Concerns**: Clear boundaries between UI, business logic, and data
2. **Testability**: Each layer can be tested independently with mock implementations
3. **Maintainability**: Changes in one layer have minimal impact on others
4. **Predictability**: Data flows in one direction, making behavior predictable
5. **Debuggability**: State changes can be easily tracked and logged

## State Management Dependencies

The framework uses several key libraries for state management:

| Package | Purpose |
|---------|---------|
| `bloc` | Core state management library providing BLoC functionality |
| `flutter_bloc` | Flutter widgets for BLoC pattern integration |
| `equatable` | Simplifies equality comparisons for immutable objects |
| `get_it` | Service locator for dependency injection |
| `injectable` | Code generator for dependency injection setup |

## BLoC Structure

### Event Definition

Events represent actions that can occur in the application:

```dart
abstract class ExampleEvent extends Equatable {
  const ExampleEvent();
}

class LoadDataEvent extends ExampleEvent {
  @override
  List<Object> get props => [];
}

class RefreshDataEvent extends ExampleEvent {
  @override
  List<Object> get props => [];
}
```

### State Definition

States represent the current condition of the application:

```dart
abstract class ExampleState extends Equatable {
  const ExampleState();
}

class ExampleInitial extends ExampleState {
  @override
  List<Object> get props => [];
}

class ExampleLoading extends ExampleState {
  @override
  List<Object> get props => [];
}

class ExampleLoaded extends ExampleState {
  final List<DataModel> data;
  
  const ExampleLoaded({required this.data});
  
  @override
  List<Object> get props => [data];
}

class ExampleError extends ExampleState {
  final String message;
  
  const ExampleError({required this.message});
  
  @override
  List<Object> get props => [message];
}
```

### BLoC Implementation

```dart
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleRepository repository;
  
  ExampleBloc({required this.repository}) : super(ExampleInitial()) {
    on<LoadDataEvent>(_onLoadData);
    on<RefreshDataEvent>(_onRefreshData);
  }
  
  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    try {
      final data = await repository.fetchData();
      emit(ExampleLoaded(data: data));
    } catch (error) {
      emit(ExampleError(message: error.toString()));
    }
  }
  
  Future<void> _onRefreshData(
    RefreshDataEvent event,
    Emitter<ExampleState> emit,
  ) async {
    try {
      final data = await repository.refreshData();
      emit(ExampleLoaded(data: data));
    } catch (error) {
      emit(ExampleError(message: error.toString()));
    }
  }
}
```

## Framework BLoCs

The framework includes several pre-built BLoCs for common functionality:

### AuthenticationBloc

Manages user authentication state and processes authentication-related events:

- **Events**: Login, logout, token refresh, tenant selection
- **States**: Unauthenticated, authenticating, authenticated, tenant selection
- **Responsibilities**: Handle login flows, manage authentication tokens, switch tenants

### PushNotificationBloc

Handles push notification state and processing:

- **Events**: Initialize notifications, process notification, handle permission
- **States**: Permission states, notification processing states
- **Responsibilities**: Manage notification permissions, process incoming notifications

### ErrorHandlingBloc

Manages global error state and error reporting:

- **Events**: Report error, clear error, handle error
- **States**: Error states with categorization and details
- **Responsibilities**: Centralize error handling, integrate with error reporting services

### TenantBloc

Manages multi-tenant functionality:

- **Events**: Switch tenant, load tenant data
- **States**: Tenant selection, tenant loaded
- **Responsibilities**: Handle tenant switching, manage tenant-specific configuration

## UI Integration

### BlocBuilder

Use `BlocBuilder` to rebuild UI based on state changes:

```dart
BlocBuilder<ExampleBloc, ExampleState>(
  builder: (context, state) {
    if (state is ExampleLoading) {
      return LoadingIndicator();
    } else if (state is ExampleLoaded) {
      return DataListView(data: state.data);
    } else if (state is ExampleError) {
      return ErrorMessage(message: state.message);
    }
    return EmptyView();
  },
)
```

### BlocListener

Use `BlocListener` for side effects like navigation or showing dialogs:

```dart
BlocListener<ExampleBloc, ExampleState>(
  listener: (context, state) {
    if (state is ExampleError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: ChildWidget(),
)
```

### BlocConsumer

Combine `BlocBuilder` and `BlocListener` for both UI updates and side effects:

```dart
BlocConsumer<ExampleBloc, ExampleState>(
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI based on state
  },
)
```

## Dependency Injection

BLoCs are registered with the dependency injection container for easy access:

```dart
// Registration
GetIt.instance.registerFactory<ExampleBloc>(
  () => ExampleBloc(repository: GetIt.instance<ExampleRepository>()),
);

// Usage in widgets
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExampleBloc>(
      create: (context) => GetIt.instance<ExampleBloc>(),
      child: ExampleView(),
    );
  }
}
```

## Best Practices

### 1. State Immutability

Always use immutable state objects with `Equatable` for proper state comparison:

```dart
class ExampleState extends Equatable {
  final String data;
  final bool isLoading;
  
  const ExampleState({
    required this.data,
    required this.isLoading,
  });
  
  @override
  List<Object> get props => [data, isLoading];
  
  ExampleState copyWith({
    String? data,
    bool? isLoading,
  }) {
    return ExampleState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
```

### 2. Error Handling

Include proper error handling in BLoC event handlers:

```dart
Future<void> _onLoadData(
  LoadDataEvent event,
  Emitter<ExampleState> emit,
) async {
  try {
    emit(state.copyWith(isLoading: true));
    final data = await repository.fetchData();
    emit(state.copyWith(data: data, isLoading: false));
  } on NetworkException catch (e) {
    emit(ExampleError(message: 'Network error: ${e.message}'));
  } on AuthenticationException catch (e) {
    emit(ExampleError(message: 'Authentication error: ${e.message}'));
  } catch (e) {
    emit(ExampleError(message: 'Unexpected error: ${e.toString()}'));
  }
}
```

### 3. Testing

Write comprehensive tests for BLoCs:

```dart
group('ExampleBloc', () {
  late ExampleBloc bloc;
  late MockExampleRepository mockRepository;
  
  setUp(() {
    mockRepository = MockExampleRepository();
    bloc = ExampleBloc(repository: mockRepository);
  });
  
  blocTest<ExampleBloc, ExampleState>(
    'emits [ExampleLoading, ExampleLoaded] when LoadDataEvent succeeds',
    build: () {
      when(() => mockRepository.fetchData())
          .thenAnswer((_) async => [DataModel()]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadDataEvent()),
    expect: () => [
      ExampleLoading(),
      ExampleLoaded(data: [DataModel()]),
    ],
  );
});
```

---

[Previous: Authentication]({{ site.baseurl }}/authentication/){: .btn .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Next: Error Handling]({{ site.baseurl }}/error-handling/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }
