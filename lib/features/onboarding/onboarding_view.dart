import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_viewmodel.dart';

// Slice 0 placeholder for first-run setup.
class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Before we begin', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              const Text('Everything stays on this phone.'),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: viewModel.finishSetup,
                child: const Text("I'm ready"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  OnboardingViewModel viewModelBuilder(BuildContext context) =>
      OnboardingViewModel();
}
