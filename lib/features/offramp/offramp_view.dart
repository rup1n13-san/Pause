import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/pause_tap_surface.dart';
import 'package:stacked/stacked.dart';

import 'offramp_viewmodel.dart';

/// Off-ramp: choose the substitute action. No back link by design — the system
/// back gesture still works. The list is data-driven (user's substitutes), so
/// it scrolls lazily via ListView.builder.
class OfframpView extends StackedView<OfframpViewModel> {
  const OfframpView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OfframpViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;
    final substitutes = viewModel.substitutes;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Now — what will',
                style: PauseTextStyles.title(fontSize: 26, color: text),
              ),
              Text(
                'you do instead?',
                style: PauseTextStyles.title(fontSize: 26, color: text),
              ),
              const SizedBox(height: 12),
              Text(
                'Your choice. An upgrade, not a consolation prize.',
                style: PauseTextStyles.body(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: substitutes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final substitute = substitutes[index];
                    return PauseTapSurface(
                      isDark: isDark,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 18,
                      ),
                      onTap: () => viewModel.pick(substitute),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              substitute,
                              style: PauseTextStyles.label(
                                color: text,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '→',
                            style: TextStyle(fontSize: 18, color: faint),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  OfframpViewModel viewModelBuilder(BuildContext context) => OfframpViewModel();
}
