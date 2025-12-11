part of "json.dart";

/// A type definition for a function that constructs an instance of [JsonModel].
///
/// This typedef is used to define factory functions that can create instances
/// of a specific [JsonModel] subtype. It's commonly used in dependency injection
/// scenarios where you need to provide a constructor function for creating model instances.
///
/// **Type Parameter:**
/// - `T`: The specific subtype of [JsonModel] that the constructor will create.
typedef InstanceConstructor<T extends JsonModel> = T Function();

/// An abstract base class for all JSON-serializable models in the application.
///
/// [JsonModel] provides a comprehensive framework for handling JSON serialization
/// and deserialization, field management, and validation messaging. It serves as
/// the foundation for all data models that need to interact with JSON data.
///
/// **Key Features:**
/// - Automatic JSON serialization/deserialization through [fromJson] and [toJson]
/// - Field-level and general error/warning/information message management
/// - Type-safe field access using the `[]` and `[]=` operators
/// - Automatic handling of field validation messages from server responses
///
/// **Usage:**
/// ```dart
/// class UserModel extends JsonModel {
///   @override
///   List<JsonField> get fields => [
///     JsonString('name'),
///     JsonInteger('age'),
///     JsonDate('createdAt'),
///   ];
/// }
/// ```
///
/// **See also:**
/// - [JsonField] for individual field definitions
/// - [JsonSerializable] for the serialization mixin
abstract class JsonModel with JsonSerializable {
  /// The list of JSON fields that define the structure of this model.
  ///
  /// Each field represents a property that can be serialized to and deserialized
  /// from JSON. Subclasses must override this getter to provide their field definitions.
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// List<JsonField> get fields => [
  ///   JsonString('email'),
  ///   JsonInteger('age'),
  /// ];
  /// ```
  List<JsonField> get fields;

  /// A list of general error messages that apply to the entire model.
  ///
  /// These errors are not associated with any specific field but indicate
  /// problems with the model as a whole (e.g., "Invalid credentials",
  /// "Account suspended"). Populated automatically during [fromJson] if
  /// the JSON contains a "generalErrors" array.
  List<String> generalErrors = [];

  /// A list of general warning messages that apply to the entire model.
  ///
  /// These warnings provide important information about the model state
  /// that doesn't prevent its use (e.g., "Password will expire soon").
  /// Populated automatically during [fromJson] if the JSON contains a
  /// "generalWarnings" array.
  List<String> generalWarnings = [];

  /// A list of general informational messages about the model.
  ///
  /// These messages provide non-critical information (e.g., "Last updated
  /// 5 minutes ago"). Populated automatically during [fromJson] if the
  /// JSON contains a "generalInformations" array.
  List<String> generalInformations = [];

  /// A map of field-specific error messages, keyed by field name.
  ///
  /// Each entry maps a field name to its error message, if any. These errors
  /// are automatically assigned to the corresponding [JsonField] instances
  /// during [fromJson]. Used for validation errors from server responses.
  Map<String, String?> errors = {};

  /// A map of field-specific warning messages, keyed by field name.
  ///
  /// Each entry maps a field name to its warning message, if any. These warnings
  /// are automatically assigned to the corresponding [JsonField] instances
  /// during [fromJson].
  Map<String, String?> warnings = {};

  /// A map of field-specific informational messages, keyed by field name.
  ///
  /// Each entry maps a field name to its informational message, if any. These
  /// messages are automatically assigned to the corresponding [JsonField] instances
  /// during [fromJson].
  Map<String, String?> informations = {};

  /// Returns `true` if the model has any field-specific or general errors.
  ///
  /// This is a convenience getter that checks if either [errors] or [generalErrors]
  /// contain any messages. Useful for quick validation checks before processing
  /// the model further.
  bool get hasError => errors.isNotEmpty;

  /// Returns `true` if the model has any field-specific or general warnings.
  ///
  /// This is a convenience getter that checks if either [warnings] or
  /// [generalWarnings] contain any messages.
  bool get hasWarning => warnings.isNotEmpty;

  /// Returns `true` if the model has any field-specific or general informational messages.
  ///
  /// This is a convenience getter that checks if either [informations] or
  /// [generalInformations] contain any messages.
  bool get hasInformation => informations.isNotEmpty;

  /// Returns the first general error message, or `null` if there are no errors.
  ///
  /// This is a convenience getter for accessing the most important general error
  /// when you only need to display a single error message to the user.
  String? get error => generalErrors.isNotEmpty ? generalErrors[0] : null;

  /// Returns the first general warning message, or `null` if there are no warnings.
  ///
  /// This is a convenience getter for accessing the most important general warning
  /// when you only need to display a single warning message to the user.
  String? get warning => generalWarnings.isNotEmpty ? generalWarnings[0] : null;

  /// Returns the first general informational message, or `null` if there are none.
  ///
  /// This is a convenience getter for accessing the most important general
  /// informational message when you only need to display a single message to the user.
  String? get information =>
      generalInformations.isNotEmpty ? generalInformations[0] : null;

