part of "json.dart";

/// A specialized JSON field for handling boolean (true/false) values.
///
/// [JsonBoolean] extends [JsonField<bool>] to provide type-safe handling of
/// boolean values in JSON data. It ensures that boolean fields always return
/// a valid boolean value, defaulting to `false` when the underlying value is null.
///
/// **Key Features:**
/// - Always returns a boolean value (never null from the `value` getter)
/// - Defaults to `false` when the raw value is null
/// - Preserves null values in JSON serialization when appropriate
///
/// **Usage Example:**
/// ```dart
/// final isActive = JsonBoolean('isActive');
/// isActive.value = true;
/// print(isActive.value); // true
///
/// isActive.rawValue = null;
/// print(isActive.value); // false (default)
/// print(isActive.toJson()); // null
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
class JsonBoolean extends JsonField<bool> {
  /// Creates a new [JsonBoolean] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonBoolean(super.fieldName);

  /// Returns the boolean value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `false` as
  /// a default value. This ensures that boolean fields always provide a
  /// valid boolean value when accessed, which is useful for conditional logic.
  ///
  /// **Returns:**
  /// The boolean value, or `false` if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonBoolean('active');
  /// print(field.value); // false (default)
  ///
  /// field.value = true;
  /// print(field.value); // true
  /// ```
  @override
  bool get value {
    return rawValue ?? false;
  }

  /// Serializes the boolean value to JSON format.
  ///
  /// Returns the raw boolean value, which may be `null` if no value has been
  /// set. This allows the JSON representation to distinguish between an
  /// explicitly set `false` value and an unset (null) value.
  ///
  /// **Returns:**
  /// The boolean value (`true` or `false`), or `null` if no value has been set.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonBoolean('active');
  /// print(field.toJson()); // null
  ///
  /// field.value = false;
  /// print(field.toJson()); // false
  /// ```
  @override
  bool? toJson() {
    return rawValue;
  }
}
