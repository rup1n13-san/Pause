import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:mobile/features/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('HomeViewModel -', () {
    late RitualSessionService session;

    setUp(() {
      registerServices();
      session = RitualSessionService()
        ..feeling = Feeling.bored
        ..substitute = 'Walk';
      locator.registerSingleton<RitualSessionService>(session);
    });
    tearDown(() => locator.reset());

    test('beginFlow clears any leftover state from a previous run', () {
      HomeViewModel().beginFlow();
      expect(session.feeling, isNull);
      expect(session.substitute, isNull);
    });
  });
}
