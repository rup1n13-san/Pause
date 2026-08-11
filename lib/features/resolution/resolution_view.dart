import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/home/widgets/pulsing_orb.dart';
import 'package:stacked/stacked.dart';

import 'resolution_viewmodel.dart';

/// Resolution: ask, then one of two warm, shame-free outcomes. Both write an
/// event (a "rep"). The "Not yet" copy is deliberately the largest, warmest
/// headline — never a punishment.
class ResolutionView extends StackedView<ResolutionViewModel> {
  const ResolutionView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ResolutionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: _stageBody(context, viewModel)),
        ),
      ),
    );
  }

  Widget _stageBody(BuildContext context, ResolutionViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;

    switch (viewModel.stage) {
      case ResolutionStage.ask:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did the urge pass?',
              textAlign: TextAlign.center,
              style: PauseTextStyles.title(fontSize: 28, color: text),
            ),
            const SizedBox(height: 12),
            Text(
              'However you answer, you already showed up.',
              textAlign: TextAlign.center,
              style: PauseTextStyles.body(color: muted, fontSize: 13),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: viewModel.resolveYes,
                child: const Text('Yes — it eased'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: viewModel.resolveNotYet,
                child: const Text('Not yet'),
              ),
            ),
          ],
        );
      case ResolutionStage.passed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PulsingOrb(
              outerSize: 120,
              innerSize: 64,
              period: const Duration(seconds: 4),
              orbA: isDark ? PauseColors.orbA : PauseColors.lightOrbA,
              orbB: isDark ? PauseColors.orbB : PauseColors.lightOrbB,
              glow: isDark ? PauseColors.glow : PauseColors.lightGlow,
            ),
            const SizedBox(height: 28),
            Text(
              "That's a rep banked.",
              textAlign: TextAlign.center,
              style: PauseTextStyles.title(fontSize: 27, color: text),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Text(
                'You felt the pull, and you chose. Quietly, genuinely — '
                'well done.',
                textAlign: TextAlign.center,
                style: PauseTextStyles.body(color: muted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.repCountLabel ?? '…',
              style: PauseTextStyles.meta(color: faint),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: viewModel.goHome,
                child: const Text('Done'),
              ),
            ),
          ],
        );
      case ResolutionStage.notYet:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "That's okay.",
              textAlign: TextAlign.center,
              style: PauseTextStyles.title(fontSize: 30, color: text),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 252),
              child: Text(
                'Showing up is the rep that counts — and you showed up. The '
                "urge passing isn't the test. You are not behind.",
                textAlign: TextAlign.center,
                style: PauseTextStyles.body(color: muted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: viewModel.breatheAgain,
                child: const Text('Breathe again'),
              ),
            ),
            const SizedBox(height: 11),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: viewModel.goHome,
                child: const Text("That's enough for now"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'logged as a rep, either way',
              style: PauseTextStyles.meta(color: faint),
            ),
          ],
        );
    }
  }

  @override
  ResolutionViewModel viewModelBuilder(BuildContext context) =>
      ResolutionViewModel();
}
