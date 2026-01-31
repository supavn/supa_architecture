# Changelog

All notable changes to this project will be documented in this file.


## v1.15.0

- fix: register WebCookieManager in GetIt and add ApiClient fallback to platform cookie manager for web stability
- move JSON performance comparison to integration tests for device profiling, keeping 5-level nested models and shared test data builders
- re-init package
- add code
- feat: Add payload-only push notification states for data-only FCM messages (no `notification` object)
- Update color property naming in TextStatusBadge and EnumStatusBadge for consistency. Enhance legacy support in EnumStatusBadge while improving theme integration.
- add readme
- Merge branch 'main' of github.com:thanhtunguet/flutter_json_entity
- chore: upgraded to v2.0.0 to avoid conflicts
- feat: add comprehensive tests for JsonModel serialization and deserialization, including nested objects and validation metadata
- chore: add publish_to field in pubspec.yaml for package publication

## v1.14.3

- feat: Update package_info_plus to ^9.0.0

## v1.14.2

- chore: release version 1.14.2 with fix for Microsoft login token retrieval and update changelog

## v1.14.1

- upgrade xcode workspace
- feat: Add environment variable support and new navigation routes for Microsoft Login and Enum Badges in the example app
- refactor: Remove EnumBadgesPage and related navigation from the example app
- feat: Add GoBackButton to AppBar in EnumBadgesPage and LoginScreen for improved navigation
- chore: release version 1.14.1 with fix for Microsoft login token retrieval

## v1.14.0

- chore: release version 1.14.0 with deprecations for file upload methods in favor of a cleaner API

## v1.13.5

- Remove development.md file from rules directory
- Add logging directory to .gitignore, enhance ApiClient documentation, and improve error handling in DioException and interceptors
- Enhance documentation across BLoC files, including detailed descriptions for authentication, error handling, and push notification functionalities. Update CHANGELOG with comprehensive documentation improvements.
- Enhance documentation for JSON field classes, including detailed descriptions for JsonBoolean, JsonDate, JsonDouble, JsonInteger, JsonList, JsonModel, JsonNumber, JsonObject, JsonSerializable, and JsonString. Update CHANGELOG to reflect comprehensive documentation improvements across all JSON-related files.
- Enhance documentation for SupaExtendedColorScheme and SupaExtendedColorTokenGroup, providing detailed descriptions of color tokens and their usage. Update theme.dart to include an overview of the theme package and its components.
- Enhance documentation across services, including detailed descriptions for FileService, FileHandler, EntityDetailNavigator, and timezone services. Update CHANGELOG to reflect comprehensive documentation improvements and platform-specific behavior explanations.
- Enhance documentation for form classes in `lib/forms/`, including detailed descriptions, usage examples, and validation requirements for LoginForm, ForgotPasswordForm, ResetPasswordForm, and ChangePasswordForm. Update CHANGELOG to reflect these comprehensive improvements.
- Refactor filters: remove unused filter classes including AdminTypeFilter, AppUserFilter, DiscussionFilter, and others. Update filters.dart to include new filter parts and clean up models.dart by removing references to deleted filters. Ensure repository files are updated to import the necessary filters.
- Enhance documentation for DioImageProvider in `lib/providers/dio_image_provider.dart`, detailing its functionality, usage examples, and error handling mechanisms. Update `providers.dart` to include a summary of custom image provider implementations, emphasizing advanced features and fallback handling.
- Enhance documentation for utility classes in `lib/utils/`, including detailed comments for PasswordFieldMixin and PlatformUtils with usage examples and parameter descriptions. Update CHANGELOG to reflect these comprehensive documentation improvements.
- Enhance documentation for various widget classes in `lib/widgets/`, including detailed descriptions, usage examples, and parameter explanations for AppImage, GoBackButton, IconPlaceholder, LoadingIndicator, TextStatusBadge, EnumStatusBadge, ConfirmationDialog, EmptyComponent, ForbiddenComponent, SearchableAppBarTitle, SectionTitle, and InfiniteListState. Update CHANGELOG to reflect these comprehensive documentation improvements.
- refactor filters
- Update firebase
- update example pubspec lock
- Using open_filex package
- v1.3.4
- feat: Implement `FileHandler.openFile` for native and web platforms, migrate to `open_filex`, and add internal `.serena/memories` documentation.
- refactor: register repositories as lazy singletons.
- chore: bump package version to 1.13.5
- docs: Fix incorrect version numbers in CHANGELOG.

