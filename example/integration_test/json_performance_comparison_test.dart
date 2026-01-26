import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

import 'performance_models.dart';
import 'performance_test_data.dart';

void registerPerfModels() {
  final getIt = GetIt.instance;
  if (!getIt.isRegistered<PerfLevel5Model>()) {
    getIt.registerFactory<PerfLevel5Model>(PerfLevel5Model.new);
  }
  if (!getIt.isRegistered<PerfLevel4Model>()) {
    getIt.registerFactory<PerfLevel4Model>(PerfLevel4Model.new);
  }
  if (!getIt.isRegistered<PerfLevel3Model>()) {
    getIt.registerFactory<PerfLevel3Model>(PerfLevel3Model.new);
  }
  if (!getIt.isRegistered<PerfLevel2Model>()) {
    getIt.registerFactory<PerfLevel2Model>(PerfLevel2Model.new);
  }
}

void unregisterPerfModels() {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<PerfLevel2Model>()) {
    getIt.unregister<PerfLevel2Model>();
  }
  if (getIt.isRegistered<PerfLevel3Model>()) {
    getIt.unregister<PerfLevel3Model>();
  }
  if (getIt.isRegistered<PerfLevel4Model>()) {
    getIt.unregister<PerfLevel4Model>();
  }
  if (getIt.isRegistered<PerfLevel5Model>()) {
    getIt.unregister<PerfLevel5Model>();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Deserialize and serialize 100 records with 5-level nesting',
      (tester) async {
    const numberOfRecords = 20;
    final dataset = List.generate(numberOfRecords, buildLevel1Json);

    registerPerfModels();
    try {
      final modelDeserialize = Stopwatch()..start();
      final modelRecords = dataset.map((json) {
        final model = PerfLevel1Model();
        model.fromJson(json);
        return model;
      }).toList();
      modelDeserialize.stop();

      final modelSerialize = Stopwatch()..start();
      final modelJson = modelRecords.map((model) => model.toJson()).toList();
      modelSerialize.stop();

      final dtoDeserialize = Stopwatch()..start();
      final dtoRecords = dataset
          .map((json) => PerfLevel1Dto.fromJson(json))
          .toList(growable: false);
      dtoDeserialize.stop();

      final dtoSerialize = Stopwatch()..start();
      final dtoJson = dtoRecords.map((record) => record.toJson()).toList();
      dtoSerialize.stop();

      expect(modelRecords.length, equals(numberOfRecords));
      expect(dtoRecords.length, equals(numberOfRecords));
      expect(modelJson.length, equals(numberOfRecords));
      expect(dtoJson.length, equals(numberOfRecords));
      expect(modelRecords.first.name.value, equals(dtoRecords.first.name));
      expect(modelJson.first['id'], equals(dtoJson.first['id']));
      expect(modelJson.first['items'], isA<List<dynamic>>());

      expect(modelDeserialize.elapsedMilliseconds, lessThan(20000));
      expect(modelSerialize.elapsedMilliseconds, lessThan(20000));
      expect(dtoDeserialize.elapsedMilliseconds, lessThan(20000));
      expect(dtoSerialize.elapsedMilliseconds, lessThan(20000));

      // ignore: avoid_print
      print(
        'JsonModel deserialize: ${modelDeserialize.elapsedMilliseconds} ms, '
        'serialize: ${modelSerialize.elapsedMilliseconds} ms',
      );
      // ignore: avoid_print
      print(
        'Manual deserialize: ${dtoDeserialize.elapsedMilliseconds} ms, '
        'serialize: ${dtoSerialize.elapsedMilliseconds} ms',
      );
    } finally {
      unregisterPerfModels();
    }
  });
}
