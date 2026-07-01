import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// The kind of phase — drives haptics and cycle-dot bookkeeping.
enum BreathPhaseType { settle, breatheIn, hold, breatheOut, done }

/// One step of the 4-7-8 ritual. Pure data: no timers, no locator — so the
/// whole sequence can be unit-tested without waiting on real clocks.
///
/// [duration] is how long this phase lasts before the next begins.
/// [targetScale] / [animationDuration] / [curve] drive the orb: the orb tweens
/// its scale to [targetScale] over [animationDuration] using [curve]. A "Hold"
/// keeps the previous scale with a zero-length animation (no movement).
class BreathPhase {
  const BreathPhase({
    required this.type,
    required this.label,
    required this.duration,
    required this.targetScale,
    required this.animationDuration,
    required this.curve,
    this.completesCycle = false,
  });

  final BreathPhaseType type;
  final String label;
  final Duration duration;
  final double targetScale;
  final Duration animationDuration;
  final Curve curve;

  /// True when reaching the END of this phase completes one full breath cycle
  /// (i.e. it is the "Breathe out" of a cycle) — used to light the next dot.
  final bool completesCycle;
}

/// Drives the un-skippable box-breathing ritual. The phase machine is a fixed,
/// non-configurable sequence (Settle in → 3 × [Breathe in · Hold · Breathe out]
/// → Softly done). There is deliberately NO way to skip ahead: [continueToOfframp]
/// is only meant to be reached once [isComplete] is true.
class BreathViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  /// Easing for the in/out breaths — matches the design prototype exactly.
  static const Curve _breathCurve = Cubic(0.37, 0, 0.45, 1);

  /// The full ritual, written out explicitly so it reads like the spec and can
  /// be asserted in a unit test. ~61s total, inside the 60–90s product window.
  static const List<BreathPhase> phases = [
    BreathPhase(
      type: BreathPhaseType.settle,
      label: 'Settle in',
      duration: Duration(milliseconds: 1800),
      targetScale: 0.6,
      animationDuration: Duration(milliseconds: 1700),
      curve: Curves.easeInOut,
    ),
    // Cycle 1
    BreathPhase(
      type: BreathPhaseType.breatheIn,
      label: 'Breathe in',
      duration: Duration(milliseconds: 4000),
      targetScale: 1.0,
      animationDuration: Duration(milliseconds: 4000),
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.hold,
      label: 'Hold',
      duration: Duration(milliseconds: 7000),
      targetScale: 1.0,
      animationDuration: Duration.zero,
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.breatheOut,
      label: 'Breathe out',
      duration: Duration(milliseconds: 8000),
      targetScale: 0.58,
      animationDuration: Duration(milliseconds: 8000),
      curve: _breathCurve,
      completesCycle: true,
    ),
    // Cycle 2
    BreathPhase(
      type: BreathPhaseType.breatheIn,
      label: 'Breathe in',
      duration: Duration(milliseconds: 4000),
      targetScale: 1.0,
      animationDuration: Duration(milliseconds: 4000),
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.hold,
      label: 'Hold',
      duration: Duration(milliseconds: 7000),
      targetScale: 1.0,
      animationDuration: Duration.zero,
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.breatheOut,
      label: 'Breathe out',
      duration: Duration(milliseconds: 8000),
      targetScale: 0.58,
      animationDuration: Duration(milliseconds: 8000),
      curve: _breathCurve,
      completesCycle: true,
    ),
    // Cycle 3
    BreathPhase(
      type: BreathPhaseType.breatheIn,
      label: 'Breathe in',
      duration: Duration(milliseconds: 4000),
      targetScale: 1.0,
      animationDuration: Duration(milliseconds: 4000),
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.hold,
      label: 'Hold',
      duration: Duration(milliseconds: 7000),
      targetScale: 1.0,
      animationDuration: Duration.zero,
      curve: _breathCurve,
    ),
    BreathPhase(
      type: BreathPhaseType.breatheOut,
      label: 'Breathe out',
      duration: Duration(milliseconds: 8000),
      targetScale: 0.58,
      animationDuration: Duration(milliseconds: 8000),
      curve: _breathCurve,
      completesCycle: true,
    ),
    BreathPhase(
      type: BreathPhaseType.done,
      label: 'Softly done',
      duration: Duration(milliseconds: 2200),
      targetScale: 0.8,
      animationDuration: Duration(milliseconds: 2200),
      curve: Curves.easeInOut,
    ),
  ];

  /// Number of full breath cycles in the ritual (fixed — not user-configurable).
  static int get cycleCount =>
      phases.where((p) => p.completesCycle).length;

  /// Sum of every phase — used by the test to prove we sit in the 60–90s window.
  static Duration get totalDuration => phases.fold(
        Duration.zero,
        (sum, p) => sum + p.duration,
      );

  Timer? _timer;
  int _index = 0;
  int _completedCycles = 0;
  bool _started = false;

  BreathPhase get currentPhase => phases[_index];

  /// Dots to light: dot `i` is lit when `i < completedCycles`.
  int get completedCycles => _completedCycles;

  int get totalCycles => cycleCount;

  bool get isComplete => currentPhase.type == BreathPhaseType.done;

  /// Starts the ritual. Idempotent — calling twice does not restart it.
  void start() {
    if (_started) return;
    _started = true;
    _index = 0;
    _enterPhase();
  }

  void _enterPhase() {
    final phase = phases[_index];

    // Haptic at every phase boundary except the very first entry (Settle in).
    // "Hold" firing here is the transition INTO the hold, not during it.
    if (_index != 0) {
      HapticFeedback.lightImpact();
    }

    notifyListeners();

    _timer = Timer(phase.duration, () {
      if (phase.completesCycle) {
        _completedCycles++;
      }
      if (_index < phases.length - 1) {
        _index++;
        _enterPhase();
      }
    });
  }

  /// Only meaningful once [isComplete] is true — the completion "Continue"
  /// button is the sole control the ritual ever exposes.
  void continueToOfframp() => _navigationService.navigateToOfframpView();

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
