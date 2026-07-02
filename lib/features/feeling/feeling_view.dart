import 'package:flutter/material.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/pause_tap_surface.dart';
import 'package:mobile/core/widgets/pause_text_link.dart';
import 'package:stacked/stacked.dart';

import 'feeling_viewmodel.dart';

/// Feeling: one-tap naming of what's underneath the urge. Renders all six
/// feelings (the enum has six, including "Something else").
class FeelingView extends StackedView<FeelingViewModel> {
  const FeelingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    FeelingViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PauseTextLink(
                text: '← back',
                onTap: viewModel.back,
                color: faint,
                pressedColor: muted,
                fontSize: 13,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's underneath",
                      style: PauseTextStyles.title(fontSize: 26, color: text),
                    ),
                    Text(
                      'this, right now?',
                      style: PauseTextStyles.title(fontSize: 26, color: text),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'One tap. The noticing is the work — not the answer.',
                      style: PauseTextStyles.body(color: muted, fontSize: 13),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final feeling in viewModel.feelings)
                          PauseTapSurface(
                            isDark: isDark,
                            onTap: () => viewModel.choose(feeling),
                            child: Text(
                              feeling.label,
                              style: PauseTextStyles.label(color: text),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
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
