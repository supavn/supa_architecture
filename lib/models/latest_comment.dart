import 'package:injectable/injectable.dart';
import 'package:supa_architecture/supa_architecture.dart';

@injectable
class LastestComment extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        content,
        mobileContent,
        creatorId,
        createdAt,
        updatedAt,
        deletedAt,
        requestProperty,
        parentId,
        creator,
        orderBy,
        orderType,
        files,
        skip,
        take,
        userReacteds,
      ];

  JsonInteger id = JsonInteger('id');
  JsonString content = JsonString('content');
  JsonString mobileContent = JsonString('mobileContent');
  JsonInteger creatorId = JsonInteger('creatorId');
  JsonDate createdAt = JsonDate('createdAt');
  JsonDate updatedAt = JsonDate('updatedAt');
  JsonDate deletedAt = JsonDate('deletedAt');
  JsonBoolean isOwner = JsonBoolean('isOwner');
  JsonBoolean isPopup = JsonBoolean('isPopup');
  JsonString requestProperty = JsonString('requestProperty');
  JsonInteger parentId = JsonInteger('parentId');
  JsonObject<AppUser> creator = JsonObject<AppUser>('creator');
  JsonString orderBy = JsonString('orderBy');
  JsonString orderType = JsonString('orderType');
  JsonList<CommentReaction> userReacteds =
      JsonList<CommentReaction>('userReacteds');

  // Thêm skip, take để hỗ trợ phân trang
  JsonInteger skip = JsonInteger('skip');
  JsonInteger take = JsonInteger('take');
  JsonList<File> files = JsonList<File>('files');
}
