part of "json.dart";

/// A specialized JSON field for handling generic numeric values.
///
/// [JsonNumber] extends [JsonField<num>] to provide type-safe handling of
/// numeric values that can be either integers or doubles. It's useful when
/// you need to accept any numeric type without specifying whether it's an
/// integer or floating-point number.
///
/// **Key Features:**
/// - Accepts both `int` and `double` values (via `num` type)
/// - Parses numeric strings to numbers
/// - Defaults to `0` when value is null
/// - Type-safe numeric operations
///
/// **Usage Example:**
/// ```dart
/// final count = JsonNumber('count');
/// count.value = 42;        // Integer
/// count.value = 3.14;      // Double
/// count.value = "100";     // String parsed to number
/// print(count.value);      // 100
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [JsonInteger] for integer-specific handling
/// - [JsonDouble] for double-specific handling
class JsonNumber extends JsonField<num> {
  /// Creates a new [JsonNumber] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonNumber(super.fieldName);

  /// Returns the numeric value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `0` as
  /// a default value. This ensures that number fields always provide a
  /// valid numeric value when accessed, which is useful for calculations.
  ///
  /// **Returns:**
  /// The numeric value (can be `int` or `double`), or `0` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonNumber('count');
  /// print(field.value); // 0 (default)
  ///
  /// field.value = 42;
  /// print(field.value); // 42
  /// ```
  @override
  num get value => rawValue ?? 0;

  /// Sets the numeric value, accepting both numbers and numeric strings.
  ///
  /// This setter provides flexible input handling:
  /// - **`num` or `null`**: Assigned directly to [rawValue] (accepts both
  ///   `int` and `double` since they extend `num`)
  /// - **`String`**: Parsed using `num.tryParse()`. If parsing fails,
  ///   [rawValue] is set to `null`
  ///
  /// **Parameters:**
  /// - `value`: The value to set, which can be a `num` (int or double), a
  ///   numeric `String`, or `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonNumber('count');
  /// field.value = 42;      // Integer
  /// field.value = 3.14;    // Double
  /// field.value = "100";   // String → 100
  /// field.value = "invalid"; // Sets rawValue to null
  /// ```
  @override
  set value(dynamic value) {
    if (value is num?) {
      rawValue = value;
      return;
    }
    if (value is String) {
      rawValue = num.tryParse(value);
      return;
    }
  }

  /// Serializes the numeric value to JSON format.
  ///
  /// Returns the raw numeric value, which may be `null` if no value has been
  /// set. This allows the JSON representation to distinguish between an
  /// explicitly set `0` value and an unset (null) value.
  ///
  /// **Returns:**
  /// The numeric value (int or double), or `null` if no value has been set.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonNumber('count');
  /// print(field.toJson()); // null
  ///
  /// field.value = 42;
  /// print(field.toJson()); // 42
  /// ```
  @override
  num? toJson() {
    return rawValue;
  }
}