## v1.13.3

- Update version to 1.13.3, add isAdmin field to AppUser profile, and enhance changelog.

## v1.13.2

- Release version 1.13.0: Remove Image model and replace it with File, update changelog, and adjust version in pubspec.yaml.
- v1.13.2

## v1.13.1

- Update version to 1.13.1 and remove GetIt registrations for CookieManager, PersistentStorage, and SecureStorage in platform interface and web implementation.

## v1.13.0

- Remove deprecated BottomSheetContainer widget and update exports in widgets.dart
- add app_user_group
- add discussion
- Update version to 1.12.0 and remove unused import in latest_comment.dart
- Add GetIt dependency injection for PersistentStorage, CookieManager, and SecureStorage in SupaArchitecturePlatform
- Add Media class export, deprecate Image class, and register additional models in GetIt
- Update version to 1.13.0 and add MediaFile class to the changelog.

## v1.12.0-rc2

- add refactoring plan
- Enhance CookieManager implementations: Add detailed documentation for methods, improve null handling for cookies, and implement token-in-URL functionality for mobile platforms. Update WebCookieManager to rely on native cookie handling without token support.
- Enhance CookieManager functionality: Add duplicate cookie handling with logging for warnings, implement one-time migration for data consistency, and improve cookie cleanup methods. Update documentation to reflect these changes across CookieManager implementations.
- update test code
- Update TextStatusBadge to allow nullable backgroundColor and enhance EnumStatusBadge with calculated background and border colors based on hex input. Update pubspec.lock for version 1.12.0-rc1.
- Update version to 1.12.0-rc2, enhance changelog with EnumStatusBadge fix, and add documentation note for code modifications in AGENTS.md.

## v1.12.0-rc1


## v1.12.0

- Update dependencies in pubspec.yaml and register new models in models.dart: Set intl to any version, upgrade supa_carbon_icons to 0.2.0, and add Period, PeriodFilter, and RequestHistory models.
- Release version 1.11.0: Add isOverdue getter to DateTime extension, introduce Period and RequestHistory models, and enhance PeriodFilter with siteId field.
- Refactor API client and interceptors: Simplify interceptor management by removing platform-specific checks, enhance token refresh handling, and update encryption manager for Hive. Remove biometric login button widget.
- Release version 1.12.0-rc1: Introduce TimezoneService and update dependencies, including flutter_timezone package. Update CHANGELOG and plugin registrations across platforms.
- add refactoring plan
- Enhance CookieManager implementations: Add detailed documentation for methods, improve null handling for cookies, and implement token-in-URL functionality for mobile platforms. Update WebCookieManager to rely on native cookie handling without token support.
- Enhance CookieManager functionality: Add duplicate cookie handling with logging for warnings, implement one-time migration for data consistency, and improve cookie cleanup methods. Update documentation to reflect these changes across CookieManager implementations.
- update test code
- Update TextStatusBadge to allow nullable backgroundColor and enhance EnumStatusBadge with calculated background and border colors based on hex input. Update pubspec.lock for version 1.12.0-rc1.
- Update version to 1.12.0-rc2, enhance changelog with EnumStatusBadge fix, and add documentation note for code modifications in AGENTS.md.
- Remove deprecated BottomSheetContainer widget and update exports in widgets.dart
- add app_user_group
- add discussion

## v1.10.0-rc.14

- add sub_app
- v1.10.0-rc.14

## v1.10.0-rc.13

- Update to version 1.10.0-rc.12: Add globalUserId field to AppUserInfo model and update CHANGELOG.
- Update to version 1.10.0-rc.13: Add account linking functionality for Google, Microsoft, and Apple in PortalProfileRepository and enhance AppUserPreferences model.
- Update to version 1.10.0-rc.13: Add handleInitialNotification method to PushNotificationBloc and enhance AppUserInfo model with additional account fields.

## v1.10.0-rc.11

- Update to version 1.10.0-rc.11: Fix file uploading on web and enhance multipart file handling for both web and native platforms.
- Update CHANGELOG and improve authentication handling for web: Fix authentication issues and ensure persistence of user and tenant data across platforms.

