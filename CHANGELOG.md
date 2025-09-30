# Changelog

## 1.10.0-rc.6

### Fixed

- EnumStatusBadge color

## 1.9.1+6

### Added

- Get DeviceInfo before initializing platform

## 1.9.1+5

### Updated

- update notification handling with new data structure and error state

## 1.9.1+4

- Update authentication with equatable mixin

## 1.9.1+3

### Fixed

- Change authentication state when language changes

## 1.9.1+1

### Fixed

- Fix: Remove Sentry integration due to rendering issues on some Android devices, switch to using only FirebaseCrashlytics for error reporting
- Fix: Update error handling bloc to log errors exclusively to FirebaseCrashlytics
- Fix: Push notification BLoC improvements and documentation updates


## 1.9.0+1

### Added

- LanguageInterceptor for all repositories

## 1.8.5+1

### Fixed

- Remove Sentry because of causing the rendering issue on some Android devices
- Replace by FirebaseCrashlytics.recordError

## 1.8.4+6

- Fix infinite page state

## 1.8.4+5

- Use infinite_scroll_pagination v4, v5 has not been compatible yet

## 1.8.4+4

### Changed

- go_router to v15
- infinite_pagination_scroll to v5

## 1.8.4+3

### Added

- Add file handling service with platform-specific implementations for downloading and opening files
- Add FileService utility class for file type detection and URL launching
- Add support for various file types including office documents, images, videos, and PDFs

### Changed

- Update version to 1.8.4+3

### Technical

- Implement FileHandler service with conditional imports for web and IO platforms
- Add comprehensive file type detection methods in FileService
- Integrate open_file dependency for cross-platform file handling


## 1.8.4+2

- Update README
- Use DeepWiki: https://deepwiki.com/supavn/supa_architecture

## 1.8.3

- Enhance notification permission request in PushNotificationBloc to include additional options for better user control

## 1.8.2

- Add `useSentry` and `useFirebase` options

## 1.8.1

- Optimize authentication
- Fix filter json serializable
- Add date type
- Add global user class

## 1.8.1+rc1

- Optimize authentication

## 1.8.0

### Fixed

- EnumStatusBadge with new background color prop

## 1.7.4

### Added

- Add AppBar for Microsoft Login

## 1.7.3

### Added

- Color prop for LoadingIndicator

## 1.7.2

### Added

- Otp validation optional

## 1.7.1

### Added

- Microsoft Auth

## 1.7.0

### Updated

- Refactor code structure

### Added

- Dio exception getter check

## 1.6.3

### Updated

- New carbon icons

## 1.6.2

### Fixed

- Optimize theme of context call

## 1.6.1

### Fixed

- Mobile notification via Firebase

## 1.6.0

### Added

- Enum: Language, AdminType, Timezone, Gender
- Default labels for ConfirmationDialog

## 1.5.5

### Added

- Default translations for confirmation box

## v1.5.4

### Added

- Profile repository methods to change language

## v1.5.3

### Fixed
- Switch receive email and receive notification lost the subsystem list in profile info
- Centering the empty state component

## v1.5.2

### Fixed
- Empty state default image
- Notification duplication


## v1.5.1

### Added

- imageUrl for empty state

## v1.5.0

### Added

- AppUserInfo class

## v1.4.4

### Fixed

- GoBackButton

## v1.4.3

### Added

- Entities

## v1.4.2

### Added

- EntityDetailNavigator

## v1.4.1

### Added 

- Entity generation documentation

## v1.4.0

### Added

- NotificationHandler
- createdAt property for UserNotification model

## v1.3.1

### Added

- `showPadding` for section title

## v1.3.0

### Added 

- Common widgets, shared across projects

## v1.2.0

- Add optimization
- Add tenant subsystem mappings

### Fixed

- Timezone: Ignore "+" sign in timezone header

### Added

- TextStatusBadge widget
- EnumStatusBadge widget
- DateTime extensions

## 1.0.0

### Breaking changes

- PersistentStorage
- CookieManager
- SecureStorage
- SupaArchitecturePlatform

## 0.0.3+preview.8

### Added

- `Attachment`: add `setFile` and `setLink` methods

## 0.0.3+preview.7

### Added

- `ApiClient`: add `filename` parameter to `uploadFiles` method

## 0.0.3+preview.6

### Added

- `ApiClient`: add `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods
- Check is web for where using cookie manager

## 0.0.3+preview.5

### Fixed

- `ApiClient`: fixed `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods for web

## 0.0.3+preview.4

### Added

- `ApiClient`: add `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods

## 0.0.3+preview.3

### Added

- `ApiClient`: add `uploadFileFromImagePicker` and `uploadFileFromFilePicker` methods

## 0.0.3+preview.2

### Added

- `AuthenticationRepository`: add `getProfileInfo` method

### Deprecated

- `AuthenticationRepository`: `getProfile` method

## 0.0.3+preview.1

### Added

- `AuthenticationBloc`: add switch email and notification

## 0.0.2:

### Added

- `AuthenticationBloc`: add Microsoft login scope
- Optimize authentication flow

## 0.0.2+preview.15

### Added

- `AuthenticationBloc`: add Google login scope

## 0.0.2+preview.14

### Added

- `DeviceInfoInterceptor`: add device UUID to request headers

## 0.0.2+preview.13

### Added

- Compatibility table in README
- toJson for PushNotificationState and PushNotificationPayload

## 0.0.2+preview.12

### Added

- `JsonField`: equality operator

## 0.0.2+preview.11

### Added

- Add options to use Firebase or not

## 0.0.2+preview.7

### Added

- `LoginForm`: a form for user login
- `CarbonButtons`: a widget for handling buttons with safe area inset
### Fixed

- `PushNotificationBloc`: a bloc for handling push notifications
- Remove `showLocalNotifications` from `PushNotificationBloc`

## 0.0.2+preview.6

### Added

- `UserNotificationFilter`: unread field

## 0.0.2+preview.5

### Fixed

- `read` -> `unread`

## 0.0.2+preview.4

### Added

- Handle PushNotificationPayload

## 0.0.2+preview.3

### Added

- showLocalNotification: show local notification when receive a push notification

## 0.0.2+preview.2

### Added

- BLoC: PushNotification
- BLoC: ErrorHandling

## 0.0.1+preview.12

### Added

- Model: Attachment

## 0.0.1+preview.5

### Added

- Package example

### Fixed

- Reformat the code

## 0.0.1+preview.4

### Fixed

- Google disconnect

## 0.0.1+preview.3

### Added

- Finish documentation
- Fix: response body file

## 0.0.1+preview.2

### Added

- Documentation for files

## 0.0.1+preview.1

### Added

- All functions
- Documentation preview