import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'breath_viewmodel.dart';

class BreathView extends StackedView<BreathViewModel> {
  const BreathView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BreathViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Breath ritual', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              const Text('(4-7-8 showpiece — Slice 1)'),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: viewModel.continueToOfframp,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BreathViewModel viewModelBuilder(BuildContext context) => BreathViewModel();
}