## v1.10.0-rc.10

- Update to version 1.10.0-rc.10: Removed Flutter upper bound constraint in preparation for future updates.
- Remove upper bound

## v1.10.0-rc.9

- Update to version 1.10.0-rc.9: Added secure encryption for persistent data and implemented fallback mechanisms in HiveCookieManager and HivePersistentStorage for handling encryption failures.

## v1.10.0-rc.8

- Update to version 1.10.0-rc.8: Fix device name retrieval for iOS and Android by using utsname and manufacturer name respectively.

## v1.10.0-rc.7

- add initial message event handler
- Update to version 1.10.0-rc.7: Added DidMountedCheckInitialMessage to PushNotificationBloc and removed deprecation annotations for backgroundColor in TextStatusBadge and EnumModel.

## v1.10.0-rc.6

- v1.10.0-rc.6

## v1.10.0-rc.5

- Merge pull request #2 from supavn/main
- Merge commit '6d1ee42a936141c041422ccc05ae7670a4bca257' of github.com:thanhtunguet/flutter_json_entity
- update pubspec lock
- Update pubspec.lock to reflect the latest dependency changes and ensure compatibility with recent updates.
- Enhance EnumBadgesPage with hex color examples and update TextStatusBadge to support background and border color keys. Refactor color key handling for improved clarity in EnumStatusBadge.

## v1.10.0-rc.4

- v1.10.0-rc.4

## v1.10.0-rc.3

- Refactor TextStatusBadge and EnumStatusBadge to improve color property naming for clarity. Update variable names from resolvedBackground, resolvedText, and resolvedBorder to resolvedBackgroundColor, resolvedTextColor, and resolvedBorderColor. Maintain legacy support in EnumStatusBadge while enhancing theme integration.
- v1.10.0-rc.3

## v1.10.0-rc.2

- v1.10.0-rc.2

## v1.10.0-rc.1

- Refactor TestNestedSerializableClass to use public fields instead of private variables for nestedObject and nestedList. Update JSON serialization methods accordingly. Improve performance test expectations to complete within 5 milliseconds.
- Release v1.9.1
- Update JSON serialization methods in TestNestedSerializableClass to improve performance and maintainability. Refactor nestedObject and nestedList to use public fields.
- Refactor SupaExtendedColorScheme to use constants for color keys, improving readability and maintainability. Update switch cases to utilize these constants for color token retrieval.
- Deprecate backgroundColor properties in EnumModel and TextStatusBadge, introducing backgroundColorKey for improved theme integration. Update EnumStatusBadge to utilize new keys while maintaining legacy support.
- Update project configuration and dependencies: enhance .gitignore, update iOS deployment target to 13.0, add GoRouter dependency, and refactor main app structure for improved routing and theme management.
- Enhance text styling in EnumBadgesPage by applying dynamic color to the title text based on the provided token, improving visual consistency with the theme.
- v1.10.0-rc.1
- Update pubspec.lock to version 1.10.0-rc.1, reflecting the latest dependency changes.

## v1.9.1+6

- chore: remove prompt optimization file and update base repository constructor to include new parameters
- chore: bump version to 1.9.1+6, add device info retrieval before platform initialization and update dependencies
- add test and coverage
- Enhance test coverage by running Flutter tests with coverage options for specific directories. Update CI workflow to reflect these changes.

## v1.9.1+5

- chore: bump version to 1.9.1+4, update changelog, and enhance authentication state with equatable mixin
- chore: bump version to 1.9.1+5, update notification handling with new data structure and error state

## v1.9.1+3

- chore: bump version to 1.9.1+3 and update changelog for authentication state fix on language change

## v1.9.1+2

- v1.9.1+2

## v1.9.1+1


## v1.9.1

- feat: v1.9.1+1 - bug fixes
- v1.9.1+2
- chore: bump version to 1.9.1+3 and update changelog for authentication state fix on language change
- chore: bump version to 1.9.1+4, update changelog, and enhance authentication state with equatable mixin
- chore: bump version to 1.9.1+5, update notification handling with new data structure and error state
- chore: remove prompt optimization file and update base repository constructor to include new parameters
- chore: bump version to 1.9.1+6, add device info retrieval before platform initialization and update dependencies
- add test and coverage
- Enhance test coverage by running Flutter tests with coverage options for specific directories. Update CI workflow to reflect these changes.
- Refactor TestNestedSerializableClass to use public fields instead of private variables for nestedObject and nestedList. Update JSON serialization methods accordingly. Improve performance test expectations to complete within 5 milliseconds.
- Release v1.9.1

