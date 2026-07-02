import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:mobile/features/resolution/resolution_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('ResolutionViewModel eventCount -', () {
    late MockDatabaseService database;

    setUp(() {
      registerServices();
      database = getAndRegisterDatabaseService();
      locator.registerSingleton<RitualSessionService>(
        RitualSessionService()
          ..feeling = Feeling.bored
          ..substitute = 'Walk',
      );
    });
    tearDown(() => locator.reset());

    test('is null before an outcome is chosen', () {
      final viewModel = ResolutionViewModel();
      expect(viewModel.eventCount, isNull);
      expect(viewModel.repCountLabel, isNull);
    });

    test('resolveYes populates eventCount from the database', () async {
      when(database.eventCount()).thenAnswer((_) async => 5);

      final viewModel = ResolutionViewModel();
      await viewModel.resolveYes();

      expect(viewModel.stage, ResolutionStage.passed);
      expect(viewModel.eventCount, 5);
    });

    test('resolveNotYet also populates eventCount', () async {
      when(database.eventCount()).thenAnswer((_) async => 3);

      final viewModel = ResolutionViewModel();
      await viewModel.resolveNotYet();

      expect(viewModel.stage, ResolutionStage.notYet);
      expect(viewModel.eventCount, 3);
    });

    test('repCountLabel is singular at exactly one rep', () async {
      when(database.eventCount()).thenAnswer((_) async => 1);

      final viewModel = ResolutionViewModel();
      await viewModel.resolveYes();

      expect(viewModel.repCountLabel, "1 time you've shown up");
    });

    test('repCountLabel is plural above one rep', () async {
      when(database.eventCount()).thenAnswer((_) async => 4);

      final viewModel = ResolutionViewModel();
      await viewModel.resolveYes();

      expect(viewModel.repCountLabel, "4 times you've shown up");
    });
  });
}
