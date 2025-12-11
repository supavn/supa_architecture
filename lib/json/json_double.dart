part of "json.dart";

/// A specialized JSON field for handling double-precision floating-point numbers.
///
/// [JsonDouble] extends [JsonField<double>] to provide type-safe handling of
/// decimal numbers in JSON data. It supports parsing numeric strings and
/// converting integers to doubles, ensuring flexible input handling while
/// maintaining type safety.
///
/// **Key Features:**
/// - Parses numeric strings to double values
/// - Converts integers to doubles automatically
/// - Defaults to `0.0` when value is null
/// - Handles various input types with graceful fallback
///
/// **Usage Example:**
/// ```dart
/// final price = JsonDouble('price');
/// price.value = 19.99;        // Direct double
/// price.value = 25;            // Integer converted to double
/// price.value = "29.99";       // String parsed to double
/// print(price.value);          // 29.99
///
/// price.value = "invalid";     // Sets rawValue to null (parse fails)
/// print(price.value);          // 0.0 (default)
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [JsonInteger] for integer values
/// - [JsonNumber] for generic numeric values
class JsonDouble extends JsonField<double> {
  /// Creates a new [JsonDouble] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonDouble(super.fieldName);

  /// Returns the double value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `0.0` as
  /// a default value. This ensures that double fields always provide a
  /// valid numeric value when accessed, which is useful for calculations.
  ///
  /// **Returns:**
  /// The double value, or `0.0` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDouble('price');
  /// print(field.value); // 0.0 (default)
  ///
  /// field.value = 19.99;
  /// print(field.value); // 19.99
  /// ```
  @override
  double get value => rawValue ?? 0;

  /// Sets the double value, accepting multiple input types with automatic conversion.
  ///
  /// This setter provides flexible input handling:
  /// - **`double`**: Assigned directly to [rawValue]
  /// - **`int`**: Converted to `double` using `toDouble()`
  /// - **`String`**: Parsed using `double.tryParse()`. If parsing fails,
  ///   [rawValue] is set to `null`
  /// - **`null`**: Sets [rawValue] to `null`
  /// - **Other types**: Attempts conversion via `toString()` and parsing.
  ///   If that fails, [rawValue] is set to `null`
  ///
  /// **Parameters:**
  /// - `value`: The value to set, which can be a `double`, `int`, `String`,
  ///   `null`, or other types (with fallback conversion).
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDouble('price');
  /// field.value = 19.99;      // Direct double
  /// field.value = 25;         // Integer → 25.0
  /// field.value = "29.99";    // String → 29.99
  /// field.value = "invalid";  // Sets rawValue to null
  /// ```
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = null;
      return;
    }
    if (value is double) {
      rawValue = value;
      return;
    }
    if (value is int) {
      rawValue = value.toDouble();
      return;
    }
    if (value is String) {
      rawValue = double.tryParse(value);
      return;
    }
    // Attempt to handle other data types via conversion
    try {
      rawValue = double.tryParse(value.toString());
    } catch (_) {
      rawValue = null; // Fallback if conversion fails
    }
  }

  /// Serializes the double value to JSON format.
  ///
  /// Returns the raw double value, which may be `null` if no value has been
  /// set. This allows the JSON representation to distinguish between an
  /// explicitly set `0.0` value and an unset (null) value.
  ///
  /// **Returns:**
  /// The double value, or `null` if no value has been set.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonDouble('price');
  /// print(field.toJson()); // null
  ///
  /// field.value = 19.99;
  /// print(field.toJson()); // 19.99
  ///
  /// field.value = 0.0;
  /// print(field.toJson()); // 0.0
  /// ```
  @override
  double? toJson() {
    return rawValue;
  }
}
