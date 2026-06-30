import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'progress_viewmodel.dart';

// Slice 0 placeholder: reads the real event count from Drift.
class ProgressView extends StackedView<ProgressViewModel> {
  const ProgressView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProgressViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: viewModel.goHome),
        title: const Text("What you're noticing"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You've shown up"),
              Text(
                '${viewModel.showedUpCount}',
                style: const TextStyle(fontSize: 44),
              ),
              const Text('times'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(ProgressViewModel viewModel) => viewModel.load();

  @override
  ProgressViewModel viewModelBuilder(BuildContext context) =>
      ProgressViewModel();
}
