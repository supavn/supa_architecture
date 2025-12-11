part of "filters.dart";

class PeriodFilter extends EnumModelFilter {
  @override
  List<FilterField> get fields => [
        ...super.fields,
        siteId,
      ];

  final siteId = IdFilter('siteId');
}
