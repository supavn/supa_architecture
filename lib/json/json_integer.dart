part of "json.dart";

/// A specialized JSON field for handling integer (whole number) values.
///
/// [JsonInteger] extends [JsonField<int>] to provide type-safe handling of
/// integer values in JSON data. It supports parsing numeric strings to integers
/// and ensures that integer fields always return a valid integer value.
///
/// **Key Features:**
/// - Parses numeric strings to integer values
/// - Defaults to `0` when value is null
/// - Type-safe integer operations
///
/// **Usage Example:**
/// ```dart
/// final age = JsonInteger('age');
/// age.value = 25;        // Direct integer
/// age.value = "30";      // String parsed to integer
/// print(age.value);      // 30
///
/// age.value = "invalid"; // Sets rawValue to null (parse fails)
/// print(age.value);      // 0 (default)
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [JsonDouble] for decimal numbers
/// - [JsonNumber] for generic numeric values
class JsonInteger extends JsonField<int> {
  /// Creates a new [JsonInteger] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonInteger(super.fieldName);

  /// Returns the integer value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `0` as
  /// a default value. This ensures that integer fields always provide a
  /// valid integer value when accessed, which is useful for calculations.
  ///
  /// **Returns:**
  /// The integer value, or `0` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonInteger('age');
  /// print(field.value); // 0 (default)
  ///
  /// field.value = 25;
  /// print(field.value); // 25
  /// ```
  @override
  int get value => rawValue ?? 0;

  /// Sets the integer value, accepting both integers and numeric strings.
  ///
  /// This setter provides flexible input handling:
  /// - **`int` or `null`**: Assigned directly to [rawValue]
  /// - **`String`**: Parsed using `int.tryParse()`. If parsing fails
  ///   (e.g., non-numeric string), [rawValue] is set to `null`
  ///
  /// **Parameters:**
  /// - `value`: The value to set, which can be an `int`, a numeric `String`,
  ///   or `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonInteger('age');
  /// field.value = 25;      // Direct integer
  /// field.value = "30";    // String → 30
  /// field.value = "invalid"; // Sets rawValue to null
  /// ```
  @override
  set value(dynamic value) {
    if (value is int?) {
      rawValue = value;
      return;
    }
    if (value is String) {
      rawValue = int.tryParse(value);
      return;
    }
  }

  /// Serializes the integer value to JSON format.
  ///
  /// Returns the raw integer value, which may be `null` if no value has been
  /// set. This allows the JSON representation to distinguish between an
  /// explicitly set `0` value and an unset (null) value.
  ///
  /// **Returns:**
  /// The integer value, or `null` if no value has been set.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonInteger('age');
  /// print(field.toJson()); // null
  ///
  /// field.value = 25;
  /// print(field.toJson()); // 25
  ///
  /// field.value = 0;
  /// print(field.toJson()); // 0
  /// ```
  @override
  int? toJson() {
    return rawValue;
  }
}
