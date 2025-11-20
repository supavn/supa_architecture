import 'package:supa_architecture/supa_architecture.dart';

class AppUserGroupFilter extends DataFilter {
  @override
  List<FilterField> get fields => [
        id,
        code,
        name,
        description,
        createdAt,
        updatedAt,
        statusId,
        tenantId,
        year,
      ];

  final id = IdFilter('id');
  final code = StringFilter('code');
  final name = StringFilter('name');
  final description = StringFilter('description');
  final createdAt = DateFilter('createdAt');
  final updatedAt = DateFilter('updatedAt');
  final statusId = IdFilter('statusId');
  final tenantId = IdFilter('tenantId');
  final year = IntFilter('year');
  final status = EnumModel();
}
