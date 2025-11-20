import 'package:supa_architecture/json/json.dart';

class AppUserGroup extends JsonModel {
  @override
  List<JsonField> get fields => [
        requestProperty,
        id,
        name,
        createdAt,
        updatedAt,
        rowId,
        statusId,
        parentId,
        level,
        path,
        hasChildren,
        isDefault,
        referenceOrganizationId,
        tenantId,
      ];

  JsonString requestProperty = JsonString('requestProperty');

  JsonInteger id = JsonInteger('id');
  JsonString name = JsonString('name');
  JsonDate createdAt = JsonDate('createdAt');
  JsonDate updatedAt = JsonDate('updatedAt');
  JsonInteger rowId = JsonInteger('rowId');
  JsonInteger statusId = JsonInteger('statusId');
  JsonInteger parentId = JsonInteger('parentId');
  JsonInteger level = JsonInteger('level');
  JsonString path = JsonString('path');
  JsonBoolean hasChildren = JsonBoolean('hasChildren');
  JsonBoolean isDefault = JsonBoolean('isDefault');
  JsonInteger referenceOrganizationId = JsonInteger('referenceOrganizationId');
  JsonInteger tenantId = JsonInteger('tenantId');
}
