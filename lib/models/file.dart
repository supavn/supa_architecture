import "package:supa_architecture/json/json.dart";

/// A class representing a file model.
///
/// This class extends [JsonModel] and provides various fields representing
/// attributes of the file such as ID, name, path, URL, MIME type, size,
/// creation date, and update date.
class File extends JsonModel {
  /// List of JSON fields representing the file attributes.
  @override
  List<JsonField> get fields => [
        id,
        name,
        path,
        url,
        mimeType,
        size,
        createdAt,
        updatedAt,
        thumbnailFile,
        thumbnailFileId,
        thumbnailUrl,
      ];

  /// The ID of the file.
  JsonInteger id = JsonInteger("id");

  /// The name of the file.
  JsonString name = JsonString("name");

  /// The path of the file.
  JsonString path = JsonString("path");

  /// The URL of the file.
  JsonString url = JsonString("url");

  /// The MIME type of the file.
  JsonString mimeType = JsonString("mimeType");

  /// The size of the file.
  JsonInteger size = JsonInteger("size");

  /// The creation date of the file.
  JsonDate createdAt = JsonDate("createdAt");

  /// The last update date of the file.
  JsonDate updatedAt = JsonDate("updatedAt");

  /// The thumbnail file of the image.
  JsonObject<File> thumbnailFile = JsonObject<File>("thumbnailFileId");

  /// The thumbnail file ID of the image.
  JsonInteger thumbnailFileId = JsonInteger("thumbnailFileId");

  /// The thumbnail URL of the image.
  JsonString thumbnailUrl = JsonString("thumbnailUrl");
}
