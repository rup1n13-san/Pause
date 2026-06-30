import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'offramp_viewmodel.dart';

// Slice 0 placeholder: pick a substitute action.
class OfframpView extends StackedView<OfframpViewModel> {
  const OfframpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OfframpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('What will you do instead?')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            for (final substitute in viewModel.substitutes)
              ListTile(
                title: Text(substitute),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => viewModel.pick(substitute),
              ),
          ],
        ),
      ),
    );
  }

  @override
  OfframpViewModel viewModelBuilder(BuildContext context) => OfframpViewModel();
}
