import 'package:get_it/get_it.dart';
import 'package:supa_architecture/supa_architecture.dart';

export 'base_repository.dart';
export 'portal_authentication_repository.dart';
export 'portal_profile_repository.dart';
export 'portal_tenant_repository.dart';
export 'utils_notification_repository.dart';

void registerRepositories() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<PortalAuthenticationRepository>(
      () => PortalAuthenticationRepository());

  getIt.registerLazySingleton<PortalProfileRepository>(
      () => PortalProfileRepository());

  getIt.registerLazySingleton<PortalTenantRepository>(
      () => PortalTenantRepository());

  getIt.registerLazySingleton<UtilsNotificationRepository>(
      () => UtilsNotificationRepository());
}
