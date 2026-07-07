import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/pause_tap_surface.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_viewmodel.dart';

/// First-run setup (also the "your substitutes" editor): pick the actions
/// you'll reach for instead, and optionally note — privately — what you're
/// stepping back from.
class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;
    final chip = isDark ? PauseColors.chip : PauseColors.lightChip;
    final line = isDark ? PauseColors.line : PauseColors.lightLine;
    final amber = isDark ? PauseColors.amber : PauseColors.lightAmber;

    final sectionHeading = TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w600,
      fontSize: 12.5,
      letterSpacing: 0.2,
      color: text,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Before we begin',
                style: PauseTextStyles.title(fontSize: 27, color: text),
              ),
              const SizedBox(height: 10),
              Text(
                'Two quick things. Everything stays on this phone — nothing '
                'ever leaves it.',
                style: PauseTextStyles.body(color: muted, fontSize: 13.5),
              ),
              const SizedBox(height: 30),
              Text('What will you reach for instead?', style: sectionHeading),
              const SizedBox(height: 6),
              Text(
                'Pick a few. You can change these any time.',
                style: PauseTextStyles.body(color: faint, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  for (final substitute in viewModel.presets)
                    PauseTapSurface(
                      isDark: isDark,
                      selected: viewModel.isSelected(substitute),
                      onTap: () => viewModel.toggle(substitute),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 11,
                      ),
                      child: Text(
                        substitute,
                        style: PauseTextStyles.label(color: text, fontSize: 14),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Text('What are you stepping back from?', style: sectionHeading),
              const SizedBox(height: 6),
              Text(
                'Optional, and private — just a word for yourself.',
                style: PauseTextStyles.body(color: faint, fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: viewModel.noteController,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: text,
                ),
                cursorColor:
                    isDark ? PauseColors.amber : PauseColors.lightAmber,
                decoration: InputDecoration(
                  hintText: '(optional)',
                  hintStyle: PauseTextStyles.body(color: faint, fontSize: 14),
                  filled: true,
                  fillColor: chip,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  border: _fieldBorder(line),
                  enabledBorder: _fieldBorder(line),
                  focusedBorder: _fieldBorder(
                    isDark ? PauseColors.amber : PauseColors.lightAmber,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text('Proactive invitations', style: sectionHeading),
              const SizedBox(height: 6),
              Text(
                'Receive a daily nudge when you usually reach for this.',
                style: PauseTextStyles.body(color: faint, fontSize: 12),
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Enable daily invitation',
                  style: PauseTextStyles.body(color: text, fontSize: 14),
                ),
                activeTrackColor: amber.withAlpha(128),
                activeThumbColor: amber,
                value: viewModel.invitesEnabled,
                onChanged: viewModel.toggleInvites,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: viewModel.finishSetup,
                  child: const Text("I'm ready"),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'No account. No streak to protect. Just you.',
                  style: PauseTextStyles.body(color: faint, fontSize: 11.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1),
      );

  @override
  void onViewModelReady(OnboardingViewModel viewModel) => viewModel.init();

  @override
  OnboardingViewModel viewModelBuilder(BuildContext context) =>
      OnboardingViewModel();
}
