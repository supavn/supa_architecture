import 'package:supa_architecture/json/json.dart';

class PerfLevel5Model extends JsonModel {
  final JsonString code = JsonString('code');
  final JsonString name = JsonString('name');
  final JsonInteger count = JsonInteger('count');
  final JsonDouble ratio = JsonDouble('ratio');
  final JsonNumber score = JsonNumber('score');
  final JsonBoolean flag = JsonBoolean('flag');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');
  final JsonString note = JsonString('note');
  final JsonString tag = JsonString('tag');

  @override
  List<JsonField> get fields => [
        code,
        name,
        count,
        ratio,
        score,
        flag,
        createdAt,
        updatedAt,
        note,
        tag,
      ];
}

class PerfLevel4Model extends JsonModel {
  final JsonInteger id = JsonInteger('id');
  final JsonString title = JsonString('title');
  final JsonBoolean isActive = JsonBoolean('isActive');
  final JsonNumber score = JsonNumber('score');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');
  final JsonObject<PerfLevel5Model> child =
      JsonObject<PerfLevel5Model>('child');
  final JsonObject<PerfLevel5Model> childAlt =
      JsonObject<PerfLevel5Model>('childAlt');
  final JsonList<PerfLevel5Model> childList =
      JsonList<PerfLevel5Model>('childList');
  final JsonList<PerfLevel5Model> childListAlt =
      JsonList<PerfLevel5Model>('childListAlt');

  @override
  List<JsonField> get fields => [
        id,
        title,
        isActive,
        score,
        createdAt,
        updatedAt,
        child,
        childAlt,
        childList,
        childListAlt,
      ];
}

class PerfLevel3Model extends JsonModel {
  final JsonInteger id = JsonInteger('id');
  final JsonString title = JsonString('title');
  final JsonBoolean isActive = JsonBoolean('isActive');
  final JsonNumber score = JsonNumber('score');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');
  final JsonObject<PerfLevel4Model> child =
      JsonObject<PerfLevel4Model>('child');
  final JsonObject<PerfLevel4Model> childAlt =
      JsonObject<PerfLevel4Model>('childAlt');
  final JsonList<PerfLevel4Model> childList =
      JsonList<PerfLevel4Model>('childList');
  final JsonList<PerfLevel4Model> childListAlt =
      JsonList<PerfLevel4Model>('childListAlt');

  @override
  List<JsonField> get fields => [
        id,
        title,
        isActive,
        score,
        createdAt,
        updatedAt,
        child,
        childAlt,
        childList,
        childListAlt,
      ];
}

class PerfLevel2Model extends JsonModel {
  final JsonInteger id = JsonInteger('id');
  final JsonString title = JsonString('title');
  final JsonBoolean isActive = JsonBoolean('isActive');
  final JsonNumber score = JsonNumber('score');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');
  final JsonObject<PerfLevel3Model> child =
      JsonObject<PerfLevel3Model>('child');
  final JsonObject<PerfLevel3Model> childAlt =
      JsonObject<PerfLevel3Model>('childAlt');
  final JsonList<PerfLevel3Model> childList =
      JsonList<PerfLevel3Model>('childList');
  final JsonList<PerfLevel3Model> childListAlt =
      JsonList<PerfLevel3Model>('childListAlt');

  @override
  List<JsonField> get fields => [
        id,
        title,
        isActive,
        score,
        createdAt,
        updatedAt,
        child,
        childAlt,
        childList,
        childListAlt,
      ];
}

class PerfLevel1Model extends JsonModel {
  final JsonInteger id = JsonInteger('id');
  final JsonString name = JsonString('name');
  final JsonBoolean isActive = JsonBoolean('isActive');
  final JsonNumber score = JsonNumber('score');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');
  final JsonObject<PerfLevel2Model> primary =
      JsonObject<PerfLevel2Model>('primary');
  final JsonObject<PerfLevel2Model> secondary =
      JsonObject<PerfLevel2Model>('secondary');
  final JsonList<PerfLevel2Model> items = JsonList<PerfLevel2Model>('items');
  final JsonList<PerfLevel2Model> extraItems =
      JsonList<PerfLevel2Model>('extraItems');

  @override
  List<JsonField> get fields => [
        id,
        name,
        isActive,
        score,
        createdAt,
        updatedAt,
        primary,
        secondary,
        items,
        extraItems,
      ];
}

class PerfLevel5Dto {
  PerfLevel5Dto({
    required this.code,
    required this.name,
    required this.count,
    required this.ratio,
    required this.score,
    required this.flag,
    required this.createdAt,
    required this.updatedAt,
    required this.note,
    required this.tag,
  });

  final String code;
  final String name;
  final int count;
  final double ratio;
  final num score;
  final bool flag;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String note;
  final String tag;

