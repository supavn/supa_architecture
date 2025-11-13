import 'package:supa_architecture/json/json.dart';

class Period extends JsonModel {
  @override
  List<JsonField> get fields => [
        requestProperty,
        id,
        periodTypeId,
        code,
        name,
        vi,
        en,
        zh,
        ja,
        yearId,
        halfYearId,
        quarterId,
        monthId,
        weekId,
        dayId,
        year,
        halfOfYear,
        quarterOfYear,
        quarterOfHalf,
        monthOfYear,
        monthOfHalf,
        monthOfQuarter,
        weekOfYear,
        weekOfHalf,
        weekOfQuarter,
        weekOfMonth,
        dayOfYear,
        dayOfHalf,
        dayOfQuarter,
        dayOfMonth,
        dayOfWeek,
        startId,
        endId,
        date,
        weekDay,
      ];

  JsonString requestProperty = JsonString('requestProperty');

  JsonInteger id = JsonInteger('id');
  JsonInteger periodTypeId = JsonInteger('periodTypeId');
  JsonString code = JsonString('code');
  JsonString name = JsonString('name');
  JsonString vi = JsonString('vi');
  JsonString en = JsonString('en');
  JsonString zh = JsonString('zh');
  JsonString ja = JsonString('ja');
  JsonInteger yearId = JsonInteger('yearId');
  JsonInteger halfYearId = JsonInteger('halfYearId');
  JsonInteger quarterId = JsonInteger('quarterId');
  JsonInteger monthId = JsonInteger('monthId');
  JsonInteger weekId = JsonInteger('weekId');
  JsonInteger dayId = JsonInteger('dayId');
  JsonInteger year = JsonInteger('year');
  JsonInteger halfOfYear = JsonInteger('halfOfYear');
  JsonInteger quarterOfYear = JsonInteger('quarterOfYear');
  JsonInteger quarterOfHalf = JsonInteger('quarterOfHalf');
  JsonInteger monthOfYear = JsonInteger('monthOfYear');
  JsonInteger monthOfHalf = JsonInteger('monthOfHalf');
  JsonInteger monthOfQuarter = JsonInteger('monthOfQuarter');
  JsonInteger weekOfYear = JsonInteger('weekOfYear');
  JsonInteger weekOfHalf = JsonInteger('weekOfHalf');
  JsonInteger weekOfQuarter = JsonInteger('weekOfQuarter');
  JsonInteger weekOfMonth = JsonInteger('weekOfMonth');
  JsonInteger dayOfYear = JsonInteger('dayOfYear');
  JsonInteger dayOfHalf = JsonInteger('dayOfHalf');
  JsonInteger dayOfQuarter = JsonInteger('dayOfQuarter');
  JsonInteger dayOfMonth = JsonInteger('dayOfMonth');
  JsonInteger dayOfWeek = JsonInteger('dayOfWeek');
  JsonInteger startId = JsonInteger('startId');
  JsonInteger endId = JsonInteger('endId');
  JsonDate date = JsonDate('date');

  JsonObject<Period> weekDay = JsonObject<Period>('weekDay');
}
