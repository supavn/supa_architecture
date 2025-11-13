import 'package:supa_architecture/filters/filters.dart';
import 'package:supa_architecture/models/enum_model_filter.dart';

class PeriodFilter extends EnumModelFilter {
  @override
  List<FilterField> get fields => [
        ...super.fields,
        siteId,
      ];

  final siteId = IdFilter('siteId');
}
