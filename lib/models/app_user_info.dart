import 'package:supa_architecture/models/app_user_preferences.dart';
import 'package:supa_architecture/supa_architecture.dart';

class AppUserInfo extends JsonModel with AppUserPreferences {
  @override
  List<JsonField> get fields => [
        appUserAccountId,
        avatarId,
        avatarUrl,
        username,
        displayName,
        email,
        defaultTenantId,
        isAlreadyGettingStarted,
        currentTenantId,
        appUserId,
        birthday,
        phone,
        address,
        defaultUrl,
        tenants,
        currentTenant,
        ...preferenceFields,
        globalUserId,
      ];

  JsonInteger appUserAccountId = JsonInteger("appUserAccountId");

  JsonInteger avatarId = JsonInteger("avatarId");

  JsonString avatarUrl = JsonString("avatarUrl");

  JsonString username = JsonString("username");

  JsonString displayName = JsonString("displayName");

  JsonString email = JsonString("email");

  JsonInteger defaultTenantId = JsonInteger("defaultTenantId");

  JsonBoolean isAlreadyGettingStarted = JsonBoolean("isAlreadyGettingStarted");

  JsonInteger currentTenantId = JsonInteger("currentTenantId");

  JsonInteger appUserId = JsonInteger("appUserId");

  JsonDate birthday = JsonDate("birthday");

  JsonString phone = JsonString("phone");

  JsonString address = JsonString("address");

  JsonString defaultUrl = JsonString("defaultUrl");

  JsonList<Tenant> tenants = JsonList<Tenant>("tenants");

  JsonObject<CurrentTenant> currentTenant =
      JsonObject<CurrentTenant>("currentTenant");

  /// The global user ID.
  JsonInteger globalUserId = JsonInteger("globalUserId");

  AppUser toAppUser() {
    return AppUser()
      ..id.value = appUserId.value
      ..username.value = username.value
      ..email.value = email.value
      ..phone.value = phone.value
      ..displayName.value = displayName.value
      ..name.value = displayName.value
      ..dateOfBirth.value = birthday.value
      ..avatar.value = avatarUrl.value
      ..address.value = address.value
      ..currentTenant.value = currentTenant.value
      ..tenants.value = tenants.value
      ..isAlreadyGettingStarted.value = isAlreadyGettingStarted.value
      ..receivingSystemEmail.value = receivingSystemEmail.value
      ..receivingSystemNotification.value = receivingSystemNotification.value
      ..gender.value = gender.value
      ..genderId.value = genderId.value
      ..language.value = language.value
      ..languageId.value = languageId.value
      ..timezone.value = timezone.value
      ..timezoneId.value = timezoneId.value
      ..adminType.value = adminType.value
      ..adminTypeId.value = adminTypeId.value
      ..appUserSubSystemMappings.value =
          currentTenant.value.appUser.value.appUserSubSystemMappings.value
      ..globalUserId.value = globalUserId.value;
  }
}