## v1.9.0+1

- Update version to 1.8.5+1, remove Sentry integration due to rendering issues on Android, and replace it with FirebaseCrashlytics for error handling.
- v1.9.0+1

## vv1.8.5+1

## v1.8.4+7

- v1.8.4+7: using file handler

## v1.8.4+6

- Update version to 1.8.4+6, fix infinite page state, and enhance async handling in InfiniteListState methods

## v1.8.4+5

- v1.8.4+5

## v1.8.4+4

- v1.8.4+4

## v1.8.4+3

- v1.8.4+3

## v1.8.4+2

- Add comprehensive documentation for Supa Architecture framework
- Update version to 1.8.4+2 and correct documentation links in README.md

## v1.8.4+1

- Update version to 1.8.4+1 and add open_file dependency. Enhance temporary directory cleanup in FileService to avoid issues on web platforms.

## v1.8.3

- Enhance notification permission request in PushNotificationBloc to include additional options for better user control

## v1.8.2

- Refactor ApiClient to accept an optional RefreshInterceptor and update RefreshInterceptor methods for clarity
- Update ApiClient to allow custom RefreshInterceptor and ensure proper initialization
- Remove Sentry integration and related dependencies from the project
- configure firebase
- Merge pull request #1 from supavn/remove-sentry-firebase-temporary
- ## 1.8.2

## v1.8.1+rc3

- Update pubspec
- v1.8.1+rc1
- write changelog
- v1.8.1+rc2
- v1.8.1

## v1.8.0

- Add portal authentication tenant filter
- update default confirmation box
- ignore search emptuy
- add createdAt date filter for user notification
- v1.7.5
- add filter render
- bump version to 1.8.0 and update changelog; add background color prop to EnumStatusBadge

## v1.7.4

- 1.7.4

## v1.7.3

- v1.7.3

## v1.7.2

- Update pubspec
- Remove unused methods
- v1.7.2

## v1.7.1

- add microsoft auth
- v1.7.1: Microsoft auth

## v1.7.0

- v1.7.0

## v1.6.3

- feat: v1.6.3 - new carbon icons

## v1.6.2

- Update change log
- Update actions
- Update example SDK
- Update git workflow
- v1.6.2

## v1.6.1

- feat: v1.5.5
- feat: add enums, default labels for confirmation dialog
- Optimize imports
- Update enum model
- v1.6.1: fix the notification token

## v1.5.4

- feat: language changing methods (v1.5.4)

## v1.5.3

- v1.5.3

## v1.5.2

- v1.5.2

## v1.5.1

- v1.5.1: imageUrl for empty state
- Update

## v1.5.0

- Optimize imports
- add subsystem id filter
- v1.4.4
- update factor
- v1.5.0: Added AppUserInfo class
- Update pubspec lock

## v1.4.3

- v1.4.3

## v1.4.2

- v1.4.2

## v1.4.1

- v1.4.1

## v1.4.0


## v1.3.4

