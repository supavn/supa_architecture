import 'package:flutter_test/flutter_test.dart';
import 'package:supa_architecture/json/json.dart';

/// Test class that implements JsonSerializable mixin
class TestSerializableClass with JsonSerializable {
  String? _name;
  int? _age;
  bool? _isActive;

  TestSerializableClass({String? name, int? age, bool? isActive}) {
    _name = name;
    _age = age;
    _isActive = isActive;
  }

  String? get name => _name;
  int? get age => _age;
  bool? get isActive => _isActive;

  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      _name = json['name'] as String?;
      _age = json['age'] as int?;
      _isActive = json['isActive'] as bool?;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'age': _age,
      'isActive': _isActive,
    };
  }
}

/// Test class that implements JsonSerializable with different data types
class TestComplexSerializableClass with JsonSerializable {
  List<String>? _tags;
  Map<String, dynamic>? _metadata;
  DateTime? _createdAt;

  TestComplexSerializableClass({
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    _tags = tags;
    _metadata = metadata;
    _createdAt = createdAt;
  }

  List<String>? get tags => _tags;
  Map<String, dynamic>? get metadata => _metadata;
  DateTime? get createdAt => _createdAt;

  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      _tags =
          json['tags'] != null ? List<String>.from(json['tags'] as List) : null;
      _metadata = json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null;
      _createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'tags': _tags,
      'metadata': _metadata,
      'createdAt': _createdAt?.toIso8601String(),
    };
  }
}

/// Test class that implements JsonSerializable with nested objects
class TestNestedSerializableClass with JsonSerializable {
  TestSerializableClass? nestedObject;
  List<TestSerializableClass>? nestedList;

  TestNestedSerializableClass({
    this.nestedObject,
    this.nestedList,
  });

  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json['nestedObject'] != null) {
        nestedObject = TestSerializableClass()..fromJson(json['nestedObject']);
      } else {
        nestedObject = null;
      }
      if (json['nestedList'] != null) {
        nestedList = (json['nestedList'] as List)
            .map((item) => TestSerializableClass()..fromJson(item))
            .toList();
      } else {
        nestedList = null;
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nestedObject': nestedObject?.toJson(),
      'nestedList': nestedList?.map((item) => item.toJson()).toList(),
    };
  }
}

