import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/data/database/app_database.dart';
import 'package:mobile/features/progress/progress_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('ProgressViewModel -', () {
    late MockDatabaseService database;
    late MockSettingsService settings;

    setUp(() {
      registerServices();
      database = getAndRegisterDatabaseService();
      settings = getAndRegisterSettingsService();
    });
    tearDown(() => locator.reset());

    test('showReofferCard is true when hasInsights, not enabled, and not dismissed', () async {
      when(settings.invitesEnabled).thenReturn(false);
      when(settings.inviteOfferDismissed).thenReturn(false);
      
      when(database.allEvents()).thenAnswer((_) async => List.generate(5, (i) => UrgeEvent(
        id: i,
        createdAt: DateTime.now(),
        feeling: Feeling.bored.label,
        outcome: UrgeOutcome.passed.value,
      )));

      final viewModel = ProgressViewModel();
      await viewModel.load();

      expect(viewModel.showReofferCard, isTrue);
    });

    test('showReofferCard is false when invites enabled', () async {
      when(settings.invitesEnabled).thenReturn(true);
      when(settings.inviteOfferDismissed).thenReturn(false);
      
      when(database.allEvents()).thenAnswer((_) async => List.generate(5, (i) => UrgeEvent(
        id: i,
        createdAt: DateTime.now(),
        feeling: Feeling.bored.label,
        outcome: UrgeOutcome.passed.value,
      )));

      final viewModel = ProgressViewModel();
      await viewModel.load();

      expect(viewModel.showReofferCard, isFalse);
    });

    test('showReofferCard is false when dismissed', () async {
      when(settings.invitesEnabled).thenReturn(false);
      when(settings.inviteOfferDismissed).thenReturn(true);
      
      when(database.allEvents()).thenAnswer((_) async => List.generate(5, (i) => UrgeEvent(
        id: i,
        createdAt: DateTime.now(),
        feeling: Feeling.bored.label,
        outcome: UrgeOutcome.passed.value,
      )));

      final viewModel = ProgressViewModel();
      await viewModel.load();

      expect(viewModel.showReofferCard, isFalse);
    });
  });
}