- v1.4.0
- v1.4.1
- v1.4.2
- v1.4.3
- Optimize imports
- add subsystem id filter
- v1.4.4
- update factor
- v1.5.0: Added AppUserInfo class
- Update pubspec lock
- v1.5.1: imageUrl for empty state
- Update
- v1.5.2
- v1.5.3
- feat: language changing methods (v1.5.4)
- feat: v1.5.5
- feat: add enums, default labels for confirmation dialog
- Optimize imports
- Update enum model
- v1.6.1: fix the notification token
- Update change log
- Update actions
- Update example SDK
- Update git workflow
- v1.6.2
- feat: v1.6.3 - new carbon icons
- v1.7.0
- add microsoft auth
- v1.7.1: Microsoft auth
- Update pubspec
- Remove unused methods
- v1.7.2
- v1.7.3
- 1.7.4
- Add portal authentication tenant filter
- update default confirmation box
- ignore search emptuy
- add createdAt date filter for user notification
- v1.7.5
- add filter render
- bump version to 1.8.0 and update changelog; add background color prop to EnumStatusBadge
- Update pubspec
- v1.8.1+rc1
- write changelog
- v1.8.1+rc2
- v1.8.1
- Refactor ApiClient to accept an optional RefreshInterceptor and update RefreshInterceptor methods for clarity
- Update ApiClient to allow custom RefreshInterceptor and ensure proper initialization
- Remove Sentry integration and related dependencies from the project
- configure firebase
- Merge pull request #1 from supavn/remove-sentry-firebase-temporary
- ## 1.8.2
- Enhance notification permission request in PushNotificationBloc to include additional options for better user control
- Update version to 1.8.4+1 and add open_file dependency. Enhance temporary directory cleanup in FileService to avoid issues on web platforms.
- Add comprehensive documentation for Supa Architecture framework
- Update version to 1.8.4+2 and correct documentation links in README.md
- v1.8.4+3
- v1.8.4+4
- v1.8.4+5
- Update version to 1.8.4+6, fix infinite page state, and enhance async handling in InfiniteListState methods
- v1.8.4+7: using file handler
- Update version to 1.8.5+1, remove Sentry integration due to rendering issues on Android, and replace it with FirebaseCrashlytics for error handling.
- v1.9.0+1
- feat: v1.9.1+1 - bug fixes
- v1.9.1+2
- chore: bump version to 1.9.1+3 and update changelog for authentication state fix on language change
- chore: bump version to 1.9.1+4, update changelog, and enhance authentication state with equatable mixin
- chore: bump version to 1.9.1+5, update notification handling with new data structure and error state
- chore: remove prompt optimization file and update base repository constructor to include new parameters
- chore: bump version to 1.9.1+6, add device info retrieval before platform initialization and update dependencies
- add test and coverage
- Enhance test coverage by running Flutter tests with coverage options for specific directories. Update CI workflow to reflect these changes.
- Refactor TestNestedSerializableClass to use public fields instead of private variables for nestedObject and nestedList. Update JSON serialization methods accordingly. Improve performance test expectations to complete within 5 milliseconds.
- Release v1.9.1
- Update JSON serialization methods in TestNestedSerializableClass to improve performance and maintainability. Refactor nestedObject and nestedList to use public fields.
- Refactor SupaExtendedColorScheme to use constants for color keys, improving readability and maintainability. Update switch cases to utilize these constants for color token retrieval.
- Deprecate backgroundColor properties in EnumModel and TextStatusBadge, introducing backgroundColorKey for improved theme integration. Update EnumStatusBadge to utilize new keys while maintaining legacy support.
- Update project configuration and dependencies: enhance .gitignore, update iOS deployment target to 13.0, add GoRouter dependency, and refactor main app structure for improved routing and theme management.
- Enhance text styling in EnumBadgesPage by applying dynamic color to the title text based on the provided token, improving visual consistency with the theme.
- v1.10.0-rc.1
- Update pubspec.lock to version 1.10.0-rc.1, reflecting the latest dependency changes.
- v1.10.0-rc.2
- Refactor TextStatusBadge and EnumStatusBadge to improve color property naming for clarity. Update variable names from resolvedBackground, resolvedText, and resolvedBorder to resolvedBackgroundColor, resolvedTextColor, and resolvedBorderColor. Maintain legacy support in EnumStatusBadge while enhancing theme integration.
- v1.10.0-rc.3
- v1.10.0-rc.4
- Merge pull request #2 from supavn/main
- Merge commit '6d1ee42a936141c041422ccc05ae7670a4bca257' of github.com:thanhtunguet/flutter_json_entity
- update pubspec lock
- Update pubspec.lock to reflect the latest dependency changes and ensure compatibility with recent updates.
- Enhance EnumBadgesPage with hex color examples and update TextStatusBadge to support background and border color keys. Refactor color key handling for improved clarity in EnumStatusBadge.
- v1.10.0-rc.6
- add initial message event handler
- Update to version 1.10.0-rc.7: Added DidMountedCheckInitialMessage to PushNotificationBloc and removed deprecation annotations for backgroundColor in TextStatusBadge and EnumModel.
- Update to version 1.10.0-rc.8: Fix device name retrieval for iOS and Android by using utsname and manufacturer name respectively.
- Update to version 1.10.0-rc.9: Added secure encryption for persistent data and implemented fallback mechanisms in HiveCookieManager and HivePersistentStorage for handling encryption failures.
- Update to version 1.10.0-rc.10: Removed Flutter upper bound constraint in preparation for future updates.
- Remove upper bound
- Update to version 1.10.0-rc.11: Fix file uploading on web and enhance multipart file handling for both web and native platforms.
- Update CHANGELOG and improve authentication handling for web: Fix authentication issues and ensure persistence of user and tenant data across platforms.
- Update to version 1.10.0-rc.12: Add globalUserId field to AppUserInfo model and update CHANGELOG.
- Update to version 1.10.0-rc.13: Add account linking functionality for Google, Microsoft, and Apple in PortalProfileRepository and enhance AppUserPreferences model.
- Update to version 1.10.0-rc.13: Add handleInitialNotification method to PushNotificationBloc and enhance AppUserInfo model with additional account fields.
- add sub_app
- v1.10.0-rc.14
- Update dependencies in pubspec.yaml and register new models in models.dart: Set intl to any version, upgrade supa_carbon_icons to 0.2.0, and add Period, PeriodFilter, and RequestHistory models.
- Release version 1.11.0: Add isOverdue getter to DateTime extension, introduce Period and RequestHistory models, and enhance PeriodFilter with siteId field.
- Refactor API client and interceptors: Simplify interceptor management by removing platform-specific checks, enhance token refresh handling, and update encryption manager for Hive. Remove biometric login button widget.
- Release version 1.12.0-rc1: Introduce TimezoneService and update dependencies, including flutter_timezone package. Update CHANGELOG and plugin registrations across platforms.
- add refactoring plan
- Enhance CookieManager implementations: Add detailed documentation for methods, improve null handling for cookies, and implement token-in-URL functionality for mobile platforms. Update WebCookieManager to rely on native cookie handling without token support.
- Enhance CookieManager functionality: Add duplicate cookie handling with logging for warnings, implement one-time migration for data consistency, and improve cookie cleanup methods. Update documentation to reflect these changes across CookieManager implementations.
- update test code
- Update TextStatusBadge to allow nullable backgroundColor and enhance EnumStatusBadge with calculated background and border colors based on hex input. Update pubspec.lock for version 1.12.0-rc1.
- Update version to 1.12.0-rc2, enhance changelog with EnumStatusBadge fix, and add documentation note for code modifications in AGENTS.md.
- Remove deprecated BottomSheetContainer widget and update exports in widgets.dart
- add app_user_group
- add discussion
- Release version 1.13.0: Remove Image model and replace it with File, update changelog, and adjust version in pubspec.yaml.
- v1.13.2
- Update version to 1.13.3, add isAdmin field to AppUser profile, and enhance changelog.
- Remove development.md file from rules directory
- Add logging directory to .gitignore, enhance ApiClient documentation, and improve error handling in DioException and interceptors
- Enhance documentation across BLoC files, including detailed descriptions for authentication, error handling, and push notification functionalities. Update CHANGELOG with comprehensive documentation improvements.
- Enhance documentation for JSON field classes, including detailed descriptions for JsonBoolean, JsonDate, JsonDouble, JsonInteger, JsonList, JsonModel, JsonNumber, JsonObject, JsonSerializable, and JsonString. Update CHANGELOG to reflect comprehensive documentation improvements across all JSON-related files.
- Enhance documentation for SupaExtendedColorScheme and SupaExtendedColorTokenGroup, providing detailed descriptions of color tokens and their usage. Update theme.dart to include an overview of the theme package and its components.
- Enhance documentation across services, including detailed descriptions for FileService, FileHandler, EntityDetailNavigator, and timezone services. Update CHANGELOG to reflect comprehensive documentation improvements and platform-specific behavior explanations.
- Enhance documentation for form classes in `lib/forms/`, including detailed descriptions, usage examples, and validation requirements for LoginForm, ForgotPasswordForm, ResetPasswordForm, and ChangePasswordForm. Update CHANGELOG to reflect these comprehensive improvements.
- Refactor filters: remove unused filter classes including AdminTypeFilter, AppUserFilter, DiscussionFilter, and others. Update filters.dart to include new filter parts and clean up models.dart by removing references to deleted filters. Ensure repository files are updated to import the necessary filters.
- Enhance documentation for DioImageProvider in `lib/providers/dio_image_provider.dart`, detailing its functionality, usage examples, and error handling mechanisms. Update `providers.dart` to include a summary of custom image provider implementations, emphasizing advanced features and fallback handling.
- Enhance documentation for utility classes in `lib/utils/`, including detailed comments for PasswordFieldMixin and PlatformUtils with usage examples and parameter descriptions. Update CHANGELOG to reflect these comprehensive documentation improvements.
- Enhance documentation for various widget classes in `lib/widgets/`, including detailed descriptions, usage examples, and parameter explanations for AppImage, GoBackButton, IconPlaceholder, LoadingIndicator, TextStatusBadge, EnumStatusBadge, ConfirmationDialog, EmptyComponent, ForbiddenComponent, SearchableAppBarTitle, SectionTitle, and InfiniteListState. Update CHANGELOG to reflect these comprehensive documentation improvements.
- refactor filters
- Update firebase
- update example pubspec lock
- Using open_filex package
- v1.3.4

