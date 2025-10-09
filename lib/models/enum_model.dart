import "package:supa_architecture/json/json.dart";

/// A class representing an enumerated model.
///
/// This class extends [JsonModel] and provides various fields representing
/// attributes of the enumeration such as ID, code, name, and color.
class EnumModel extends JsonModel {
  /// List of JSON fields representing the enumeration attributes.
  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
        color,
        backgroundColor,
      ];

  /// The ID of the enumeration.
  JsonInteger id = JsonInteger("id");

  /// The code of the enumeration.
  JsonString code = JsonString("code");

  /// The name of the enumeration.
  JsonString name = JsonString("name");

  /// The color associated with the enumeration.
  JsonString color = JsonString("color");

  /// Deprecated: use consolidated color extension with token/background keys.
  /// This field will be removed in a future release.
  // @Deprecated(
  //     'Use consolidated color extension with token/background keys; this field will be removed in a future release.')
  JsonString backgroundColor = JsonString("backgroundColor");
}
