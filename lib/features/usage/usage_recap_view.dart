import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'usage_recap_viewmodel.dart';

class UsageRecapView extends StackedView<UsageRecapViewModel> {
  const UsageRecapView({super.key});

  @override
  Widget builder(
    BuildContext context,
    UsageRecapViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!viewModel.hasAccess) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Usage access required.'),
              ElevatedButton(
                onPressed: viewModel.openSettings,
                child: Text('Grant Access'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: PauseColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'LustBlock',
          style: PauseTextStyles.title(fontSize: 24, color: PauseColors.text),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: PauseColors.text),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Segmented Control
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: PauseColors.panel,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TabButton(
                        title: 'Daily',
                        isActive: viewModel.selectedTab == 0,
                        onTap: () => viewModel.setTab(0),
                      ),
                      _TabButton(
                        title: 'Weekly',
                        isActive: viewModel.selectedTab == 1,
                        onTap: () => viewModel.setTab(1),
                      ),
                      _TabButton(
                        title: 'Monthly',
                        isActive: viewModel.selectedTab == 2,
                        onTap: () => viewModel.setTab(2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Hero Stat
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PauseColors.muted.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL SCREEN TIME',
                      style: PauseTextStyles.meta(color: PauseColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          viewModel.totalScreenTimeFormatted,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: PauseColors.text,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.arrow_downward, size: 16, color: PauseColors.muted),
                        Text(
                          ' 12% vs yesterday',
                          style: PauseTextStyles.body(color: PauseColors.muted, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Simplified Chart Visual
                    SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ChartBar(height: 0.3, label: 'Mon'),
                          _ChartBar(height: 0.45, label: 'Tue'),
                          _ChartBar(height: 0.6, label: 'Wed'),
                          _ChartBar(height: 0.85, label: 'Today', isActive: true),
                          _ChartBar(height: 0.2, isFuture: true),
                          _ChartBar(height: 0.2, isFuture: true),
                          _ChartBar(height: 0.2, isFuture: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: viewModel.openTimeline,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PauseColors.panel,
                  foregroundColor: PauseColors.text,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: PauseColors.muted.withValues(alpha: 0.2)),
                  ),
                  elevation: 0,
                ),
                child: const Text('View Detailed Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 24),

              // App Breakdown
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PauseColors.muted.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Breakdown',
                      style: PauseTextStyles.title(fontSize: 24, color: PauseColors.text),
                    ),
                    const SizedBox(height: 24),
                    for (final appUsage in viewModel.topApps)
                      _AppRow(
                        iconData: Icons.apps, // Using generic icon since installed_apps might be tricky
                        name: appUsage.name,
                        category: 'App',
                        durationFormatted: appUsage.durationFormatted,
                        fraction: appUsage.fraction,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  @override
  UsageRecapViewModel viewModelBuilder(BuildContext context) => UsageRecapViewModel();

  @override
  void onViewModelReady(UsageRecapViewModel viewModel) => viewModel.init();
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? PauseColors.text : PauseColors.muted,
          ),
        ),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double height;
  final String? label;
  final bool isActive;
  final bool isFuture;

  const _ChartBar({
    required this.height,
    this.label,
    this.isActive = false,
    this.isFuture = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (label != null && isActive)
               Text(label!, style: TextStyle(fontSize: 12, color: PauseColors.text, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isActive
                    ? PauseColors.text
                    : isFuture
                        ? PauseColors.panel.withValues(alpha: 0.5)
                        : PauseColors.panel,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              height: 100 * height,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  final IconData iconData;
  final String name;
  final String category;
  final String durationFormatted;
  final double fraction;

  const _AppRow({
    required this.iconData,
    required this.name,
    required this.category,
    required this.durationFormatted,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PauseColors.panel,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: PauseColors.text),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: PauseTextStyles.title(fontSize: 16, color: PauseColors.text)),
                Text(category, style: PauseTextStyles.body(fontSize: 12, color: PauseColors.muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(durationFormatted, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PauseColors.text)),
              const SizedBox(height: 4),
              SizedBox(
                width: 96,
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: fraction,
                    backgroundColor: PauseColors.panel,
                    valueColor: AlwaysStoppedAnimation(PauseColors.text),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