## v1.3.1

- feat: v1.3.1

## v1.3.0

- v1.2.1
- v1.2.2
- feat: new version v1.3.0 with common widgets

## v1.2.0

- Update pubspec
- v1.2.0

## v1.1.3

- feat: v1.1.3 add getter

## v1.1.2

- add name field
- Timezone integer
- v1.1.2

## v1.1.1

- v1.1.0: upgrade bloc
- v1.1.1: add otp required

## v1.0.3

- update authentication
- Fix clear auth
- Keep current json
- ignore empty id
- Fix map build
- add method channel
- request notification permission
- Merge json property
- Remove push noti request on macos
- Optimize code & add widgets
- Update change logs
- fix: web cookie storage
- v1.0.2: optimize code
- Add image
- add image id
- Update avatar URL
- fix: dio image provider missing cookie
- Update to json
- Update json double
- Using device model instead of device name
- v1.0.3: temporary fix

## v1.0.0+1

- v1.0.0: update docs & changelog

## v1.0.0

- v0.0.3+preview.7
- Fix: remove web cookies
- add set link
- add filename
- Remove fine-tuning code
- Fix change password
- Enable old password
- Update portal profile repo
- add extension
- initialize v1.0
- Update sdk deps
- Handle authentication for web
- Fix authentication token
- v1.0.0: Library supports web

