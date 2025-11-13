import 'package:supa_architecture/supa_architecture.dart';

class RequestHistory extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        requestId,
        actorId,
        actor,
        actorEmail,
        actorTypeId,
        actorType,
        actionName,
        versionId,
        savedAt,
      ];

  JsonNumber id = JsonNumber('id');
  JsonNumber requestId = JsonNumber('requestId');
  JsonNumber actorId = JsonNumber(
    'actorId',
  );
  JsonDate savedAt = JsonDate('savedAt');
  JsonString actor = JsonString('actor');
  JsonString actorEmail = JsonString('actorEmail');
  JsonNumber actorTypeId = JsonNumber(
    'actorTypeId',
  );
  JsonString actorType = JsonString('actorType');
  JsonString actionName = JsonString('actionName');
  JsonNumber versionId = JsonNumber('versionId');
}
