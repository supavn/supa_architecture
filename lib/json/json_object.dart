part of "json.dart";

/// A specialized JSON field for handling nested [JsonModel] objects.
///
/// [JsonObject] extends [JsonField<T>] to provide type-safe handling of
/// nested model objects in JSON data. It automatically deserializes JSON
/// objects into model instances and provides convenient access to nested
/// fields using the `[]` and `[]=` operators.
///
/// **Key Features:**
/// - Automatic deserialization of JSON objects to model instances
/// - Nested field access using `[]` and `[]=` operators
/// - Lazy instantiation: creates a new model instance if value is null
/// - Type-safe operations with generic type parameter
///
/// **Type Parameter:**
/// - `T`: The type of [JsonModel] this field holds (e.g., `UserModel`, `AddressModel`).
///
/// **Usage Example:**
/// ```dart
/// final address = JsonObject<AddressModel>('address');
/// address.value = {
///   'street': '123 Main St',
///   'city': 'New York'
/// }; // Automatically deserializes to AddressModel
///
/// print(address['city']); // 'New York'
/// address['zipCode'] = '10001'; // Set nested field
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [JsonModel] for the model base class
/// - [JsonList] for lists of model objects
class JsonObject<T extends JsonModel> extends JsonField<T> {
  /// Creates a new [JsonObject] field with the specified field name.
  ///
  /// The [fieldName] corresponds to the key in the JSON object that this
  /// field will map to during serialization and deserialization. Model
  /// instances are created using dependency injection (`GetIt.instance.get<T>()`).
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonObject(super.fieldName);

  /// Returns the model object, creating a new instance if needed.
  ///
  /// If the underlying [rawValue] is `null`, this getter creates and returns
  /// a new instance of type `T` using dependency injection. This lazy
  /// instantiation ensures that you always have a valid model object to work
  /// with, even if the field hasn't been populated yet.
  ///
  /// **Returns:**
  /// The model object of type `T`. If [rawValue] is `null`, a new instance
  /// is created via `GetIt.instance.get<T>()`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonObject<AddressModel>('address');
  /// final address = field.value; // Creates new AddressModel instance
  /// address['city'] = 'New York';
  /// ```
  @override
  T get value {
    if (rawValue == null) {
      return GetIt.instance.get<T>();
    }
    return rawValue!;
  }

  /// Sets the model object value, accepting both typed models and JSON maps.
  ///
  /// This setter provides flexible input handling:
  /// - **`T` (typed model)**: Assigned directly to [rawValue]
  /// - **`Map<String, dynamic>`**: A new instance of type `T` is created using
  ///   dependency injection, then populated with data via `fromJson()`
  /// - **`null`**: Sets [rawValue] to `null`
  ///
  /// **Parameters:**
  /// - `value`: The value to set, which can be a model instance of type `T`,
  ///   a JSON map, or `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonObject<AddressModel>('address');
  /// // From typed model
  /// field.value = addressModel;
  ///
  /// // From JSON map
  /// field.value = {
  ///   'street': '123 Main St',
  ///   'city': 'New York'
  /// }; // Automatically creates and populates AddressModel
  /// ```
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = null;
      return;
    }
    if (value is T) {
      rawValue = value;
      return;
    }
    if (value is Map<String, dynamic>) {
      final model = GetIt.instance.get<T>();
      model.fromJson(value);
      rawValue = model;
    }
  }

  /// Serializes the nested model object to a JSON map.
  ///
  /// Uses the model's `toJson()` method to serialize the nested object.
  /// Returns `null` if the model is `null`, allowing the field to be omitted
  /// from JSON output when appropriate.
  ///
  /// **Returns:**
  /// A JSON map representing the serialized model object, or `null` if
  /// the model is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonObject<AddressModel>('address');
  /// field.value = addressModel;
  /// print(field.toJson());
  /// // {'street': '123 Main St', 'city': 'New York'}
  /// ```
  @override
  Map<String, dynamic>? toJson() {
    return rawValue?.toJson();
  }

  /// Retrieves the value of a nested field within the model object.
  ///
  /// Provides convenient access to fields within the nested model using
  /// bracket notation. This delegates to the model's `[]` operator.
  ///
  /// **Parameters:**
  /// - `name`: The name of the nested field to retrieve (must match a field's
  ///   [JsonField.fieldName] in the nested model).
  ///
  /// **Returns:**
  /// The value of the nested field, or `null` if the model object is `null`.
  ///
  /// **Throws:**
  /// An [Exception] if the nested model exists but no field with the given
  /// name exists.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonObject<AddressModel>('address');
  /// field.value = addressModel;
  /// print(field['city']); // 'New York'
  /// ```
  operator [](String name) {
    if (rawValue == null) {
      return null;
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception("Field $name does not exist");
  }

  /// Sets the value of a nested field within the model object.
  ///
  /// Provides convenient assignment to fields within the nested model using
  /// bracket notation. This delegates to the model's `[]=` operator. The
  /// model object must not be `null` (asserted at runtime).
  ///
  /// **Parameters:**
  /// - `name`: The name of the nested field to set (must match a field's
  ///   [JsonField.fieldName] in the nested model).
  /// - `value`: The new value to assign to the nested field.
  ///
  /// **Throws:**
  /// An [Exception] if:
  /// - The model object is `null`
  /// - No field with the given name exists in the nested model
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonObject<AddressModel>('address');
  /// field.value = addressModel;
  /// field['zipCode'] = '10001'; // Set nested field value
  /// ```
  operator []=(String name, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception("Field $name does not exist");
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception("Field $name does not exist");
  }
}
