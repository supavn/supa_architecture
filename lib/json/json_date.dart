part of "json.dart";

/// Extension methods for [DateTime] to handle timezone offset formatting.
///
/// This extension provides utilities for converting [DateTime] objects to
/// ISO 8601 strings with timezone offset information, which is essential for
/// proper date/time serialization in JSON APIs.
extension DateTimeOffsetExtensions on DateTime {
  /// Returns the timezone offset as a string in the format `±hh:mm`.
  ///
  /// For UTC dates, returns an empty string (not "Z"). For local dates,
  /// returns the offset in the format `+HH:MM` or `-HH:MM` (e.g., `+07:00`,
  /// `-05:00`).
  ///
  /// **Returns:**
  /// A string representation of the timezone offset, or an empty string for UTC.
  ///
  /// **Example:**
  /// ```dart
  /// final localTime = DateTime.now();
  /// print(localTime.getTimezoneOffsetString()); // "+07:00" or "-05:00"
  ///
  /// final utcTime = DateTime.now().toUtc();
  /// print(utcTime.getTimezoneOffsetString()); // "" (empty for UTC)
  /// ```
  String getTimezoneOffsetString() {
    if (isUtc) {
      return "";
    } else {
      Duration offset = timeZoneOffset;
      String sign = offset.isNegative ? "-" : "+";
      int hours = offset.inHours.abs();
      int minutes = offset.inMinutes.remainder(60).abs();
      return "$sign${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}";
    }
  }

  /// Converts this [DateTime] to an ISO 8601 string with timezone offset.
  ///
  /// This method extends the standard `toIso8601String()` by appending the
  /// timezone offset. For UTC dates, the offset string is empty, resulting
  /// in a standard ISO 8601 UTC format. For local dates, the offset is
  /// appended in the `±HH:MM` format.
  ///
  /// **Returns:**
  /// An ISO 8601 formatted string with timezone offset (e.g.,
  /// `"2024-08-07T12:34:56.789+07:00"` or `"2024-08-07T12:34:56.789"` for UTC).
  ///
  /// **Example:**
  /// ```dart
  /// final localTime = DateTime.now();
  /// print(localTime.toIso8601StringWithOffset());
  /// // "2024-08-07T12:34:56.789+07:00"
  ///
  /// final utcTime = DateTime.now().toUtc();
  /// print(utcTime.toIso8601StringWithOffset());
  /// // "2024-08-07T12:34:56.789" (no offset for UTC)
  /// ```
  String toIso8601StringWithOffset() {
    String iso8601String = toIso8601String();
    String offsetString = getTimezoneOffsetString();
    return iso8601String + offsetString;
  }
}

/// A specialized JSON field for handling date and time values.
///
/// [JsonDate] extends [JsonField<DateTime>] to provide comprehensive date/time
/// handling in JSON data. It supports parsing date strings, formatting dates
/// for display, and serializing dates to ISO 8601 format in UTC.
///
/// **Key Features:**
/// - Automatic parsing of ISO 8601 date strings
/// - Defaults to current date/time when value is null
/// - Formats dates using customizable format strings
/// - Serializes dates to UTC ISO 8601 format for JSON
///
/// **Usage Example:**
/// ```dart
/// final createdAt = JsonDate('createdAt');
/// createdAt.value = '2024-08-07T12:34:56Z'; // Parses string
/// createdAt.value = DateTime.now(); // Accepts DateTime directly
///
/// print(createdAt.format()); // Formatted string for display
/// print(createdAt.toJson()); // ISO 8601 UTC string for JSON
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [DateTimeFormatsVN] for available date format constants
class JsonDate extends JsonField<DateTime> {
  /// Creates a new [JsonDate] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonDate(super.fieldName);

  /// Returns the [DateTime] value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns the current
  /// date and time (`DateTime.now()`) as a default value. This ensures that
  /// date fields always provide a valid [DateTime] when accessed.
  ///
  /// **Returns:**
  /// The [DateTime] value, or `DateTime.now()` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDate('createdAt');
  /// print(field.value); // Current date/time (default)
  ///
  /// field.value = DateTime(2024, 8, 7);
  /// print(field.value); // 2024-08-07 00:00:00.000
  /// ```
  @override
  DateTime get value {
    return rawValue ?? DateTime.now();
  }

  /// Sets the date value, accepting both [DateTime] objects and ISO 8601 strings.
  ///
  /// This setter provides flexible input handling:
  /// - If [value] is a `String`, it attempts to parse it as an ISO 8601 date
  ///   using [DateTime.tryParse]. If parsing fails, [rawValue] is set to `null`.
  /// - If [value] is a [DateTime], it is assigned directly.
  /// - If [value] is `null`, [rawValue] is set to `null`.
  ///
  /// **Parameters:**
  /// - `value`: The date value, which can be a [DateTime], an ISO 8601 string,
  ///   or `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDate('date');
  /// field.value = DateTime.now(); // Direct DateTime
  /// field.value = '2024-08-07T12:34:56Z'; // ISO 8601 string
  /// field.value = 'invalid'; // Sets rawValue to null (parse fails)
  /// ```
  @override
  set value(dynamic value) {
    if (value is String) {
      rawValue = DateTime.tryParse(value);
      return;
    }
    rawValue = value;
  }

  /// Formats the date value according to the specified format string.
  ///
  /// Returns an empty string if the date value is `null`. Otherwise, uses the
  /// [DateTime] extension method to format the date according to the provided
  /// format pattern.
  ///
  /// **Parameters:**
  /// - `dateFormat`: The format pattern to use (defaults to
  ///   [DateTimeFormatsVN.dateOnly]). See [DateTimeFormatsVN] for available
  ///   format constants.
  ///
  /// **Returns:**
  /// A formatted date string, or an empty string if the date is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDate('createdAt');
  /// field.value = DateTime(2024, 8, 7);
  /// print(field.format()); // "07/08/2024" (using default format)
  /// print(field.format(dateFormat: 'yyyy-MM-dd')); // "2024-08-07"
  /// ```
  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    if (rawValue == null) {
      return "";
    }
    return value.format(dateFormat: dateFormat);
  }

  /// Serializes the date value to an ISO 8601 UTC string for JSON.
  ///
  /// Converts the date to UTC timezone before serialization to ensure
  /// consistent representation across different timezones. Returns `null`
  /// if the date value is `null`.
  ///
  /// **Returns:**
  /// An ISO 8601 formatted string in UTC (e.g., `"2024-08-07T12:34:56.789Z"`),
  /// or `null` if the date is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDate('createdAt');
  /// field.value = DateTime(2024, 8, 7, 12, 34, 56);
  /// print(field.toJson()); // "2024-08-07T12:34:56.000Z" (converted to UTC)
  /// ```
  @override
  String? toJson() {
    return rawValue?.toUtc().toIso8601String();
  }
}
