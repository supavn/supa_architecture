import 'package:injectable/injectable.dart';
import 'package:supa_architecture/supa_architecture.dart';

@injectable
class RequisitionEntity extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
        subSystemId,
      ];

  JsonInteger id = JsonInteger('id');
  JsonInteger subSystemId = JsonInteger('subSystemId');
  JsonString code = JsonString('code');
  JsonString name = JsonString('name');
}
