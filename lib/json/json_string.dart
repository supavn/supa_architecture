part of "json.dart";

/// A specialized JSON field for handling string (text) values.
///
/// [JsonString] extends [JsonField<String>] to provide type-safe handling of
/// string values in JSON data. It ensures that string fields always return
/// a valid string value, defaulting to an empty string when the underlying
/// value is null.
///
/// **Key Features:**
/// - Always returns a string value (never null from the `value` getter)
/// - Defaults to empty string `""` when the raw value is null
/// - Preserves null values in JSON serialization when appropriate
///
/// **Usage Example:**
/// ```dart
/// final name = JsonString('name');
/// name.value = 'John Doe';
/// print(name.value); // 'John Doe'
///
/// name.rawValue = null;
/// print(name.value); // '' (empty string, default)
/// print(name.toJson()); // null
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
class JsonString extends JsonField<String> {
  /// Creates a new [JsonString] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonString(super.fieldName);

  /// Serializes the string value to JSON format.
  ///
  /// Returns the raw string value, which may be `null` if no value has been
  /// set. This allows the JSON representation to distinguish between an
  /// explicitly set empty string `""` and an unset (null) value.
  ///
  /// **Returns:**
  /// The string value, or `null` if no value has been set.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonString('name');
  /// print(field.toJson()); // null
  ///
  /// field.value = 'John';
  /// print(field.toJson()); // 'John'
  ///
  /// field.value = '';
  /// print(field.toJson()); // '' (empty string)
  /// ```
  @override
  String? toJson() {
    return rawValue;
  }

  /// Returns the string value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns an empty
  /// string `""` as a default value. This ensures that string fields always
  /// provide a valid string value when accessed, which prevents null reference
  /// errors in string operations.
  ///
  /// **Returns:**
  /// The string value, or an empty string `""` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonString('name');
  /// print(field.value); // '' (empty string, default)
  ///
  /// field.value = 'John Doe';
  /// print(field.value); // 'John Doe'
  ///
  /// print(field.value.length); // Always safe, never null
  /// ```
  @override
  String get value => rawValue ?? "";
}
