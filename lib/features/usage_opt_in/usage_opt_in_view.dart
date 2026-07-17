import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'usage_opt_in_viewmodel.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/ui/common/ui_helpers.dart';

class UsageOptInView extends StackedView<UsageOptInViewModel> {
  const UsageOptInView({super.key});

  @override
  Widget builder(
    BuildContext context,
    UsageOptInViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final bg = isDark ? PauseColors.bg : PauseColors.lightBg;
    final panel = isDark ? PauseColors.panel : PauseColors.lightPanel;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top illustration area
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: panel,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Central Icon
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: bg,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 48,
                              color: text,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'A gentle look at your habits',
                            style: PauseTextStyles.title(
                              fontSize: 28,
                              color: text,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          verticalSpaceMedium,
                          Text(
                            'To help you build awareness and support your digital wellbeing goals, LustBlock needs \'Usage Access\' permission.',
                            style: PauseTextStyles.body(
                              fontSize: 16,
                              color: muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          verticalSpaceSmall,
                          Text(
                            'This allows us to silently observe how you spend your time, providing you with insightful, private reflections without judgment.',
                            style: PauseTextStyles.body(
                              fontSize: 16,
                              color: muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          verticalSpaceLarge,

                          // Trust Badges
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: panel.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: muted.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                _FactRow(
                                  icon: Icons.lock_outline,
                                  title: 'Private & Secure',
                                  subtitle: 'Your data stays on your device. We don\'t sell it.',
                                  textColor: text,
                                  mutedColor: muted,
                                ),
                                verticalSpaceMedium,
                                _FactRow(
                                  icon: Icons.battery_charging_full_outlined,
                                  title: 'Battery Efficient',
                                  subtitle: 'Designed to run quietly in the background.',
                                  textColor: text,
                                  mutedColor: muted,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: viewModel.openSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: text,
                      foregroundColor: bg,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Grant Permission',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        horizontalSpaceSmall,
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  TextButton(
                    onPressed: viewModel.onDecline,
                    style: TextButton.styleFrom(
                      foregroundColor: text,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Maybe Later',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  UsageOptInViewModel viewModelBuilder(BuildContext context) =>
      UsageOptInViewModel();

  @override
  void onViewModelReady(UsageOptInViewModel viewModel) => viewModel.onInit();
}

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color mutedColor;

  const _FactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: mutedColor, size: 24),
        horizontalSpaceMedium,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: PauseTextStyles.title(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: PauseTextStyles.body(
                  color: mutedColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
