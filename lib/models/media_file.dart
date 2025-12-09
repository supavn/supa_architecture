import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/models/file.dart';

class MediaFile extends File {
  @override
  List<JsonField> get fields => [
        ...super.fields,
        thumbnailFile,
        thumbnailFileId,
        thumbnailUrl,
      ];

  JsonObject<File> thumbnailFile = JsonObject<File>("thumbnailFileId");
  JsonInteger thumbnailFileId = JsonInteger("thumbnailFileId");
  JsonString thumbnailUrl = JsonString("thumbnailUrl");
}
