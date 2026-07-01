import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:stacked/stacked.dart';

import 'breath_viewmodel.dart';
import 'widgets/breath_orb.dart';

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
class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.muted,
    required this.litColor,
    required this.unlitColor,
    required this.total,
    required this.lit,
  });

  final Color muted;
  final Color litColor;
  final Color unlitColor;
  final int total;
  final int lit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '4 · 7 · 8',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 3,
            color: muted,
          ),
        ),
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
