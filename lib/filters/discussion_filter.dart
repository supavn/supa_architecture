part of "filters.dart";

class DiscussionFilter extends DataFilter {
  @override
  List<FilterField> get fields => [
        id,
        code,
        questionnaireId,
        siteId,
        dateId,
        timeUnitId,
        appUserId,
        latitude,
        longitude,
        tenantId,
        year,
        createdAt,
        updatedAt,
      ];

  final id = IdFilter('id');
  final code = StringFilter('code');
  final questionnaireId = IdFilter('questionnaireId');
  final siteId = IdFilter('siteId');
  final dateId = IdFilter('dateId');
  final timeUnitId = IdFilter('timeUnitId');
  final appUserId = IdFilter('appUserId');
  final latitude = DoubleFilter('latitude');
  final longitude = DoubleFilter('longitude');
  final tenantId = IdFilter('tenantId');
  final year = IntFilter('year');
  final createdAt = DateFilter('createdAt');
  final updatedAt = DateFilter('updatedAt');
}
