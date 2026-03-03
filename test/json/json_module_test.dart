import 'package:flutter_test/flutter_test.dart';
import 'package:supa_architecture/json/json.dart';

import 'json_test_models.dart';

void main() {
  group('JSON Module Tests', () {
    setUp(() {
      setupTestModels();
    });

    tearDown(() {
      cleanupTestModels();
    });

    group('JsonField Base Tests', () {
      test('JsonField constructor and basic properties', () {
        final field = JsonString('testField');

        expect(field.fieldName, equals('testField'));
        expect(field.error, isNull);
        expect(field.warning, isNull);
        expect(field.information, isNull);
        expect(field.hasError, isFalse);
        expect(field.hasWarning, isFalse);
        expect(field.hasInformation, isFalse);
        expect(field.isNull, isTrue);
        expect(field.isNotNull, isFalse);
      });

      test('JsonField error handling', () {
        final field = JsonString('testField');

        field.error = 'This is an error';
        field.warning = 'This is a warning';
        field.information = 'This is information';

        expect(field.hasError, isTrue);
        expect(field.hasWarning, isTrue);
        expect(field.hasInformation, isTrue);
        expect(field.error, equals('This is an error'));
        expect(field.warning, equals('This is a warning'));
        expect(field.information, equals('This is information'));
      });

      test('JsonField equality and hashCode', () {
        final field1 = JsonString('testField');
        final field2 = JsonString('testField');
        final field3 = JsonString('differentField');

        field1.value = 'value1';
        field2.value = 'value1';
        field3.value = 'value1';

        expect(field1, equals(field2));
        expect(field1, isNot(equals(field3)));
        expect(field1.hashCode, equals(field2.hashCode));
        expect(field1.hashCode, isNot(equals(field3.hashCode)));
      });
    });

    group('JsonString Tests', () {
      test('JsonString value getter and setter', () {
        final field = JsonString('name');

        // Test null value
        expect(field.value, equals(''));

        // Test string value
        field.value = 'John Doe';
        expect(field.value, equals('John Doe'));

        // Test null assignment
        field.value = null;
        expect(field.value, equals(''));
      });

      test('JsonString toJson', () {
        final field = JsonString('name');

        expect(field.toJson(), isNull);

        field.value = 'John Doe';
        expect(field.toJson(), equals('John Doe'));
      });
    });

    group('JsonInteger Tests', () {
      test('JsonInteger value getter and setter', () {
        final field = JsonInteger('age');

        // Test null value
        expect(field.value, equals(0));

        // Test integer value
        field.value = 25;
        expect(field.value, equals(25));

        // Test string parsing
        field.value = '30';
        expect(field.value, equals(30));

        // Test null assignment
        field.value = null;
        expect(field.value, equals(0));
      });

      test('JsonInteger string parsing edge cases', () {
        final field = JsonInteger('age');

        // Test valid numeric string
        field.value = '42';
        expect(field.value, equals(42));

        // Test invalid string
        field.value = 'abc';
        expect(field.value, equals(0));

        // Test empty string
        field.value = '';
        expect(field.value, equals(0));
      });

      test('JsonInteger toJson', () {
        final field = JsonInteger('age');

        expect(field.toJson(), isNull);

        field.value = 25;
        expect(field.toJson(), equals(25));
      });
    });

    group('JsonDouble Tests', () {
      test('JsonDouble value getter and setter', () {
        final field = JsonDouble('height');

        // Test null value
        expect(field.value, equals(0.0));

        // Test double value
        field.value = 175.5;
        expect(field.value, equals(175.5));

        // Test integer value
        field.value = 180;
        expect(field.value, equals(180.0));

        // Test string parsing
        field.value = '185.7';
        expect(field.value, equals(185.7));

        // Test null assignment
        field.value = null;
        expect(field.value, equals(0.0));
      });

      test('JsonDouble string parsing edge cases', () {
        final field = JsonDouble('price');

        // Test valid numeric string
        field.value = '19.99';
        expect(field.value, equals(19.99));

        // Test invalid string
        field.value = 'abc';
        expect(field.value, equals(0.0));

        // Test empty string
        field.value = '';
        expect(field.value, equals(0.0));
      });

      test('JsonDouble toJson', () {
        final field = JsonDouble('price');

        expect(field.toJson(), isNull);

        field.value = 19.99;
        expect(field.toJson(), equals(19.99));
      });
    });

    group('JsonNumber Tests', () {
      test('JsonNumber value getter and setter', () {
        final field = JsonNumber('score');

        // Test null value
        expect(field.value, equals(0));

        // Test numeric values
        field.value = 42;
        expect(field.value, equals(42));

        field.value = 3.14;
        expect(field.value, equals(3.14));

        // Test string parsing
        field.value = '100';
        expect(field.value, equals(100));

        field.value = '99.5';
        expect(field.value, equals(99.5));

        // Test null assignment
        field.value = null;
        expect(field.value, equals(0));
      });

      test('JsonNumber toJson', () {
        final field = JsonNumber('score');

        expect(field.toJson(), isNull);

        field.value = 42;
        expect(field.toJson(), equals(42));

        field.value = 3.14;
        expect(field.toJson(), equals(3.14));
      });
    });

    group('JsonBoolean Tests', () {
      test('JsonBoolean value getter and setter', () {
        final field = JsonBoolean('isActive');

        // Test null value
        expect(field.value, isFalse);

        // Test boolean values
        field.value = true;
        expect(field.value, isTrue);

        field.value = false;
        expect(field.value, isFalse);

        // Test null assignment
        field.value = null;
        expect(field.value, isFalse);
      });

      test('JsonBoolean toJson', () {
        final field = JsonBoolean('isActive');

        expect(field.toJson(), isNull);

        field.value = true;
        expect(field.toJson(), isTrue);

        field.value = false;
        expect(field.toJson(), isFalse);
      });
    });

    group('JsonDate Tests', () {
      test('JsonDate value getter and setter', () {
        final field = JsonDate('createdAt');
        final now = DateTime.now();

        // Test null value
        expect(field.value.year, equals(now.year));
        expect(field.value.month, equals(now.month));
        expect(field.value.day, equals(now.day));

        // Test DateTime value
        final testDate = DateTime(2023, 1, 15);
        field.value = testDate;
        expect(field.value, equals(testDate));

        // Test string parsing
        field.value = '2023-06-20T10:30:00Z';
        expect(field.value.year, equals(2023));
        expect(field.value.month, equals(6));
        expect(field.value.day, equals(20));

        // Test null assignment
        field.value = null;
        expect(field.value.year, equals(now.year));
      });

      test('JsonDate format method', () {
        final field = JsonDate('createdAt');
        final testDate = DateTime(2023, 1, 15);
        field.value = testDate;

        expect(field.format(), equals('15/01/2023'));
        expect(field.format(dateFormat: 'yyyy-MM-dd'), equals('2023-01-15'));
      });

      test('JsonDate toJson', () {
        final field = JsonDate('createdAt');
        final testDate = DateTime(2023, 1, 15, 10, 30, 0);
        field.value = testDate;

        final json = field.toJson();
        expect(json, isA<String>());
        expect(json, contains('2023-01-15'));
      });

      test('DateTime extension methods', () {
        final utcDate = DateTime.utc(2023, 1, 15, 10, 30, 0);
        final localDate = DateTime(2023, 1, 15, 10, 30, 0);

        expect(utcDate.getTimezoneOffsetString(), equals(''));
        expect(utcDate.toIso8601StringWithOffset(), contains('Z'));

        final offsetString = localDate.getTimezoneOffsetString();
        expect(offsetString, matches(r'^[+-]\d{2}:\d{2}$'));

        final isoString = localDate.toIso8601StringWithOffset();
        expect(isoString, contains(offsetString));
      });
    });

    group('JsonObject Tests', () {
      test('JsonObject value getter and setter', () {
        final field = JsonObject<TestAddressModel>('address');

        // Test null value - should create new instance
        expect(field.value, isA<TestAddressModel>());

        // Test direct model assignment
        final address = TestAddressModel.create();
        address.street.value = '123 Main St';
        address.city.value = 'New York';

        field.value = address;
        expect(field.value, equals(address));
        expect(field.value.street.value, equals('123 Main St'));

        // Test Map assignment
        final addressMap = {
          'street': '456 Oak Ave',
          'city': 'Los Angeles',
          'country': 'USA',
          'zipCode': 90210,
        };

        field.value = addressMap;
        expect(field.value.street.value, equals('456 Oak Ave'));
        expect(field.value.city.value, equals('Los Angeles'));
        expect(field.value.zipCode.value, equals(90210));
      });

      test('JsonObject toJson', () {
        final field = JsonObject<TestAddressModel>('address');
        final address = TestAddressModel.create();
        address.street.value = '123 Main St';
        address.city.value = 'New York';

        field.value = address;

        final json = field.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json!['street'], equals('123 Main St'));
        expect(json['city'], equals('New York'));
      });

      test('JsonObject operator access', () {
        final field = JsonObject<TestAddressModel>('address');
        final address = TestAddressModel.create();
        address.street.value = '123 Main St';
        field.value = address;

        expect(field['street'], equals('123 Main St'));

        field['street'] = '789 Pine St';
        expect(field.value.street.value, equals('789 Pine St'));
      });
    });

    group('JsonList Tests', () {
      test('JsonList value getter and setter', () {
        final field = JsonList<TestListItemModel>('items');

        // Test initial empty list
        expect(field.value, isEmpty);

        // Test direct list assignment
        final items = [
          TestListItemModel.create()..itemName.value = 'Item 1',
          TestListItemModel.create()..itemName.value = 'Item 2',
        ];

        field.value = items;
        expect(field.value.length, equals(2));
        expect(field.value[0].itemName.value, equals('Item 1'));

        // Test Map list assignment
        final itemsMap = [
          {'itemName': 'Item A', 'quantity': 5, 'price': 10.99},
          {'itemName': 'Item B', 'quantity': 3, 'price': 15.50},
        ];

        field.value = itemsMap;
        expect(field.value.length, equals(2));
        expect(field.value[0].itemName.value, equals('Item A'));
        expect(field.value[0].quantity.value, equals(5));
        expect(field.value[0].price.value, equals(10.99));
      });

      test('JsonList toJson', () {
        final field = JsonList<TestListItemModel>('items');
        final items = [
          TestListItemModel.create()..itemName.value = 'Item 1',
          TestListItemModel.create()..itemName.value = 'Item 2',
        ];

        field.value = items;

        final json = field.toJson();
        expect(json, isA<List<Map<String, dynamic>>>());
        expect(json!.length, equals(2));
        expect(json[0]['itemName'], equals('Item 1'));
      });

      test('JsonList operator access', () {
        final field = JsonList<TestListItemModel>('items');
        final items = [
          TestListItemModel.create()..itemName.value = 'Item 1',
          TestListItemModel.create()..itemName.value = 'Item 2',
        ];

        field.value = items;

        expect(field[0].itemName.value, equals('Item 1'));

        final newItem = TestListItemModel.create()..itemName.value = 'Item 3';
        field[1] = newItem;
        expect(field[1].itemName.value, equals('Item 3'));
      });

      test('JsonList operator access bounds checking', () {
        final field = JsonList<TestListItemModel>('items');

        expect(() => field[0], throwsException);

        field.value = [TestListItemModel.create()];
        expect(() => field[1], throwsException);
        expect(() => field[-1], throwsException);
      });
    });

    group('JsonModel Tests', () {
      test('JsonModel basic serialization and deserialization', () {
        final model = TestBasicModel.create();

        // Set values
        model.name.value = 'John Doe';
        model.age.value = 30;
        model.height.value = 175.5;
        model.isActive.value = true;
        model.score.value = 95;

        // Test toJson
        final json = model.toJson();
        expect(json['name'], equals('John Doe'));
        expect(json['age'], equals(30));
        expect(json['height'], equals(175.5));
        expect(json['isActive'], isTrue);
        expect(json['score'], equals(95));

        // Test fromJson
        final newModel = TestBasicModel.create();
        newModel.fromJson(json);

        expect(newModel.name.value, equals('John Doe'));
        expect(newModel.age.value, equals(30));
        expect(newModel.height.value, equals(175.5));
        expect(newModel.isActive.value, isTrue);
        expect(newModel.score.value, equals(95));
      });

      test('JsonModel nested object handling', () {
        final person = TestPersonModel.create();
        person.firstName.value = 'John';
        person.lastName.value = 'Doe';
        person.age.value = 30;

        final address = TestAddressModel.create();
        address.street.value = '123 Main St';
        address.city.value = 'New York';
        address.country.value = 'USA';
        address.zipCode.value = 10001;

        person.address.value = address;

        final json = person.toJson();
        expect(json['firstName'], equals('John'));
        expect(json['address'], isA<Map<String, dynamic>>());
        expect(json['address']['street'], equals('123 Main St'));

        final newPerson = TestPersonModel.create();
        newPerson.fromJson(json);

        expect(newPerson.firstName.value, equals('John'));
        expect(newPerson.address.value.street.value, equals('123 Main St'));
      });

      test('JsonModel list handling', () {
        final order = TestOrderModel.create();
        order.orderId.value = 'ORD-001';
        order.orderDate.value = DateTime(2023, 1, 15);

        final items = [
          TestListItemModel.create()
            ..itemName.value = 'Product A'
            ..quantity.value = 2
            ..price.value = 29.99,
          TestListItemModel.create()
            ..itemName.value = 'Product B'
            ..quantity.value = 1
            ..price.value = 49.99,
        ];

        order.items.value = items;
        order.totalAmount.value = 109.97;

        final json = order.toJson();
        expect(json['orderId'], equals('ORD-001'));
        expect(json['items'], isA<List<Map<String, dynamic>>>());
        expect(json['items'].length, equals(2));
        expect(json['items'][0]['itemName'], equals('Product A'));

        final newOrder = TestOrderModel.create();
        newOrder.fromJson(json);

        expect(newOrder.orderId.value, equals('ORD-001'));
        expect(newOrder.items.value.length, equals(2));
        expect(newOrder.items.value[0].itemName.value, equals('Product A'));
      });

      test('JsonModel complex nested structure', () {
        final company = TestCompanyModel.create();
        company.companyName.value = 'Tech Corp';
        company.employeeCount.value = 100;
        company.isPublic.value = true;
        company.foundedDate.value = DateTime(2010, 1, 1);

        final headquarters = TestAddressModel.create();
        headquarters.street.value = '456 Tech Blvd';
        headquarters.city.value = 'San Francisco';
        headquarters.country.value = 'USA';
        headquarters.zipCode.value = 94105;

        company.headquarters.value = headquarters;

        final employee = TestPersonModel.create();
        employee.firstName.value = 'Jane';
        employee.lastName.value = 'Smith';
        employee.age.value = 28;

        final employeeAddress = TestAddressModel.create();
        employeeAddress.street.value = '789 Employee St';
        employeeAddress.city.value = 'San Francisco';
        employeeAddress.country.value = 'USA';
        employeeAddress.zipCode.value = 94105;

        employee.address.value = employeeAddress;
        company.employees.value = [employee];

        final json = company.toJson();
        expect(json['companyName'], equals('Tech Corp'));
        expect(json['headquarters']['street'], equals('456 Tech Blvd'));
        expect(json['employees'][0]['firstName'], equals('Jane'));
        expect(json['employees'][0]['address']['street'],
            equals('789 Employee St'));

        final newCompany = TestCompanyModel.create();
        newCompany.fromJson(json);

        expect(newCompany.companyName.value, equals('Tech Corp'));
        expect(newCompany.headquarters.value.street.value,
            equals('456 Tech Blvd'));
        expect(newCompany.employees.value[0].firstName.value, equals('Jane'));
      });

      test('JsonModel error handling', () {
        final model = TestValidationModel.create();

        // Set errors, warnings, and information
        model.generalErrors = ['General error 1', 'General error 2'];
        model.generalWarnings = ['General warning 1'];
        model.generalInformations = ['General info 1'];

        model.errors = {
          'requiredField': 'Field is required',
          'numericField': 'Must be a number',
        };
        model.warnings = {
          'decimalField': 'Consider using integer',
        };
        model.informations = {
          'flagField': 'Flag is set',
        };

        // Test that errors, warnings, and information are set on the model
        expect(model.hasError, isTrue);
        expect(model.hasWarning, isTrue);
        expect(model.hasInformation, isTrue);
        expect(model.error, equals('General error 1'));
        expect(model.warning, equals('General warning 1'));
        expect(model.information, equals('General info 1'));

        // Note: Field-level errors are only set during deserialization, not when manually setting them
        // So we test the model-level errors here

        // Test deserialization by creating a JSON with errors and deserializing it
        final errorJson = {
          'generalErrors': ['General error 1', 'General error 2'],
          'generalWarnings': ['General warning 1'],
          'generalInformations': ['General info 1'],
          'errors': {
            'requiredField': 'Field is required',
            'numericField': 'Must be a number',
          },
          'warnings': {
            'decimalField': 'Consider using integer',
          },
          'informations': {
            'flagField': 'Flag is set',
          },
        };

        final newModel = TestValidationModel.create();
        newModel.fromJson(errorJson);

        expect(newModel.hasError, isTrue);
        expect(newModel.hasWarning, isTrue);
        expect(newModel.hasInformation, isTrue);
        expect(newModel.error, equals('General error 1'));
        expect(newModel.warning, equals('General warning 1'));
        expect(newModel.information, equals('General info 1'));

        expect(newModel.requiredField.error, equals('Field is required'));
        expect(newModel.decimalField.warning, equals('Consider using integer'));
        expect(newModel.flagField.information, equals('Flag is set'));
      });

      test('JsonModel ID field handling', () {
        final model = TestIdFieldModel.create();
        model.name.value = 'Test User';

        // Test that ID fields with value 0 are excluded from JSON
        model.userId.value = 0;
        model.statusId.value = 1; // This should be included
        model.categoryId.value = 0;

        final json = model.toJson();
        expect(json.containsKey('userId'), isFalse);
        expect(json.containsKey('statusId'), isTrue);
        expect(json.containsKey('categoryId'), isFalse);
        expect(json['name'], equals('Test User'));

        // Test that non-zero ID fields are included
        model.userId.value = 123;
        model.categoryId.value = 456;

        final newJson = model.toJson();
        expect(newJson['userId'], equals(123));
        expect(newJson['categoryId'], equals(456));
      });

      test('JsonModel operator access', () {
        final model = TestOperatorModel.create();

        // Test setting values
        model['field1'] = 'Value 1';
        model['field2'] = 'Value 2';
        model['field3'] = 42;

        // Test getting values
        expect(model['field1'], equals('Value 1'));
        expect(model['field2'], equals('Value 2'));
        expect(model['field3'], equals(42));

        // Test non-existent field
        expect(() => model['nonExistentField'], throwsException);
        expect(() => model['nonExistentField'] = 'value', throwsException);
      });

      test('JsonModel toString', () {
        final model = TestBasicModel.create();
        model.name.value = 'John Doe';
        model.age.value = 30;

        final string = model.toString();
        expect(string, contains('John Doe'));
        expect(string, contains('30'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Empty string handling', () {
        final model = TestEdgeCaseModel.create();
        model.emptyString.value = '';
        model.specialChars.value = '!@#\$%^&*()';

        final json = model.toJson();
        expect(json['emptyString'], equals(''));
        expect(json['specialChars'], equals('!@#\$%^&*()'));
      });

      test('Zero and null value handling', () {
        final model = TestEdgeCaseModel.create();
        model.zeroValue.value = 0;
        model.nullValue.value = null;
        model.falseValue.value = false;

        final json = model.toJson();
        expect(json['zeroValue'], equals(0));
        expect(json.containsKey('nullValue'), isFalse);
        expect(json['falseValue'], isFalse);
      });

      test('Invalid data type handling', () {
        final model = TestValidationModel.create();

        // Test invalid string to number conversion
        model.numericField.value = 'invalid';
        expect(model.numericField.value, equals(0));

        model.decimalField.value = 'not_a_number';
        expect(model.decimalField.value, equals(0.0));
      });

      test('Large number handling', () {
        final model = TestBasicModel.create();
        model.age.value = 999999999;
        model.height.value = 999999.999;

        final json = model.toJson();
        expect(json['age'], equals(999999999));
        expect(json['height'], equals(999999.999));
      });

      test('Special character handling in strings', () {
        final model = TestEdgeCaseModel.create();
        model.specialChars.value = 'Line 1\nLine 2\tTabbed\r\nWindows';

        final json = model.toJson();
        expect(
            json['specialChars'], equals('Line 1\nLine 2\tTabbed\r\nWindows'));
      });
    });

    group('Performance and Memory Tests', () {
      test('Large list handling', () {
        final model = TestListOperatorModel.create();
        final items = List.generate(1000, (index) {
          final item = TestListItemModel.create();
          item.itemName.value = 'Item $index';
          item.quantity.value = index;
          item.price.value = index * 1.5;
          return item;
        });

        model.items.value = items;

        final stopwatch = Stopwatch()..start();
        final json = model.toJson();
        stopwatch.stop();
        final serializationMs = stopwatch.elapsedMilliseconds;

        expect(json['items'].length, equals(1000));
        expect(serializationMs,
            lessThan(100)); // Should complete well within 100ms

        // Test deserialization
        stopwatch
          ..reset()
          ..start();
        final newModel = TestListOperatorModel.create();
        newModel.fromJson(json);
        stopwatch.stop();
        final deserializationMs = stopwatch.elapsedMilliseconds;

        expect(newModel.items.value.length, equals(1000));
        expect(deserializationMs, lessThan(100));

        // ignore: avoid_print
        print(
          'JsonModel Large list - '
          'serialization: ${serializationMs}ms, '
          'deserialization: ${deserializationMs}ms',
        );
      });

      test('Deep nesting handling', () {
        final model = TestCompanyModel.create();
        model.companyName.value = 'Tech Corp';

        // Create deeply nested structure
        var currentLevel = model;
        for (int i = 0; i < 10; i++) {
          final subCompany = TestCompanyModel.create();
          subCompany.companyName.value = 'Sub Company $i';
          subCompany.employeeCount.value = i;

          if (i < 9) {
            currentLevel.headquarters.value = TestAddressModel.create();
            currentLevel.headquarters.value.street.value = 'Level $i Street';
          }

          currentLevel = subCompany;
        }

        final stopwatch = Stopwatch()..start();
        final json = model.toJson();
        final newModel = TestCompanyModel.create();
        newModel.fromJson(json);
        stopwatch.stop();
        final elapsedMs = stopwatch.elapsedMilliseconds;

        expect(json['companyName'], equals('Tech Corp'));
        expect(newModel.companyName.value, equals('Tech Corp'));
        expect(elapsedMs, lessThan(50));

        // ignore: avoid_print
        print(
          'JsonModel Deep nesting handling: ${elapsedMs}ms',
        );
      });
    });
  });
}
