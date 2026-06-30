import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'resolution_viewmodel.dart';

// Slice 0 placeholder: ask + two warm, shame-free outcomes. Both write an event.
class ResolutionView extends StackedView<ResolutionViewModel> {
  const ResolutionView({Key? key}) : super(key: key);

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
          child: Center(child: _stageBody(viewModel)),
        ),
      ),
    );
  }

  Widget _stageBody(ResolutionViewModel viewModel) {
    switch (viewModel.stage) {
      case ResolutionStage.ask:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Did the urge pass?', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: viewModel.resolveYes,
              child: const Text('Yes — it eased'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: viewModel.resolveNotYet,
              child: const Text('Not yet'),
            ),
          ],
        );
      case ResolutionStage.passed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("That's a rep banked.", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: viewModel.goHome,
              child: const Text('Done'),
            ),
          ],
        );
      case ResolutionStage.notYet:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("That's okay.", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('Showing up is the rep that counts.'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: viewModel.breatheAgain,
              child: const Text('Breathe again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: viewModel.goHome,
              child: const Text("That's enough for now"),
            ),
          ],
        );
    }
  }

  @override
  ResolutionViewModel viewModelBuilder(BuildContext context) =>
      ResolutionViewModel();
}