  /// Deserializes JSON data into this model instance.
  ///
  /// This method populates the model's fields from the provided JSON data and
  /// handles error/warning/information messages from the server response. It
  /// automatically:
  /// - Extracts general errors, warnings, and informational messages
  /// - Maps field-specific errors, warnings, and informations
  /// - Deserializes all field values from the JSON map
  /// - Assigns validation messages to the corresponding fields
  ///
  /// **Parameters:**
  /// - `json`: The JSON data to deserialize. Can be a `Map<String, dynamic>`
  ///   or any other type (in which case deserialization is skipped).
  ///
  /// **Example:**
  /// ```dart
  /// final user = UserModel();
  /// user.fromJson({
  ///   'name': 'John Doe',
  ///   'age': 30,
  ///   'errors': {'email': 'Invalid email format'},
  ///   'generalErrors': ['Account verification required']
  /// });
  /// ```
  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey("generalErrors") && json["generalErrors"] is List) {
        generalErrors = (json["generalErrors"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("generalWarnings") &&
          json["generalWarnings"] is List) {
        generalWarnings = (json["generalWarnings"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("generalInformations") &&
          json["generalInformations"] is List) {
        generalInformations = (json["generalInformations"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("errors") && json["errors"] is Map) {
        errors = Map.fromEntries(
          (json["errors"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey("warnings") && json["warnings"] is Map) {
        warnings = Map.fromEntries(
          (json["warnings"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey("informations") && json["informations"] is Map) {
        informations = Map.fromEntries(
          (json["informations"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      for (final field in fields) {
        if (json.containsKey(field.fieldName)) {
          field.value = json[field.fieldName];
        }

        if (errors.containsKey(field.fieldName)) {
          field.error = errors[field.fieldName];
        }

        if (warnings.containsKey(field.fieldName)) {
          field.warning = warnings[field.fieldName];
        }

        if (informations.containsKey(field.fieldName)) {
          field.information = informations[field.fieldName];
        }
      }
    }
  }

  /// Serializes this model instance to a JSON map.
  ///
  /// Converts all non-null field values to their JSON representation. Fields
  /// with null values are excluded from the output. Additionally, ID fields
  /// (fields ending with 'id' except 'statusId') with a value of 0 are also
  /// excluded, as they represent unset foreign key references.
  ///
  /// **Returns:**
  /// A `Map<String, dynamic>` representing the model in JSON format, ready
  /// for transmission to a server or storage.
  ///
  /// **Example:**
  /// ```dart
  /// final user = UserModel();
  /// user['name'] = 'John Doe';
  /// user['age'] = 30;
  /// final json = user.toJson(); // {'name': 'John Doe', 'age': 30}
  /// ```
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    for (final field in fields) {
      if (field.fieldName.toLowerCase().endsWith('id') &&
          field.fieldName != 'statusId') {
        if (field.value == 0) {
          json.remove(field.fieldName);
          continue;
        }
      }
      if (field.rawValue != null) {
        final fieldValue = field.toJson();
        if (fieldValue != null) {
          json[field.fieldName] = fieldValue;
        }
      }
    }
    return json;
  }

  /// Returns a JSON string representation of this model.
  ///
  /// This method uses [toJson] to serialize the model and then encodes it
  /// as a JSON string using `jsonEncode`. Useful for logging, debugging,
  /// or when you need a string representation of the model.
  ///
  /// **Returns:**
  /// A JSON-encoded string representation of the model.
  ///
  /// **Example:**
  /// ```dart
  /// print(user.toString()); // '{"name":"John Doe","age":30}'
  /// ```
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Retrieves the value of a field by its name using bracket notation.
  ///
  /// This operator provides convenient access to field values without needing
  /// to iterate through the [fields] list manually. The returned value is
  /// the typed value from the field (e.g., `String` for [JsonString],
  /// `int` for [JsonInteger]).
  ///
  /// **Parameters:**
  /// - `name`: The name of the field to retrieve (must match a field's
  ///   [JsonField.fieldName]).
  ///
  /// **Returns:**
  /// The value of the field, which may be the field's default value if
  /// [rawValue] is null (see individual field type documentation).
  ///
  /// **Throws:**
  /// An [Exception] if no field with the given name exists in this model.
  ///
  /// **Example:**
  /// ```dart
  /// final name = user['name']; // Returns String value
  /// final age = user['age'];   // Returns int value
  /// ```
  operator [](String name) {
    for (final field in fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception("Field $name does not exist");
  }

  /// Sets the value of a field by its name using bracket notation.
  ///
  /// This operator provides convenient assignment to field values. The value
  /// will be automatically converted according to the field's type (e.g.,
  /// strings can be parsed to numbers for numeric fields).
  ///
  /// **Parameters:**
  /// - `name`: The name of the field to set (must match a field's
  ///   [JsonField.fieldName]).
  /// - `value`: The new value to assign. The type and conversion behavior
  ///   depend on the specific field type (see individual field documentation).
  ///
  /// **Throws:**
  /// An [Exception] if no field with the given name exists in this model.
  ///
  /// **Example:**
  /// ```dart
  /// user['name'] = 'Jane Doe';
  /// user['age'] = 25;
  /// user['age'] = '30'; // String will be parsed to int
  /// ```
  operator []=(String name, value) {
    for (final field in fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception("Field $name does not exist");
  }
}
