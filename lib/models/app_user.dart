import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/app_user_preferences.dart";
import "package:supa_architecture/models/app_user_sub_system_mapping.dart";
import "package:supa_architecture/models/current_tenant.dart";
import "package:supa_architecture/models/tenant.dart";

/// A class representing an application user.
///
/// This class extends [JsonModel] and provides various fields representing
/// user attributes such as ID, email, username, and more. It also provides
/// a static instance of an empty [AppUser].
class AppUser extends JsonModel with AppUserPreferences {
  /// A static instance of an empty [AppUser].
  static final AppUser empty = AppUser();

  /// List of JSON fields representing the user attributes.
  @override
  List<JsonField> get fields => [
        id,
        globalUserId,
        email,
        username,
        displayName,
        phone,
        address,
        dateOfBirth,
        avatar,
        isAlreadyGettingStarted,
        identityCode,
        tenants,
        name,
        appUserSubSystemMappings,
        currentTenant,
        ...preferenceFields,
      ];

  /// The user ID.
  JsonInteger id = JsonInteger("id");

  /// The global user ID.
  JsonInteger globalUserId = JsonInteger("globalUserId");

  /// The user's email address.
  JsonString email = JsonString("email");

  /// The user's username.
  JsonString username = JsonString("username");

  /// The user's name.
  JsonString name = JsonString("name");

  /// The user's display name.
  JsonString displayName = JsonString("displayName");

  /// The user's phone number.
  JsonString phone = JsonString("phone");

  /// The user's address.
  JsonString address = JsonString("address");

  /// The user's date of birth.
  JsonDate dateOfBirth = JsonDate("dateOfBirth");

  /// The user's identity code.
  JsonString identityCode = JsonString("identityCode");

  /// The user's avatar URL.
  JsonString avatar = JsonString("avatar");

  /// Indicates if the user has already gotten started.
  JsonBoolean isAlreadyGettingStarted = JsonBoolean("isAlreadyGettingStarted");

  /// List of tenants the user belongs to.
  JsonList<Tenant> tenants = JsonList<Tenant>("tenants");

  /// The current tenant that this user is using.
  JsonObject<CurrentTenant> currentTenant =
      JsonObject<CurrentTenant>("currentTenant");

  /// List of mappings between the user and subsystems.
  JsonList<AppUserSubSystemMapping> appUserSubSystemMappings =
      JsonList<AppUserSubSystemMapping>("appUserSubSystemMappings");

  @override
  void fromJson(json) {
    super.fromJson(json);
    if (json is Map<String, dynamic>) {
      if (json.containsKey("displayName") &&
          json["displayName"] is String &&
          json["displayName"].isNotEmpty &&
          name.value.isEmpty) {
        name.value = json["displayName"];
      }
    }
  }
}
