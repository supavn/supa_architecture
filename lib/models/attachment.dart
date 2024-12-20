import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/app_user.dart";
import "package:supa_architecture/models/file.dart";
import "package:supa_architecture/models/image.dart";

/// An abstract class representing an attachment model.
///
/// The `Attachment` class defines the structure and fields for an attachment,
/// which can be a file or a link, along with associated metadata such as
/// description, creator information, and timestamps. It extends the `JsonModel`
/// class to facilitate JSON serialization and deserialization.
abstract class Attachment extends JsonModel {
  /// The unique identifier of the attachment.
  JsonInteger id = JsonInteger("id");

  /// A brief description of the attachment.
  JsonString description = JsonString("description");

  /// The name of the attachment.
  JsonString name = JsonString("name");

  /// Indicates whether the attachment is a file.
  ///
  /// - `true`: The attachment is a file.
  /// - `false`: The attachment is not a file (it might be a link).
  JsonBoolean isFile = JsonBoolean("isFile");

  /// The unique identifier of the associated file, if any.
  ///
  /// This field is used when the attachment is linked to a file stored in the system.
  JsonInteger fileId = JsonInteger("fileId");

  /// The URL or link associated with the attachment, if any.
  ///
  /// This field is used when the attachment is a link to external content.
  JsonString link = JsonString("link");

  /// The file path of the attachment, if any.
  ///
  /// This field stores the local or remote path to the file associated with the attachment.
  JsonString path = JsonString("path");

  /// The unique identifier of the user who created the attachment.
  JsonInteger appUserId = JsonInteger("appUserId");

  /// The user who created the attachment.
  ///
  /// This is a nested JSON object representing the `AppUser` who created the attachment.
  JsonObject<AppUser> appUser = JsonObject<AppUser>("appUser");

  /// The file associated with the attachment.
  ///
  /// This is a nested JSON object representing the `File` linked to the attachment.
  JsonObject<File> file = JsonObject<File>("file");

  /// The image associated with the attachment.
  ///
  /// This is a nested JSON object representing the `Image` linked to the attachment.
  JsonObject<Image> image = JsonObject<Image>("image");

  /// The timestamp indicating when the attachment was created.
  JsonDate createdAt = JsonDate("createdAt");

  /// The timestamp indicating the last time the attachment was updated.
  JsonDate updatedAt = JsonDate("updatedAt");

  /// A list of all JSON fields included in the attachment model.
  ///
  /// This getter returns all the fields that should be serialized or deserialized
  /// when converting the attachment to or from JSON format.
  @override
  List<JsonField> get fields => [
        id,
        name,
        isFile,
        fileId,
        path,
        appUserId,
        appUser,
        file,
        link,
        description,
      ];

  void setFile(File file) {
    this.file.value = file;
    fileId.value = file.id.value;
    isFile.value = true;
    link.value = null;
    name.value = file.name.value;
  }

  void setLink(
    String link, {
    String? name,
  }) {
    this.link.value = link;
    if (name != null) {
      this.name.value = name;
    }
    isFile.value = false;
    fileId.value = null;
    file.value = null;
  }
}
