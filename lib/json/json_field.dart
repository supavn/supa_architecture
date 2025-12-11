part of "json.dart";

/// An abstract base class for all JSON field types.
///
/// [JsonField] provides the foundational structure for handling individual
/// fields within JSON-serializable models. It manages field metadata, validation
/// messages (errors, warnings, information), and value storage with type safety.
///
/// **Key Features:**
/// - Type-safe value storage with generic type parameter `T`
/// - Validation message management (errors, warnings, information)
/// - Null-safety with separate `rawValue` and typed `value` access
/// - Equality comparison based on field name and value
///
/// **Type Parameter:**
/// - `T`: The type of value this field holds (e.g., `String`, `int`, `DateTime`).
///
/// **Subclassing:**
/// Subclasses should override the `value` getter and setter to provide type-specific
/// behavior, such as parsing strings, providing default values, or converting types.
///
/// **Usage Example:**
/// ```dart
/// class JsonString extends JsonField<String> {
///   JsonString(super.fieldName);
///   @override
///   String get value => rawValue ?? "";
/// }
/// ```
///
/// **See also:**
/// - [JsonModel] for models that contain multiple fields
/// - Specific field types: [JsonString], [JsonInteger], [JsonBoolean], etc.
abstract class JsonField<T> {
  /// The name of this field as it appears in JSON data.
  ///
  /// This name is used as the key when serializing/deserializing the field
  /// to/from JSON objects. It must match the key name in the JSON data.
  final String fieldName;

  /// An error message associated with this field, if any.
  ///
  /// This is typically set during deserialization when the server returns
  /// validation errors for this specific field. Can be `null` if there are
  /// no errors.
  String? error;

  /// A warning message associated with this field, if any.
  ///
  /// Warnings indicate potential issues that don't prevent the field from
  /// being used. Can be `null` if there are no warnings.
  String? warning;

  /// An informational message associated with this field, if any.
  ///
  /// Informational messages provide non-critical context about the field.
  /// Can be `null` if there are no informational messages.
  String? information;

  /// Returns `true` if this field has an error message.
  ///
  /// This is a convenience getter that checks if [error] is not `null`.
  bool get hasError => error != null;

  /// Returns `true` if this field has a warning message.
  ///
  /// This is a convenience getter that checks if [warning] is not `null`.
  bool get hasWarning => warning != null;

  /// Returns `true` if this field has an informational message.
  ///
  /// This is a convenience getter that checks if [information] is not `null`.
  bool get hasInformation => information != null;

  /// Returns `true` if the raw value of this field is `null`.
  ///
  /// This checks the underlying [rawValue], which may differ from the
  /// typed [value] getter (which may provide a default value).
  bool get isNull => rawValue == null;

  /// Returns `true` if the raw value of this field is not `null`.
  ///
  /// This is the inverse of [isNull]. It checks the underlying [rawValue].
  bool get isNotNull => rawValue != null;

  /// The raw, unprocessed value stored in this field.
  ///
  /// This is the actual stored value, which may be `null`. Subclasses typically
  /// use this to provide a default value in their `value` getter when [rawValue]
  /// is `null`. This allows distinguishing between an unset value (null) and
  /// a default value in JSON serialization.
  T? rawValue;

  /// Returns the typed value of this field.
  ///
  /// Subclasses must override this getter to provide type-specific behavior,
  /// such as returning a default value when [rawValue] is `null`, or performing
  /// type conversions.
  ///
  /// **Returns:**
  /// The typed value of type `T`. The behavior when [rawValue] is `null`
  /// depends on the subclass implementation.
  T get value;

  /// Sets the value of this field.
  ///
  /// The default implementation simply assigns the value to [rawValue]. Subclasses
  /// may override this to provide type conversion, parsing, or validation logic.
  ///
  /// **Parameters:**
  /// - `value`: The value to set. The type and conversion behavior depend on
  ///   the specific field subclass.
  set value(dynamic value) {
    rawValue = value;
  }

  /// Determines whether this field is equal to another object.
  ///
  /// Two fields are considered equal if:
  /// - They are the same instance (identical), OR
  /// - The other object is of type `T` and equals this field's [rawValue], OR
  /// - The other object is a [JsonField<T>] with the same [fieldName] and [rawValue]
  ///
  /// **Parameters:**
  /// - `other`: The object to compare with this field.
  ///
  /// **Returns:**
  /// `true` if the objects are equal according to the criteria above, `false` otherwise.
  ///
  /// **Example:**
  /// ```dart
  /// final field1 = JsonString('name')..value = 'John';
  /// final field2 = JsonString('name')..value = 'John';
  /// print(field1 == field2); // true
  ///
  /// print(field1 == 'John'); // true (compares with rawValue)
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is T) {
      return other == rawValue;
    }
    return other is JsonField<T> &&
        other.fieldName == fieldName &&
        other.rawValue == rawValue;
  }

  /// Returns the hash code for this field.
  ///
  /// The hash code is computed from the [fieldName] and [rawValue], ensuring
  /// that fields with the same name and value produce the same hash code.
  /// This is consistent with the [operator ==] implementation.
  ///
  /// **Returns:**
  /// A hash code value for this field.
  @override
  int get hashCode => Object.hash(fieldName, rawValue);

  /// Creates a new [JsonField] instance with the specified field name.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data. This
  ///   name is used as the key during serialization and deserialization.
  JsonField(this.fieldName);

  /// Serializes the field value to JSON format.
  ///
  /// The default implementation returns [rawValue] directly. Subclasses may
  /// override this to provide custom serialization logic (e.g., formatting
  /// dates, converting types).
  ///
  /// **Returns:**
  /// The JSON-serializable representation of the field value. Returns `null`
  /// if [rawValue] is `null`, allowing JSON to omit the field when appropriate.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonString('name');
  /// print(field.toJson()); // null
  ///
  /// field.value = 'John';
  /// print(field.toJson()); // 'John'
  /// ```
  dynamic toJson() {
    return rawValue;
  }
}
