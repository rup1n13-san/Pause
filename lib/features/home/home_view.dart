import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

// Slice 0 placeholder: navigation + flow entry only. Styled to the design in Slice 2.
class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: viewModel.openProgress,
                  child: const Text('patterns →'),
                ),
              ),
              const Spacer(),
              const Text('pause.', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: viewModel.beginFlow,
                child: const Text("I'm feeling the urge"),
              ),
              const Spacer(),
              TextButton(
                onPressed: viewModel.openSubstitutes,
                child: const Text('your substitutes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
