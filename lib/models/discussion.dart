import 'package:injectable/injectable.dart';
import 'package:supa_architecture/supa_architecture.dart';

@injectable
class Discussion extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        discussionId,
        content,
        mobileContent,
        creatorId,
        createdAt,
        updatedAt,
        deletedAt,
        isOwner,
        isPopup,
        requestProperty,
        parentId,
        creator,
        childrens,
        orderBy,
        orderType,
        lastestComment,
        requisitionEntity,
        numberOfUnreadComments,
        lastestCommentId,
        requestName,
        requestId,
        files,
        skip,
        take,
        unread,
        userReacteds,
      ];

  JsonInteger id = JsonInteger('id');
  JsonBoolean unread = JsonBoolean('unread');
  JsonInteger requestId = JsonInteger('requestId');
  JsonInteger lastestCommentId = JsonInteger('latestCommentId');
  JsonInteger numberOfUnreadComments = JsonInteger('numberOfUnreadComments');
  JsonString requestName = JsonString('requestName');
  JsonInteger discussionId = JsonInteger('discussionId');
  JsonObject<RequisitionEntity> requisitionEntity =
      JsonObject<RequisitionEntity>('requisitionEntity');
  JsonObject<LastestComment> lastestComment =
      JsonObject<LastestComment>('lastestComment');
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
  JsonList<Discussion> childrens = JsonList<Discussion>('childrens');
  JsonList<File> files = JsonList<File>('files');
  JsonString orderBy = JsonString('orderBy');
  JsonString orderType = JsonString('orderType');
  JsonList<CommentReaction> userReacteds =
      JsonList<CommentReaction>('userReacteds');

  // Thêm skip, take để hỗ trợ phân trang
  JsonInteger skip = JsonInteger('skip');
  JsonInteger take = JsonInteger('take');
}
