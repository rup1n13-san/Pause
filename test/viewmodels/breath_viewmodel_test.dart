import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/features/breath/breath_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BreathViewModel phase sequence -', () {
    const phases = BreathViewModel.phases;

    test('runs Settle in → 3 cycles → Softly done in order', () {
      final types = phases.map((p) => p.type).toList();
      expect(types, [
        BreathPhaseType.settle,
        BreathPhaseType.breatheIn,
        BreathPhaseType.hold,
        BreathPhaseType.breatheOut,
        BreathPhaseType.breatheIn,
        BreathPhaseType.hold,
        BreathPhaseType.breatheOut,
        BreathPhaseType.breatheIn,
        BreathPhaseType.hold,
        BreathPhaseType.breatheOut,
        BreathPhaseType.done,
      ]);
    });

    test('has exactly 3 breath cycles', () {
      expect(BreathViewModel.cycleCount, 3);
      expect(
        phases.where((p) => p.type == BreathPhaseType.breatheOut).length,
        3,
      );
    });

    test('phase durations match the 4-7-8 spec', () {
      final ins = phases.where((p) => p.type == BreathPhaseType.breatheIn);
      final holds = phases.where((p) => p.type == BreathPhaseType.hold);
      final outs = phases.where((p) => p.type == BreathPhaseType.breatheOut);

      expect(
          ins.every((p) => p.duration == const Duration(seconds: 4)), isTrue);
      expect(
          holds.every((p) => p.duration == const Duration(seconds: 7)), isTrue);
      expect(
          outs.every((p) => p.duration == const Duration(seconds: 8)), isTrue);
    });

    test('settle and done have the spec scales and durations', () {
      final settle = phases.first;
      final done = phases.last;

      expect(settle.type, BreathPhaseType.settle);
      expect(settle.duration, const Duration(milliseconds: 1800));
      expect(settle.targetScale, 0.6);

      expect(done.type, BreathPhaseType.done);
      expect(done.duration, const Duration(milliseconds: 2200));
      expect(done.targetScale, 0.8);
    });

    test('a Hold does not move the orb (zero-length animation)', () {
      for (final hold in phases.where((p) => p.type == BreathPhaseType.hold)) {
        expect(hold.animationDuration, Duration.zero);
        expect(hold.targetScale, 1.0);
      }
    });

    test('total duration sits inside the 60–90s product window', () {
      final total = BreathViewModel.totalDuration;
      expect(total, const Duration(milliseconds: 61000));
      expect(total.inSeconds, greaterThanOrEqualTo(60));
      expect(total.inSeconds, lessThanOrEqualTo(90));
    });
  });

  group('BreathViewModel countdown badge -', () {
    setUp(registerServices);
    tearDown(() => locator.reset());

    test('is null during Settle in, then counts each active phase down to 1',
        () {
      fakeAsync((async) {
        final viewModel = BreathViewModel();
        viewModel.start();

        // Settle in: nothing to count down.
        expect(viewModel.countdownSeconds, isNull);

        // Settle in (1800ms) elapses → Breathe in starts at 4.
        async.elapse(const Duration(milliseconds: 1800));
        expect(viewModel.currentPhase.type, BreathPhaseType.breatheIn);
        expect(viewModel.countdownSeconds, 4);

        async.elapse(const Duration(seconds: 1));
        expect(viewModel.countdownSeconds, 3);
        async.elapse(const Duration(seconds: 1));
        expect(viewModel.countdownSeconds, 2);
        async.elapse(const Duration(seconds: 1));
        expect(viewModel.countdownSeconds, 1);

        // The 4th second elapses → Breathe in ends, Hold starts at 7. The
        // badge must never have visibly shown 0.
        async.elapse(const Duration(seconds: 1));
        expect(viewModel.currentPhase.type, BreathPhaseType.hold);
        expect(viewModel.countdownSeconds, 7);

        // Hold ticks 7 → 1 over 6s, then the 7th second hands off to
        // Breathe out at 8.
        async.elapse(const Duration(seconds: 6));
        expect(viewModel.countdownSeconds, 1);
        async.elapse(const Duration(seconds: 1));
        expect(viewModel.currentPhase.type, BreathPhaseType.breatheOut);
        expect(viewModel.countdownSeconds, 8);

        viewModel.dispose();
      });
    });

    test('is null again once Softly done is reached', () {
      fakeAsync((async) {
        final viewModel = BreathViewModel();
        viewModel.start();

        async.elapse(
          BreathViewModel.totalDuration - const Duration(milliseconds: 2200),
        );
        expect(viewModel.currentPhase.type, BreathPhaseType.done);
        expect(viewModel.countdownSeconds, isNull);

        viewModel.dispose();
      });
    });
  });
}
