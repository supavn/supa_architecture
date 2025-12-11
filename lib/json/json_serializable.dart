part of "json.dart";

/// A mixin that defines the contract for JSON serialization and deserialization.
///
/// [JsonSerializable] provides the interface that all JSON-serializable classes
/// must implement. It's used by [JsonModel] and ensures consistent serialization
/// behavior across the codebase.
///
/// **Key Methods:**
/// - [fromJson]: Deserializes JSON data into the object
/// - [toJson]: Serializes the object to JSON format
///
/// **Usage:**
/// Classes that need JSON serialization should mix in this mixin and implement
/// both methods. [JsonModel] already includes this mixin, so models extending
/// [JsonModel] automatically implement this interface.
///
/// **Example:**
/// ```dart
/// class MyModel with JsonSerializable {
///   @override
///   void fromJson(dynamic json) {
///     // Deserialization logic
///   }
///
///   @override
///   dynamic toJson() {
///     // Serialization logic
///     return {};
///   }
/// }
/// ```
///
/// **See also:**
/// - [JsonModel] for the base model class that uses this mixin
mixin JsonSerializable {
  /// Deserializes JSON data into this object instance.
  ///
  /// This method should populate the object's properties from the provided
  /// JSON data. The implementation should handle type conversion, null values,
  /// and nested objects as needed.
  ///
  /// **Parameters:**
  /// - `json`: The JSON data to deserialize. Typically a `Map<String, dynamic>`
  ///   or a `List`, but can be any type depending on the object's structure.
  ///
  /// **Example:**
  /// ```dart
  /// final model = MyModel();
  /// model.fromJson({'name': 'John', 'age': 30});
  /// ```
  void fromJson(dynamic json);

  /// Serializes this object instance to JSON format.
  ///
  /// This method should convert the object's properties into a JSON-serializable
  /// format (typically a `Map<String, dynamic>` or a `List`).
  ///
  /// **Returns:**
  /// A JSON-serializable representation of the object (usually a `Map<String, dynamic>`
  /// or `List`, but can be any JSON-serializable type).
  ///
  /// **Example:**
  /// ```dart
  /// final model = MyModel();
  /// final json = model.toJson(); // {'name': 'John', 'age': 30}
  /// ```
  dynamic toJson();
}
