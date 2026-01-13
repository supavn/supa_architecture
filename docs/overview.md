---
title: Overview
layout: default
nav_order: 2
description: "Overview of the Supa Architecture framework for Flutter applications."
permalink: /overview/
---

# Overview

The Supa Architecture framework is a comprehensive Flutter plugin designed to provide a foundational architecture for building scalable, multi-tenant Flutter applications. It offers a structured approach to common application concerns including authentication, data management, UI components, and platform abstractions.

## Purpose and Scope

Supa Architecture serves as an opinionated architecture framework that:

- Enforces consistent design patterns across Flutter applications
- Simplifies multi-tenant authentication flows
- Provides platform abstractions for web and native implementations
- Standardizes data models and API communication
- Implements robust state management using the BLoC pattern
- Offers reusable UI components for common use cases

The framework is designed to support large-scale modular development across multiple platforms, including Android, iOS, Web, macOS, Windows, and Linux.

## Core Components

The Supa Architecture framework consists of several interrelated subsystems that work together to provide a complete application architecture:

- **Authentication System**: Multi-tenant authentication with various providers
- **Data Layer**: Repository pattern with API client abstraction
- **UI Components**: Reusable widgets and templates
- **Notification System**: Push and in-app notification handling
- **Navigation**: Declarative routing with authentication awareness
- **Error Handling**: Structured error management and logging

## Platform Abstraction Layer

Supa Architecture implements a platform abstraction layer that allows applications to run seamlessly across different platforms by providing platform-specific implementations of core functionality.

## Data Flow Architecture

The framework implements a unidirectional data flow architecture using the BLoC (Business Logic Component) pattern, which separates the UI, business logic, and data access layers.

## Authentication System

The authentication system is a core component of Supa Architecture, supporting multiple authentication providers and multi-tenant applications with features like:

- Token management and refresh
- Persistent login sessions
- Biometric authentication support
- Multi-provider authentication (Google, Apple, Microsoft)

## Notification System

The notification system handles push notifications and in-app notifications, providing a structured way to process and display notifications to users with Firebase Messaging integration.

## Core Features

The framework provides a wide range of features across categories like:

| Category | Features |
|----------|----------|
| **Authentication** | Multi-provider, multi-tenant support |
| **Data Management** | Repository pattern with caching |
| **State Management** | BLoC pattern implementation |
| **Storage** | Secure and persistent storage abstractions |
| **UI Components** | Atoms, molecules, organisms, and templates |
| **Navigation** | Declarative routing with GoRouter |
| **Error Handling** | Global error management with Sentry integration |
| **Push Notifications** | Firebase Messaging support |

## Version and Compatibility

- Current version: 1.8.4+1
- Requires Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Compatible with Android, iOS, Web, macOS, Windows, and Linux platforms

## Framework Dependencies

The framework relies on industry-standard packages for:

- State management (bloc, flutter_bloc)
- Authentication (google_sign_in, sign_in_with_apple, local_auth)
- Storage (hive, flutter_secure_storage)
- Networking (dio)
- Monitoring (firebase_crashlytics, sentry_flutter)

---

[Next: Architecture]({{ site.baseurl }}/architecture/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
