import 'package:flutter/material.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:stacked/stacked.dart';

import 'feeling_viewmodel.dart';

// Slice 0 placeholder: one-tap feeling chips.
class FeelingView extends StackedView<FeelingViewModel> {
  const FeelingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FeelingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: viewModel.back),
        title: const Text("What's underneath this?"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final feeling in viewModel.feelings)
                OutlinedButton(
                  onPressed: () => viewModel.choose(feeling),
                  child: Text(feeling.label),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FeelingViewModel viewModelBuilder(BuildContext context) => FeelingViewModel();
}