  factory PerfLevel5Dto.fromJson(Map<String, dynamic> json) {
    return PerfLevel5Dto(
      code: json['code'] as String,
      name: json['name'] as String,
      count: json['count'] as int,
      ratio: (json['ratio'] as num).toDouble(),
      score: json['score'] as num,
      flag: json['flag'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      note: json['note'] as String,
      tag: json['tag'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'count': count,
      'ratio': ratio,
      'score': score,
      'flag': flag,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'note': note,
      'tag': tag,
    };
  }
}

class PerfLevel4Dto {
  PerfLevel4Dto({
    required this.id,
    required this.title,
    required this.isActive,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
    required this.childAlt,
    required this.childList,
    required this.childListAlt,
  });

  final int id;
  final String title;
  final bool isActive;
  final num score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PerfLevel5Dto child;
  final PerfLevel5Dto childAlt;
  final List<PerfLevel5Dto> childList;
  final List<PerfLevel5Dto> childListAlt;

  factory PerfLevel4Dto.fromJson(Map<String, dynamic> json) {
    return PerfLevel4Dto(
      id: json['id'] as int,
      title: json['title'] as String,
      isActive: json['isActive'] as bool,
      score: json['score'] as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      child: PerfLevel5Dto.fromJson(json['child'] as Map<String, dynamic>),
      childAlt:
          PerfLevel5Dto.fromJson(json['childAlt'] as Map<String, dynamic>),
      childList: (json['childList'] as List<dynamic>)
          .map((item) => PerfLevel5Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
      childListAlt: (json['childListAlt'] as List<dynamic>)
          .map((item) => PerfLevel5Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isActive': isActive,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'child': child.toJson(),
      'childAlt': childAlt.toJson(),
      'childList': childList.map((item) => item.toJson()).toList(),
      'childListAlt': childListAlt.map((item) => item.toJson()).toList(),
    };
  }
}

class PerfLevel3Dto {
  PerfLevel3Dto({
    required this.id,
    required this.title,
    required this.isActive,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
    required this.childAlt,
    required this.childList,
    required this.childListAlt,
  });

  final int id;
  final String title;
  final bool isActive;
  final num score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PerfLevel4Dto child;
  final PerfLevel4Dto childAlt;
  final List<PerfLevel4Dto> childList;
  final List<PerfLevel4Dto> childListAlt;

  factory PerfLevel3Dto.fromJson(Map<String, dynamic> json) {
    return PerfLevel3Dto(
      id: json['id'] as int,
      title: json['title'] as String,
      isActive: json['isActive'] as bool,
      score: json['score'] as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      child: PerfLevel4Dto.fromJson(json['child'] as Map<String, dynamic>),
      childAlt:
          PerfLevel4Dto.fromJson(json['childAlt'] as Map<String, dynamic>),
      childList: (json['childList'] as List<dynamic>)
          .map((item) => PerfLevel4Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
      childListAlt: (json['childListAlt'] as List<dynamic>)
          .map((item) => PerfLevel4Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isActive': isActive,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'child': child.toJson(),
      'childAlt': childAlt.toJson(),
      'childList': childList.map((item) => item.toJson()).toList(),
      'childListAlt': childListAlt.map((item) => item.toJson()).toList(),
    };
  }
}

class PerfLevel2Dto {
  PerfLevel2Dto({
    required this.id,
    required this.title,
    required this.isActive,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
    required this.childAlt,
    required this.childList,
    required this.childListAlt,
  });

  final int id;
  final String title;
  final bool isActive;
  final num score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PerfLevel3Dto child;
  final PerfLevel3Dto childAlt;
  final List<PerfLevel3Dto> childList;
  final List<PerfLevel3Dto> childListAlt;

  factory PerfLevel2Dto.fromJson(Map<String, dynamic> json) {
    return PerfLevel2Dto(
      id: json['id'] as int,
      title: json['title'] as String,
      isActive: json['isActive'] as bool,
      score: json['score'] as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      child: PerfLevel3Dto.fromJson(json['child'] as Map<String, dynamic>),
      childAlt:
          PerfLevel3Dto.fromJson(json['childAlt'] as Map<String, dynamic>),
      childList: (json['childList'] as List<dynamic>)
          .map((item) => PerfLevel3Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
      childListAlt: (json['childListAlt'] as List<dynamic>)
          .map((item) => PerfLevel3Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isActive': isActive,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'child': child.toJson(),
      'childAlt': childAlt.toJson(),
      'childList': childList.map((item) => item.toJson()).toList(),
      'childListAlt': childListAlt.map((item) => item.toJson()).toList(),
    };
  }
}

class PerfLevel1Dto {
  PerfLevel1Dto({
    required this.id,
    required this.name,
    required this.isActive,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.primary,
    required this.secondary,
    required this.items,
    required this.extraItems,
  });

  final int id;
  final String name;
  final bool isActive;
  final num score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PerfLevel2Dto primary;
  final PerfLevel2Dto secondary;
  final List<PerfLevel2Dto> items;
  final List<PerfLevel2Dto> extraItems;

  factory PerfLevel1Dto.fromJson(Map<String, dynamic> json) {
    return PerfLevel1Dto(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      score: json['score'] as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      primary: PerfLevel2Dto.fromJson(json['primary'] as Map<String, dynamic>),
      secondary:
          PerfLevel2Dto.fromJson(json['secondary'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => PerfLevel2Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
      extraItems: (json['extraItems'] as List<dynamic>)
          .map((item) => PerfLevel2Dto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'primary': primary.toJson(),
      'secondary': secondary.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'extraItems': extraItems.map((item) => item.toJson()).toList(),
    };
  }
}