void main() {
  group('JsonSerializable Mixin Tests', () {
    group('TestSerializableClass Tests', () {
      test('Basic serialization and deserialization', () {
        final original = TestSerializableClass(
          name: 'John Doe',
          age: 30,
          isActive: true,
        );

        final json = original.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['name'], equals('John Doe'));
        expect(json['age'], equals(30));
        expect(json['isActive'], isTrue);

        final deserialized = TestSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.name, equals('John Doe'));
        expect(deserialized.age, equals(30));
        expect(deserialized.isActive, isTrue);
      });

      test('Null value handling', () {
        final original = TestSerializableClass(
          name: null,
          age: null,
          isActive: null,
        );

        final json = original.toJson();
        expect(json['name'], isNull);
        expect(json['age'], isNull);
        expect(json['isActive'], isNull);

        final deserialized = TestSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.name, isNull);
        expect(deserialized.age, isNull);
        expect(deserialized.isActive, isNull);
      });

      test('Partial data serialization', () {
        final original = TestSerializableClass(
          name: 'Jane Smith',
          age: null,
          isActive: false,
        );

        final json = original.toJson();
        expect(json['name'], equals('Jane Smith'));
        expect(json['age'], isNull);
        expect(json['isActive'], isFalse);
      });
    });

    group('TestComplexSerializableClass Tests', () {
      test('Complex data type serialization', () {
        final original = TestComplexSerializableClass(
          tags: ['tag1', 'tag2', 'tag3'],
          metadata: {
            'key1': 'value1',
            'key2': 42,
            'key3': true,
          },
          createdAt: DateTime(2023, 1, 15, 10, 30, 0),
        );

        final json = original.toJson();
        expect(json['tags'], isA<List>());
        expect(json['tags'].length, equals(3));
        expect(json['tags'][0], equals('tag1'));
        expect(json['metadata'], isA<Map>());
        expect(json['metadata']['key1'], equals('value1'));
        expect(json['metadata']['key2'], equals(42));
        expect(json['metadata']['key3'], isTrue);
        expect(json['createdAt'], isA<String>());
        expect(json['createdAt'], contains('2023-01-15'));

        final deserialized = TestComplexSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.tags?.length, equals(3));
        expect(deserialized.tags?[0], equals('tag1'));
        expect(deserialized.metadata?['key1'], equals('value1'));
        expect(deserialized.metadata?['key2'], equals(42));
        expect(deserialized.metadata?['key3'], isTrue);
        expect(deserialized.createdAt?.year, equals(2023));
        expect(deserialized.createdAt?.month, equals(1));
        expect(deserialized.createdAt?.day, equals(15));
      });

      test('Empty collections handling', () {
        final original = TestComplexSerializableClass(
          tags: [],
          metadata: {},
          createdAt: null,
        );

        final json = original.toJson();
        expect(json['tags'], isA<List>());
        expect(json['tags'].length, equals(0));
        expect(json['metadata'], isA<Map>());
        expect(json['metadata'].length, equals(0));
        expect(json['createdAt'], isNull);
      });
    });

    group('TestNestedSerializableClass Tests', () {
      test('Nested object serialization', () {
        final nestedObject = TestSerializableClass(
          name: 'Nested Name',
          age: 25,
          isActive: false,
        );

        final original = TestNestedSerializableClass(
          nestedObject: nestedObject,
          nestedList: null,
        );

        final json = original.toJson();
        expect(json['nestedObject'], isA<Map<String, dynamic>>());
        expect(json['nestedObject']['name'], equals('Nested Name'));
        expect(json['nestedObject']['age'], equals(25));
        expect(json['nestedObject']['isActive'], isFalse);
        expect(json['nestedList'], isNull);

        final deserialized = TestNestedSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.nestedObject?.name, equals('Nested Name'));
        expect(deserialized.nestedObject?.age, equals(25));
        expect(deserialized.nestedObject?.isActive, isFalse);
        expect(deserialized.nestedList, isNull);
      });

      test('Nested list serialization', () {
        final nestedList = [
          TestSerializableClass(name: 'Item 1', age: 10, isActive: true),
          TestSerializableClass(name: 'Item 2', age: 20, isActive: false),
          TestSerializableClass(name: 'Item 3', age: 30, isActive: true),
        ];

        final original = TestNestedSerializableClass(
          nestedObject: null,
          nestedList: nestedList,
        );

        final json = original.toJson();
        expect(json['nestedObject'], isNull);
        expect(json['nestedList'], isA<List>());
        expect(json['nestedList'].length, equals(3));
        expect(json['nestedList'][0]['name'], equals('Item 1'));
        expect(json['nestedList'][1]['age'], equals(20));
        expect(json['nestedList'][2]['isActive'], isTrue);

        final deserialized = TestNestedSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.nestedObject, isNull);
        expect(deserialized.nestedList?.length, equals(3));
        expect(deserialized.nestedList?[0].name, equals('Item 1'));
        expect(deserialized.nestedList?[1].age, equals(20));
        expect(deserialized.nestedList?[2].isActive, isTrue);
      });

      test('Complex nested structure', () {
        final nestedObject = TestSerializableClass(
          name: 'Parent Object',
          age: 40,
          isActive: true,
        );

        final nestedList = [
          TestSerializableClass(name: 'Child 1', age: 15, isActive: true),
          TestSerializableClass(name: 'Child 2', age: 18, isActive: false),
        ];

        final original = TestNestedSerializableClass(
          nestedObject: nestedObject,
          nestedList: nestedList,
        );

        final json = original.toJson();
        expect(json['nestedObject']['name'], equals('Parent Object'));
        expect(json['nestedList'].length, equals(2));
        expect(json['nestedList'][0]['name'], equals('Child 1'));
        expect(json['nestedList'][1]['name'], equals('Child 2'));

        final deserialized = TestNestedSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.nestedObject?.name, equals('Parent Object'));
        expect(deserialized.nestedList?.length, equals(2));
        expect(deserialized.nestedList?[0].name, equals('Child 1'));
        expect(deserialized.nestedList?[1].name, equals('Child 2'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Empty JSON input', () {
        final deserialized = TestSerializableClass();
        deserialized.fromJson({});

        expect(deserialized.name, isNull);
        expect(deserialized.age, isNull);
        expect(deserialized.isActive, isNull);
      });

      test('Null JSON input', () {
        final deserialized = TestSerializableClass();
        deserialized.fromJson(null);

        expect(deserialized.name, isNull);
        expect(deserialized.age, isNull);
        expect(deserialized.isActive, isNull);
      });

      test('Invalid JSON input type', () {
        final deserialized = TestSerializableClass();
        deserialized.fromJson('invalid json string');

        expect(deserialized.name, isNull);
        expect(deserialized.age, isNull);
        expect(deserialized.isActive, isNull);
      });

      test('Missing fields in JSON', () {
        final json = {'name': 'Only Name'};
        final deserialized = TestSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.name, equals('Only Name'));
        expect(deserialized.age, isNull);
        expect(deserialized.isActive, isNull);
      });

      test('Extra fields in JSON', () {
        final json = {
          'name': 'John Doe',
          'age': 30,
          'isActive': true,
          'extraField': 'This should be ignored',
          'anotherExtra': 123,
        };

        final deserialized = TestSerializableClass();
        deserialized.fromJson(json);

        expect(deserialized.name, equals('John Doe'));
        expect(deserialized.age, equals(30));
        expect(deserialized.isActive, isTrue);
        // Extra fields should not cause errors
      });
    });

    group('Performance Tests', () {
      test('Large data serialization', () {
        final largeList = List.generate(
            1000,
            (index) => TestSerializableClass(
                  name: 'Item $index',
                  age: index,
                  isActive: index % 2 == 0,
                ));

        final stopwatch = Stopwatch()..start();
        final json = largeList.map((item) => item.toJson()).toList();
        stopwatch.stop();
        final serializationMs = stopwatch.elapsedMilliseconds;

        expect(json.length, equals(1000));
        expect(
            serializationMs, lessThan(10)); // Should complete within 1 second

        // Test deserialization
        stopwatch
          ..reset()
          ..start();
        final deserialized = largeList.map((item) {
          final newItem = TestSerializableClass();
          newItem.fromJson(item.toJson());
          return newItem;
        }).toList();
        stopwatch.stop();
        final deserializationMs = stopwatch.elapsedMilliseconds;

        expect(deserialized.length, equals(1000));
        expect(deserializationMs, lessThan(10));

        // Log timings for inspection
        // ignore: avoid_print
        print(
          'JsonSerializable Large data - '
          'serialization: ${serializationMs}ms, '
          'deserialization: ${deserializationMs}ms',
        );
      });

      test('Deep nesting performance', () {
        // Create a deeply nested structure
        var currentLevel = TestNestedSerializableClass();
        for (int i = 0; i < 20; i++) {
          final nextLevel = TestNestedSerializableClass();
          currentLevel.nestedObject = TestSerializableClass(
            name: 'Level $i',
            age: i,
            isActive: i % 2 == 0,
          );
          currentLevel = nextLevel;
        }

        final stopwatch = Stopwatch()..start();
        currentLevel.toString();
        stopwatch.stop();
        final elapsedMs = stopwatch.elapsedMilliseconds;

        expect(elapsedMs, lessThan(5));

        // ignore: avoid_print
        print(
          'JsonSerializable Deep nesting toString: ${elapsedMs}ms',
        );
      });
    });
  });
}
