import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:stacked/stacked.dart';

import 'breath_viewmodel.dart';
import 'widgets/breath_orb.dart';
import 'widgets/sliding_countdown_number.dart';

/// The un-skippable box-breathing ritual (Slice 1 showpiece).
///
/// There is intentionally NO skip / back / dismiss control here. The only
/// interactive element is the "Continue" button, which fades in solely once the
/// ritual completes.
class BreathView extends StackedView<BreathViewModel> {
  const BreathView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BreathViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _OrbColors.of(isDark);
    final muted = (isDark ? PauseColors.text : PauseColors.lightText)
        .withValues(alpha: 0.5);
    final phase = viewModel.currentPhase;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopRow(
                muted: muted,
                litColor: isDark ? PauseColors.amber : PauseColors.lightAmber,
                unlitColor: muted.withValues(alpha: 0.3),
                total: viewModel.totalCycles,
                lit: viewModel.completedCycles,
                countdownSeconds: viewModel.countdownSeconds,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BreathOrb(
                      scale: phase.targetScale,
                      duration: phase.animationDuration,
                      curve: phase.curve,
                      orbA: colors.orbA,
                      orbB: colors.orbB,
                      glow: colors.glow,
                    ),
                    const SizedBox(height: 56),
                    Text(
                      phase.label,
                      style: TextStyle(
                        fontSize: 28,
                        color: isDark
                            ? PauseColors.text
                            : PauseColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
              // Completion area — fixed height so the layout does not jump when
              // it fades in. Non-interactive (and unreachable) until complete.
              SizedBox(
                height: 132,
                child: IgnorePointer(
                  ignoring: !viewModel.isComplete,
                  child: AnimatedOpacity(
                    opacity: viewModel.isComplete ? 1 : 0,
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'That\'s it. You made space.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: muted),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: viewModel.continueToOfframp,
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(BreathViewModel viewModel) => viewModel.start();

  @override
  BreathViewModel viewModelBuilder(BuildContext context) => BreathViewModel();
}

/// Top row: the "4 · 7 · 8" label (left) and the three cycle dots (right).
///
/// The label is static during Settle in / Softly done (no 4-7-8 duration to
/// count for those), and becomes a live per-second countdown of the active
/// phase — 4→1, 7→1, 8→1 — while a breath cycle is running.
class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.muted,
    required this.litColor,
    required this.unlitColor,
    required this.total,
    required this.lit,
    required this.countdownSeconds,
  });

  final Color muted;
  final Color litColor;
  final Color unlitColor;
  final int total;
  final int lit;
  final int? countdownSeconds;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 11,
      letterSpacing: 3,
      color: muted,
    );
    // Deliberately larger than the static label: a lone digit at 11px moving
    // over ~13px is too small a throw to read as a slide at a glance — this
    // gives the countdown enough size for the motion to actually register.
    final countdownStyle = TextStyle(fontSize: 15, color: muted);
    final seconds = countdownSeconds;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        seconds == null
            ? Text('4 · 7 · 8', style: labelStyle)
            : SlidingCountdownNumber(value: seconds, style: countdownStyle),
        Row(
          children: List.generate(total, (i) {
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < lit ? litColor : unlitColor,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Orb gradient tokens resolved for the current brightness.
class _OrbColors {
  const _OrbColors(this.orbA, this.orbB, this.glow);

  final Color orbA;
  final Color orbB;
  final Color glow;

  static _OrbColors of(bool isDark) => isDark
      ? const _OrbColors(PauseColors.orbA, PauseColors.orbB, PauseColors.glow)
      : const _OrbColors(
          PauseColors.lightOrbA,
          PauseColors.lightOrbB,
          PauseColors.lightGlow,
        );
}
