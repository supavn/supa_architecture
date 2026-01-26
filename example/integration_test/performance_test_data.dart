Map<String, dynamic> buildLevel5Json(int index, int seed) {
  final createdAt = DateTime(2024, 1, 1).add(Duration(days: index + seed));
  final updatedAt = createdAt.add(Duration(hours: seed));

  return {
    'code': 'L5-$index-$seed',
    'name': 'Leaf $index-$seed',
    'count': index + seed,
    'ratio': ((index % 10) + seed) * 0.1,
    'score': (index % 100) + seed * 0.5,
    'flag': (index + seed) % 2 == 0,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'note': 'Note $index-$seed',
    'tag': 'Tag $seed',
  };
}

Map<String, dynamic> buildLevel4Json(int index, int seed) {
  final createdAt = DateTime(2024, 2, 1).add(Duration(days: index + seed));
  final updatedAt = createdAt.add(Duration(hours: seed + 1));

  return {
    'id': index + seed + 1,
    'title': 'Level4 $index-$seed',
    'isActive': (index + seed) % 2 == 0,
    'score': (index % 100) + seed * 0.25,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'child': buildLevel5Json(index, seed),
    'childAlt': buildLevel5Json(index, seed + 1),
    'childList': [
      buildLevel5Json(index, seed + 2),
      buildLevel5Json(index, seed + 3),
    ],
    'childListAlt': [
      buildLevel5Json(index, seed + 4),
      buildLevel5Json(index, seed + 5),
    ],
  };
}

Map<String, dynamic> buildLevel3Json(int index, int seed) {
  final createdAt = DateTime(2024, 3, 1).add(Duration(days: index + seed));
  final updatedAt = createdAt.add(Duration(hours: seed + 2));

  return {
    'id': index + seed + 1,
    'title': 'Level3 $index-$seed',
    'isActive': (index + seed) % 2 == 0,
    'score': (index % 100) + seed * 0.2,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'child': buildLevel4Json(index, seed),
    'childAlt': buildLevel4Json(index, seed + 1),
    'childList': [
      buildLevel4Json(index, seed + 2),
      buildLevel4Json(index, seed + 3),
    ],
    'childListAlt': [
      buildLevel4Json(index, seed + 4),
      buildLevel4Json(index, seed + 5),
    ],
  };
}

Map<String, dynamic> buildLevel2Json(int index, int seed) {
  final createdAt = DateTime(2024, 4, 1).add(Duration(days: index + seed));
  final updatedAt = createdAt.add(Duration(hours: seed + 3));

  return {
    'id': index + seed + 1,
    'title': 'Level2 $index-$seed',
    'isActive': (index + seed) % 2 == 0,
    'score': (index % 100) + seed * 0.15,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'child': buildLevel3Json(index, seed),
    'childAlt': buildLevel3Json(index, seed + 1),
    'childList': [
      buildLevel3Json(index, seed + 2),
      buildLevel3Json(index, seed + 3),
    ],
    'childListAlt': [
      buildLevel3Json(index, seed + 4),
      buildLevel3Json(index, seed + 5),
    ],
  };
}

Map<String, dynamic> buildLevel1Json(int index) {
  final createdAt = DateTime(2024, 5, 1).add(Duration(days: index));
  final updatedAt = createdAt.add(const Duration(hours: 4));

  return {
    'id': index + 1,
    'name': 'Record $index',
    'isActive': index % 2 == 0,
    'score': (index % 100) + 0.5,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'primary': buildLevel2Json(index, 1),
    'secondary': buildLevel2Json(index, 2),
    'items': [
      buildLevel2Json(index, 3),
      buildLevel2Json(index, 4),
    ],
    'extraItems': [
      buildLevel2Json(index, 5),
      buildLevel2Json(index, 6),
    ],
  };
}