## v0.0.3+preview.6

- check is web
- add change log

## v0.0.3+preview.5

- v0.0.3+preview.5

## v0.0.3+preview.4

- v0.0.3+preview.4

## v0.0.3+preview.3

- check debug web
- only email scope
- Print console if is web
- feat: v0.0.3+preview.3 - add upload methods

## v0.0.3+preview.2


## v0.0.3

- google login scope
- Fix authentication bloc
- fix authentication initialization
- Fix initial authentication & change password form
- Tối ưu auth bloc
- update
- add switch email & notification event
- add switch email & notification
- Backend authentication change
- check debug web
- only email scope
- Print console if is web
- feat: v0.0.3+preview.3 - add upload methods
- v0.0.3+preview.4
- v0.0.3+preview.5
- check is web
- add change log
- v0.0.3+preview.7
- Fix: remove web cookies
- add set link
- add filename
- Remove fine-tuning code
- Fix change password
- Enable old password
- Update portal profile repo
- add extension
- feat: confirm v0.0.3

## v0.0.2+preview.14

- add device uuid
- update version

## v0.0.2+preview.13

- add to json method
- add to json method for push notification state
- add toJSON to push notification
- add readme
- change log

## v0.0.2+preview.12

- add operator: equality
- feat: v0.0.2+preview.12

## v0.0.2+preview.11

- Fix: carbon button
- to iso string
- Fix Json date
- id filter int
- refactor dio image provider
- json date for utc
- add fine-tuning
- out of memory :))
- feat: 0.0.2+preview.11 - options to use firebase or not
- Merge branch 'main' of github.com:thanhtunguet/supa_architecture

