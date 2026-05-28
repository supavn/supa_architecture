import 'package:supa_architecture/json/json.dart';

class AppUserSite extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        name,
        code,
      ];

  JsonInteger id = JsonInteger('id');

  JsonString name = JsonString('name');

  JsonString code = JsonString('code');
}
