import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/pause_text_link.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import 'widgets/pulsing_orb.dart';

/// Home: the calm entry point. The pulsing orb is the single CTA (tap → begin
/// the flow). Once there's enough history, a quiet "noticed N× this week"
/// banner surfaces above the orb.
class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;
    final amber = isDark ? PauseColors.amber : PauseColors.lightAmber;
    final chipA = isDark ? PauseColors.chipA : PauseColors.lightChipA;

    final insights = viewModel.insights;
    final showBanner = insights != null && insights.hasInsights;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'pause.',
                    style: PauseTextStyles.title(fontSize: 18, color: muted),
                  ),
                  PauseTextLink(
                    text: 'patterns →',
                    onTap: viewModel.openProgress,
                    color: faint,
                    pressedColor: muted,
                    fontSize: 12,
                  ),
                ],
              ),
              const Spacer(),
              if (showBanner) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: chipA,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    insights.homeBanner,
                    style: PauseTextStyles.meta(color: amber),
                  ),
                ),
                const SizedBox(height: 26),
              ],
              PulsingOrb(
                outerSize: 198,
                innerSize: 116,
                orbA: isDark ? PauseColors.orbA : PauseColors.lightOrbA,
                orbB: isDark ? PauseColors.orbB : PauseColors.lightOrbB,
                glow: isDark ? PauseColors.glow : PauseColors.lightGlow,
                label: 'tap',
                labelColor: const Color(0xFF2A1D0E),
                onTap: viewModel.beginFlow,
              ),
              const SizedBox(height: 36),
              Text(
                'When the pull comes,',
                style: PauseTextStyles.title(fontSize: 18, color: text),
              ),
              Text(
                'reach for this.',
                style: PauseTextStyles.title(fontSize: 18, color: text),
              ),
              const Spacer(),
              PauseTextLink(
                text: 'your substitutes',
                onTap: viewModel.openSubstitutes,
                color: faint,
                pressedColor: muted,
                fontSize: 11.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.load();

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
