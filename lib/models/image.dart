import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/file.dart";

/// A class representing an image model.
///
/// This class extends [File] and inherits all its properties and methods,
/// representing an image file within the application.
@Deprecated("Replace by Media class")
class Image extends File {
  /// The thumbnail file of the image.
  JsonObject<File> thumbnailFile = JsonObject<File>("thumbnailFileId");

  /// The thumbnail file ID of the image.
  JsonInteger thumbnailFileId = JsonInteger("thumbnailFileId");

  /// The thumbnail URL of the image.
  JsonString thumbnailUrl = JsonString("thumbnailUrl");

  @override
  List<JsonField> get fields => [
        ...super.fields,
        thumbnailFile,
        thumbnailFileId,
        thumbnailUrl,
      ];
}
