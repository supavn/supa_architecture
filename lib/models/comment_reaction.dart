import 'package:injectable/injectable.dart';
import 'package:supa_architecture/supa_architecture.dart';

@injectable
class CommentReaction extends JsonModel {
  @override
  List<JsonField> get fields => [
        commentId,
        globalUserId,
        emoji,
        emojiId,
        globalUser,
      ];

  JsonObject<EnumModel> emoji = JsonObject<EnumModel>('emoji');
  JsonInteger emojiId = JsonInteger('emojiId');
  JsonInteger commentId = JsonInteger('commentId');
  JsonInteger globalUserId = JsonInteger('globalUserId');
  JsonObject<AppUser> globalUser = JsonObject<AppUser>('globalUser');
}
