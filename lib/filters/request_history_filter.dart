part of "filters.dart";

class RequestHistoryFilter extends DataFilter {
  final String requestProperty;

  RequestHistoryFilter.withRequestProperty(String rp) : requestProperty = rp {
    orderBy = 'savedAt';
    orderType = 'DESC';
  }

  @override
  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['requestProperty'] = requestProperty;
    return result;
  }

  @override
  List<FilterField> get fields => [
        ///
      ];
}
