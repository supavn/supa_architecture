part of "json.dart";

/// A specialized JSON field for handling lists of [JsonModel] objects.
///
/// [JsonList] extends [JsonField<List<T>>] to provide type-safe handling of
/// arrays of model objects in JSON data. It automatically deserializes JSON
/// arrays into lists of model instances and provides indexed access to elements.
///
/// **Key Features:**
/// - Automatic deserialization of JSON arrays to model lists
/// - Indexed access using `[]` and `[]=` operators
/// - Defaults to empty list when value is null
/// - Type-safe list operations with generic type parameter
///
/// **Type Parameter:**
/// - `T`: The type of [JsonModel] objects in the list (e.g., `UserModel`, `ProductModel`).
///
/// **Usage Example:**
/// ```dart
/// final users = JsonList<UserModel>('users');
/// users.value = [
///   {'name': 'John', 'age': 30},
///   {'name': 'Jane', 'age': 25}
/// ]; // Automatically deserializes to List<UserModel>
///
/// print(users[0]['name']); // 'John'
/// print(users.length);     // 2
/// ```
///
/// **See also:**
/// - [JsonField] for the base field implementation
/// - [JsonModel] for the model base class
/// - [JsonObject] for single nested objects
class JsonList<T extends JsonModel> extends JsonField<List<T>> {
  /// Creates a new [JsonList] field with the specified field name.
  ///
  /// The list is initialized as an empty list. The [fieldName] corresponds
  /// to the key in the JSON object that this field will map to during
  /// serialization and deserialization.
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field as it appears in JSON data.
  JsonList(super.fieldName) {
    rawValue = [];
  }

  /// Returns the list of model objects.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns an empty
  /// list `[]` as a default value. This ensures that list fields always
  /// provide a valid list when accessed, preventing null reference errors.
  ///
  /// **Returns:**
  /// The list of `T` objects, or an empty list if [rawValue] is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonList<UserModel>('users');
  /// print(field.value); // [] (empty list, default)
  ///
  /// field.value = [user1, user2];
  /// print(field.value.length); // 2
  /// ```
  @override
  List<T> get value => rawValue ?? [];

  /// Sets the list value, accepting both typed lists and JSON arrays.
  ///
  /// This setter provides flexible input handling:
  /// - **`List<T>`**: Assigned directly to [rawValue]
  /// - **`List` (untyped)**: Each element is deserialized into a new instance
  ///   of type `T` using dependency injection (`GetIt.instance.get<T>()`)
  ///   and then populated with data via `fromJson()`
  /// - **`null`**: Sets [rawValue] to an empty list
  ///
  /// **Parameters:**
  /// - `value`: The value to set, which can be a `List<T>`, an untyped `List`
  ///   of JSON maps, or `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonList<UserModel>('users');
  /// // From typed list
  /// field.value = [user1, user2];
  ///
  /// // From JSON array
  /// field.value = [
  ///   {'name': 'John', 'age': 30},
  ///   {'name': 'Jane', 'age': 25}
  /// ]; // Automatically creates UserModel instances
  /// ```
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = [];
      return;
    }
    if (value is List<T>) {
      rawValue = value;
      return;
    }
    if (value is List) {
      rawValue = value.map((element) {
        final model = GetIt.instance.get<T>();
        model.fromJson(element);
        return model;
      }).toList();
    }
  }

  /// Serializes the list of model objects to a JSON array.
  ///
  /// Each model in the list is serialized using its `toJson()` method, resulting
  /// in a list of JSON maps. Returns `null` if the list is `null`, allowing
  /// the field to be omitted from JSON output when appropriate.
  ///
  /// **Returns:**
  /// A list of JSON maps, each representing a serialized model object, or
  /// `null` if the list is `null`.
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonList<UserModel>('users');
  /// field.value = [user1, user2];
  /// print(field.toJson());
  /// // [{'name': 'John', 'age': 30}, {'name': 'Jane', 'age': 25}]
  /// ```
  @override
  List<Map<String, dynamic>>? toJson() {
    return rawValue?.map((element) => element.toJson()).toList();
  }

  /// Retrieves the model object at the specified index.
  ///
  /// Provides convenient indexed access to list elements. Returns `null` if
  /// the list is `null`, otherwise returns the element at the given index.
  ///
  /// **Parameters:**
  /// - `index`: The zero-based index of the element to retrieve.
  ///
  /// **Returns:**
  /// The model object of type `T` at the specified index, or `null` if
  /// [rawValue] is `null`.
  ///
  /// **Throws:**
  /// An [Exception] if the index is out of range (negative or >= list length).
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonList<UserModel>('users');
  /// field.value = [user1, user2];
  /// print(field[0]['name']); // Access first user's name
  /// ```
  operator [](int index) {
    if (rawValue == null) {
      return null;
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception("Index $index is out of range");
    }
    return rawValue![index];
  }

  /// Sets the model object at the specified index.
  ///
  /// Provides convenient indexed assignment to list elements. The list must
  /// not be `null` (asserted at runtime).
  ///
  /// **Parameters:**
  /// - `index`: The zero-based index where the element should be set.
  /// - `value`: The new model object of type `T` to assign at the index.
  ///
  /// **Throws:**
  /// An [Exception] if:
  /// - [rawValue] is `null` (list not initialized)
  /// - The index is out of range (negative or >= list length)
  ///
  /// **Example:**
  /// ```dart
  /// final field = JsonList<UserModel>('users');
  /// field.value = [user1, user2];
  /// field[0] = newUser; // Replace first element
  /// ```
  operator []=(int index, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception("Index $index is out of range");
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception("Index $index is out of range");
    }
    rawValue![index] = value;
  }
}
