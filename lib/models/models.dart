import 'package:get_it/get_it.dart';
import 'package:supa_architecture/models/sub_system.dart';
import 'package:supa_architecture/models/tenant_sub_system_mapping.dart';
import 'package:supa_architecture/supa_architecture.dart';

export 'admin_type.dart';
export 'admin_type_filter.dart';
export 'app_user.dart';
export 'app_user_filter.dart';
export 'app_user_info.dart';
export 'app_user_sub_system_mapping.dart';
export 'attachment.dart';
export 'current_tenant.dart';
export 'date_type.dart';
export 'enum_model.dart';
export 'enum_model_filter.dart';
export 'file.dart';
export 'file_filter.dart';
export 'forgot_password_dto.dart';
export 'gender.dart';
export 'gender_filter.dart';
export 'global_user.dart';
export 'image.dart';
export 'image_filter.dart';
export 'language.dart';
export 'language_filter.dart';
export 'tenant.dart';
export 'tenant_filter.dart';
export 'timezone.dart';
export 'timezone_filter.dart';
export 'user_notification.dart';
export 'user_notification_filter.dart';

void registerModels() {
  final getIt = GetIt.instance;

  getIt.registerFactory<AdminType>(AdminType.new);
  getIt.registerFactory<AppUser>(AppUser.new);
  getIt.registerFactory<AppUserInfo>(AppUserInfo.new);
  getIt.registerFactory<AppUserSubSystemMapping>(AppUserSubSystemMapping.new);
  getIt.registerFactory<CurrentTenant>(CurrentTenant.new);
  getIt.registerFactory<DateType>(DateType.new);
  getIt.registerFactory<EnumModel>(EnumModel.new);
  getIt.registerFactory<File>(File.new);
  getIt.registerFactory<ForgotPasswordDto>(ForgotPasswordDto.new);
  getIt.registerFactory<Gender>(Gender.new);
  getIt.registerFactory<GlobalUser>(GlobalUser.new);
  getIt.registerFactory<Image>(Image.new);
  getIt.registerFactory<Language>(Language.new);
  getIt.registerFactory<SubSystem>(SubSystem.new);
  getIt.registerFactory<Tenant>(Tenant.new);
  getIt.registerFactory<TenantSubSystemMapping>(TenantSubSystemMapping.new);
  getIt.registerFactory<Timezone>(Timezone.new);
  getIt.registerFactory<UserNotification>(UserNotification.new);
}