## v0.0.2+preview.10

- feat: 0.0.2+preview.10

## v0.0.2+preview.9

- feat: v0.0.2+preview.9

## v0.0.2+preview.8

- feat: v0.0.2+preview.8

## v0.0.2+preview.7

- feat: v0.0.2+preview.7

## v0.0.2+preview.6

- feat: 0.0.2+preview.6

## v0.0.2+preview.5

- v0.0.2+preview.5

## v0.0.2+preview.4

- Update test
- Update json integer
- add push notification bloc
- add push notification
- Fix authentication with google
- Fix tests
- add env extensions
- fix authentication
- FIx push notification
- chore: v0.0.2+preview.2
- Push notification
- chore: v0.0.2+preview.4

## v0.0.2+preview.1


## v0.0.2

- v0.0.2+preview.1
- Update test
- Update json integer
- add push notification bloc
- add push notification
- Fix authentication with google
- Fix tests
- add env extensions
- fix authentication
- FIx push notification
- chore: v0.0.2+preview.2
- Push notification
- chore: v0.0.2+preview.4
- v0.0.2+preview.5
- feat: 0.0.2+preview.6
- feat: v0.0.2+preview.7
- feat: v0.0.2+preview.8
- feat: v0.0.2+preview.9
- feat: 0.0.2+preview.10
- Fix: carbon button
- to iso string
- Fix Json date
- id filter int
- refactor dio image provider
- json date for utc
- add fine-tuning
- out of memory :))
- feat: 0.0.2+preview.11 - options to use firebase or not
- Merge branch 'main' of github.com:thanhtunguet/supa_architecture
- add operator: equality
- feat: v0.0.2+preview.12
- add to json method
- add to json method for push notification state
- add toJSON to push notification
- add readme
- change log
- add device uuid
- update version
- google login scope
- Fix authentication bloc
- fix authentication initialization
- Fix initial authentication & change password form
- Tối ưu auth bloc
- update

## v0.0.1+preview.13

- add json double and json integer
- Add user filters and file filters
- v0.0.1+preview.13

## v0.0.1+preview.12

- v0.0.1+preview.12

## v0.0.1+preview.11

- Use getter to get repository
- feat: v0.0.1+preview.10
- Default value for json string
- v0.0.1+preview.11

## v0.0.1+preview.9

- Update persistent
- kDebugMode
- v0.0.1+preview.9

## v0.0.1+preview.8

- Fix tests
- Fix timezone
- Upgrade recaptcha version
- feat: v0.0.1+preview.8

## v0.0.1+preview.7

- Update interceptors
- Merge branch 'main' of github.com:thanhtunguet/supa_architecture
- Update API logs
- using num for id_filter
- update workflow
- chore: 0.0.1+preview.6
- Update version
- Rewrite test
- feat: v0.0.1+preview.7

## v0.0.1+preview.5

- Log 403 URL
- fix: cookies
- added example

## v0.0.1+preview.4

- v0.0.1+preview.4

## v0.0.1+preview.3

- Update license
- add docs for api _client
- add captcha
- add upload image methods
- log user
- map user profile
- fix image
- add forgot password methods
- Update notification
- add approve id method
- Fix google login
- Update cookies
- format code
- add documentation
- Update version
- Update documentation
- fix lỗi build file
- Update deps

## v0.0.1+preview.1


## 0.0.1+preview.2

- initial commit
- add blocs
- add google, apple login
- update dependencies
- config azure login
- add user notification
- add body number
- ignore plugin files
- add datetime formats
- add cookies manager
- Merge branch 'main' of github.com:thanhtunguet/supa_architecture
- refresh token failed then logout user
- Update tenant bloc
- add errors
- refactor blocs
- update blog with biometric login
- Update URL and biometric button
- Fix refresh, json field default value
- Update number & fix tenant
- fix authentication and tenant blocs
- Remove logger
- add sender & recipient to user notification
- Merge branch 'main' of github.com:thanhtunguet/supa_architecture
- add exception, repositories
- Update version
- Update changelog
- Update license
- add docs for api _client
- add captcha
- add upload image methods
- log user
- map user profile
- fix image
- add forgot password methods
- Update notification
- add approve id method
- Fix google login
- Update cookies
- format code
- add documentation
- Update version
