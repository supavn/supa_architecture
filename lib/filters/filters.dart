import "dart:convert";

import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/date_type.dart";

part "abstract_id_filter.dart";
part "abstract_number_filter.dart";
part "admin_type_filter.dart";
part "app_user_filter.dart";
part "date_filter.dart";
part "date_filter_mixin.dart";
part "discussion_filter.dart";
part "double_filter.dart";
part "enum_model_filter.dart";
part "file_filter.dart";
part "filter_field.dart";
part "gender_filter.dart";
part "global_user_filter.dart";
part "guid_filter.dart";
part "id_filter.dart";
part "image_filter.dart";
part "int_filter.dart";
part "language_filter.dart";
part "number_filter.dart";
part "period_filter.dart";
part "request_history_filter.dart";
part "string_filter.dart";
part "sub_system_filter.dart";
part "tenant_filter.dart";
part "timezone_filter.dart";
part "user_notification_filter.dart";

/// Base class for creating data filters.
///
/// This abstract class defines common properties and methods for filtering
/// data sets, such as pagination, sorting, and search functionality.
abstract class DataFilter implements JsonSerializable {
  /// Constant for ascending order.
  static const orderAsc = "ASC";

  /// Constant for descending order.
  static const orderDesc = "DESC";

  /// Constant for the "ALL" view code.
  static const viewCodeAll = "ALL";

  /// Constant for the "PENDING" view code.
  static const viewCodePending = "PENDING";

  /// Constant for the "APPROVED" view code.
  static const viewCodeApproved = "APPROVED";

  /// Constant for the "OWNER" view code.
  static const viewCodeOwner = "OWNER";

  /// Number of entities to skip.
  int skip = 0;

  /// Number of entities to take in a request.
  int take = 20;

  /// Field name to order by.
  String? orderBy;

  /// Order orientation.
  String? orderType;

  /// Search field.
  String? search;

  /// Document view code.
  String? viewCode;

  /// A list of filter fields to be applied to the data set.
  ///
  /// The list may be empty, but it will never be `null`.
  ///
  /// Each filter field in the list provides a set of operations to be applied
  /// to a specific field in the data set.
  ///
  /// The operations are:
  /// - `equal`: Matches the specified value.
  /// - `notEqual`: Excludes the specified value.
  /// - `greater`: Matches values greater than the specified value.
  /// - `greaterEqual`: Matches values greater than or equal to the specified
  /// value.
  /// - `less`: Matches values less than the specified value.
  /// - `lessEqual`: Matches values less than or equal to the specified value.
  /// - `startWith`: Matches values that start with the specified value.
  /// - `notStartWith`: Excludes values that start with the specified value.
  /// - `endWith`: Matches values that end with the specified value.
  /// - `notEndWith`: Excludes values that end with the specified value.
  /// - `contain`: Matches values that contain the specified value.
  /// - `notContain`: Excludes values that contain the specified value.
  /// - `inList`: Matches values in the specified list.
  /// - `notInList`: Excludes values in the specified list.
  /// - `search`: Matches values that contain the specified value in any part of
  /// the field.
  ///
  /// The field name is defined by the `name` property of each filter field.
  ///
  /// The specific operations available depend on the type of the field. For
  /// example, the `string` type supports `equal`, `notEqual`, `contain`,
  /// `notContain`, `startWith`, `notStartWith`, `endWith`, `notEndWith`, and
  /// `search`.
  ///
  /// The `inList` and `notInList` operations are available for fields of type
  /// `int`, `double`, `guid`, and `string`.
  ///
  /// The `greater`, `greaterEqual`, `less`, and `lessEqual` operations are
  /// available for fields of type `int`, `double`, and `date`.
  List<FilterField> get fields;

  /// Converts this filter to a JSON-compatible map.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json["skip"] = skip;
    json["take"] = take;
    if (orderBy != null) {
      json["orderBy"] = orderBy;
    }
    if (orderType != null) {
      json["orderType"] = orderType;
    }
    if (search != null) {
      json["search"] = search;
    }
    if (viewCode != null) {
      json["viewCode"] = viewCode;
    }
    for (final field in fields) {
      json[field.name] = field.toJson();
    }
    return json;
  }

  /// Populates this filter from a JSON-compatible map.
  ///
  /// **Parameters:**
  /// - `json`: The JSON-compatible map to populate from.
  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey("skip") && json["skip"] is int?) {
        skip = json["skip"];
      }
      if (json.containsKey("take") && json["take"] is int?) {
        take = json["take"];
      }
      if (json.containsKey("orderBy") && json["orderBy"] is String?) {
        orderBy = json["orderBy"];
      }
      if (json.containsKey("orderType") && json["orderType"] is String?) {
        orderType = json["orderType"];
      }
      if (json.containsKey("search") && json["search"] is String?) {
        search = json["search"];
      }
      if (json.containsKey("viewCode") && json["viewCode"] is String?) {
        viewCode = json["viewCode"];
      }

      for (final field in fields) {
        if (json.containsKey(field.name) && json[field.name] != null) {
          field.fromJson(json[field.name]);
        }
      }
    }
  }

  /// Converts this filter to a JSON string.
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Calculates the next page to be fetched based on the current `skip` and `take` values.
  ///
  /// **Returns:**
  /// - The number of entities to skip for the next page.
  int nextPage() {
    return skip + take;
  }
}
