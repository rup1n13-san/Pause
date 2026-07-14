import 'package:flutter/material.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:stacked/stacked.dart';

import 'progress_viewmodel.dart';

class ProgressView extends StackedView<ProgressViewModel> {
  const ProgressView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProgressViewModel viewModel,
    Widget? child,
  ) {
    final bg = PauseColors.bg;
    final text = PauseColors.text;
    final muted = PauseColors.text.withValues(alpha: 0.7);
    final faint = PauseColors.text.withValues(alpha: 0.4);
    final amber = PauseColors.amber;
    final panel = PauseColors.panel;
    final line = PauseColors.text.withValues(alpha: 0.08);

    Text metaLabel(String data) => Text(
          data.toUpperCase(),
          style: PauseTextStyles.meta(color: faint, fontSize: 11),
        );

    Widget card(Widget content) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(16),
          ),
          child: content,
        );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(color: text, onPressed: viewModel.goHome),
        title: Text(
          'Progress',
          style: PauseTextStyles.title(fontSize: 18, color: text),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (viewModel.insights == null)
                const SizedBox() // still loading
              else ...[
                if (viewModel.insights!.hasInsights) ...[
                  _totalBlock(viewModel.insights!.total, text, muted, faint),
                  const SizedBox(height: 32),
                  card(_feelingBlock(viewModel.insights!, metaLabel, text, muted, amber, line)),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: card(_timeBlock(viewModel.insights!, metaLabel, text, faint, amber, line))),
                      const SizedBox(width: 14),
                      Expanded(child: card(_daysBlock(viewModel.insights!, metaLabel, muted, amber, panel, line))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (viewModel.showReofferCard)
                    card(_reofferBlock(viewModel.insights!, viewModel, metaLabel, text, muted, amber))
                  else
                    card(_toggleRow(viewModel, text, amber)),
                  const SizedBox(height: 14),
                  if (!viewModel.hasUsageAccess) ...[
                    card(_usageOptInCard(viewModel, text, muted, amber)),
                    const SizedBox(height: 14),
                  ],
                  // App Interception integration
                  card(_appInterceptionCard(viewModel, text, muted, amber)),
                ] else ...[
                  const SizedBox(height: 14),
                  card(_emptyBlock(text, muted)),
                  const SizedBox(height: 14),
                  // App Interception integration
                  card(_appInterceptionCard(viewModel, text, muted, amber)),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalBlock(int total, Color text, Color muted, Color faint) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You've shown up",
            style: PauseTextStyles.body(color: muted, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$total',
                  style: TextStyle(
                    fontFamily: 'DM Mono',
                    fontWeight: FontWeight.w500,
                    fontSize: 44,
                    height: 1,
                    color: text,
                  ),
                ),
                TextSpan(
                  text: '   times',
                  style: PauseTextStyles.body(color: muted, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Each one is a moment you met on purpose.',
            style: PauseTextStyles.body(color: faint, fontSize: 13),
          ),
        ],
      );

  Widget _emptyBlock(Color text, Color muted) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A pattern will surface soon.',
            style: PauseTextStyles.title(fontSize: 18, color: text),
          ),
          const SizedBox(height: 8),
          Text(
            "A few more moments and this fills in — when the urge tends to "
            "visit, and what's underneath it. Nothing to force. Keep showing up.",
            style: PauseTextStyles.body(color: muted, fontSize: 13.5),
          ),
        ],
      );

  Widget _feelingBlock(
    ProgressInsights insights,
    Text Function(String) metaLabel,
    Color text,
    Color muted,
    Color amber,
    Color chip,
  ) {
    final amberSoft = amber.withValues(alpha: 0.35);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        metaLabel('the feeling underneath'),
        const SizedBox(height: 10),
        Text(
          "Most often, it's ${insights.topFeeling}.",
          style: PauseTextStyles.title(fontSize: 17, color: text),
        ),
        const SizedBox(height: 16),
        for (final bar in insights.feelingBars)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    bar.name,
                    style: PauseTextStyles.label(
                      color: muted,
                      fontSize: 12,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 7,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: chip,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: bar.fraction < 0.04 ? 0.04 : bar.fraction,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: bar.isTop ? amber : amberSoft,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _timeBlock(
    ProgressInsights insights,
    Text Function(String) metaLabel,
    Color text,
    Color faint,
    Color amber,
    Color line,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          metaLabel('when it tends to hit'),
          const SizedBox(height: 10),
          Text(
            insights.peakLine,
            style: PauseTextStyles.title(fontSize: 17, color: text),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 42,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final d in insights.hourDensity)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        height: d > 0 ? 6 + d * 36 : 3,
                        decoration: BoxDecoration(
                          color: d > 0
                              ? amber.withValues(alpha: 0.4 + d * 0.6)
                              : line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          DefaultTextStyle(
            style: PauseTextStyles.meta(color: faint, fontSize: 9),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('12a'),
                Text('6a'),
                Text('12p'),
                Text('6p'),
                Text('12a'),
              ],
            ),
          ),
        ],
      );

  Widget _daysBlock(
    ProgressInsights insights,
    Text Function(String) metaLabel,
    Color muted,
    Color amber,
    Color chip,
    Color line,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          metaLabel('last two weeks'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final filled in insights.dayCells)
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: filled ? amber : chip,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: filled ? amber : line, width: 1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Gaps aren't failures — they're just days. You came back, and that's "
            'the whole practice.',
            style: PauseTextStyles.body(color: muted, fontSize: 13),
          ),
        ],
      );

  Widget _reofferBlock(
    ProgressInsights insights,
    ProgressViewModel viewModel,
    Text Function(String) metaLabel,
    Color text,
    Color muted,
    Color amber,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          metaLabel('proactive'),
          const SizedBox(height: 10),
          Text(
            'Want a gentle nudge?',
            style: PauseTextStyles.title(fontSize: 17, color: text),
          ),
          const SizedBox(height: 8),
          Text(
            'We can send an optional invitation to pause when you usually reach for this.',
            style: PauseTextStyles.body(color: muted, fontSize: 13.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => viewModel.toggleInvites(true),
                  child: const Text('Enable invitations'),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: viewModel.dismissReoffer,
                child: Text(
                  'Not now',
                  style: TextStyle(color: muted),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _toggleRow(ProgressViewModel viewModel, Color text, Color amber) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Daily invitations',
          style: PauseTextStyles.body(color: text, fontSize: 15),
        ),
        activeTrackColor: amber.withAlpha(128),
        activeThumbColor: amber,
        value: viewModel.invitesEnabled,
        onChanged: viewModel.toggleInvites,
      );

  Widget _usageOptInCard(
    ProgressViewModel viewModel,
    Color text,
    Color muted,
    Color amber,
  ) =>
      InkWell(
        onTap: viewModel.openUsageOptIn,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Make check-ins smarter',
                  style: PauseTextStyles.title(fontSize: 16, color: text),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: muted, size: 14),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Predict when you might need a Pause based on your screen rhythm.',
              style: PauseTextStyles.body(color: muted, fontSize: 13.5),
            ),
          ],
        ),
      );

  Widget _appInterceptionCard(
    ProgressViewModel viewModel,
    Color text,
    Color muted,
    Color amber,
  ) =>
      InkWell(
        onTap: viewModel.navigateToAppInterception,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.block, color: amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  'App Interception',
                  style: PauseTextStyles.title(fontSize: 16, color: text),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: muted, size: 14),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Get a gentle nudge when you open a distracting app.',
              style: PauseTextStyles.body(color: muted, fontSize: 13.5),
            ),
          ],
        ),
      );

  @override
  void onViewModelReady(ProgressViewModel viewModel) => viewModel.load();

  @override
  ProgressViewModel viewModelBuilder(BuildContext context) =>
      ProgressViewModel();
}
