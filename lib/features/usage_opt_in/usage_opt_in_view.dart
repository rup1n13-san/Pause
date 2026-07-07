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
    final amber = isDark ? PauseColors.amber : PauseColors.lightAmber;
    final bg = isDark ? PauseColors.bg : PauseColors.lightBg;
    final surface = isDark ? PauseColors.panel : PauseColors.lightPanel;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: text),
          onPressed: viewModel.onDecline,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalSpaceLarge,
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: amber,
              ),
              verticalSpaceMedium,
              Text(
                'Make check-ins smarter',
                style: PauseTextStyles.title(
                  fontSize: 28,
                  color: text,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpaceMedium,
              Text(
                'To predict when you might need a Pause, we can look at your screen-on rhythm late at night.',
                style: PauseTextStyles.body(
                  fontSize: 16,
                  color: muted,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpaceLarge,
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _FactRow(
                      icon: Icons.check_circle_outline,
                      label: 'We read screen-on rhythm only. No app names.',
                      textColor: text,
                      iconColor: amber,
                    ),
                    verticalSpaceSmall,
                    _FactRow(
                      icon: Icons.lock_outline,
                      label: 'Data stays completely on this phone.',
                      textColor: text,
                      iconColor: amber,
                    ),
                    verticalSpaceSmall,
                    _FactRow(
                      icon: Icons.settings_outlined,
                      label: 'You can revoke access anytime.',
                      textColor: text,
                      iconColor: amber,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: viewModel.openSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  foregroundColor: isDark ? PauseColors.onAmber : bg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpaceMedium,
              TextButton(
                onPressed: viewModel.onDecline,
                style: TextButton.styleFrom(
                  foregroundColor: muted,
                ),
                child: const Text('Not now'),
              ),
              verticalSpaceLarge,
            ],
          ),
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
  final String label;
  final Color textColor;
  final Color iconColor;

  const _FactRow({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        horizontalSpaceSmall,
        Expanded(
          child: Text(
            label,
            style: PauseTextStyles.body(
              color: textColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
