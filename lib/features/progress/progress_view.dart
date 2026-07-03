import 'package:flutter/material.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/pause_text_link.dart';
import 'package:stacked/stacked.dart';

import 'progress_viewmodel.dart';

/// Progress: a warm, judgment-free read of the local event history — how many
/// times you've shown up, the feeling underneath, when it tends to hit, and the
/// last two weeks. Below [ProgressInsights.insightThreshold] events it shows a
/// gentle "not enough yet" state rather than fabricating a pattern.
class ProgressView extends StackedView<ProgressViewModel> {
  const ProgressView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProgressViewModel viewModel,
    Widget? child,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? PauseColors.text : PauseColors.lightText;
    final muted = isDark ? PauseColors.muted : PauseColors.lightMuted;
    final faint = isDark ? PauseColors.faint : PauseColors.lightFaint;
    final amber = isDark ? PauseColors.amber : PauseColors.lightAmber;
    final panel = isDark ? PauseColors.panel : PauseColors.lightPanel;
    final line = isDark ? PauseColors.line : PauseColors.lightLine;
    final chip = isDark ? PauseColors.chip : PauseColors.lightChip;

    Widget card(Widget child) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line, width: 1),
      ),
      child: child,
    );

    Text metaLabel(String label) => Text(
      label.toUpperCase(),
      style: PauseTextStyles.meta(
        color: faint,
        fontSize: 11,
      ).copyWith(letterSpacing: 1.1),
    );

    final insights = viewModel.insights;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PauseTextLink(
                text: '← home',
                onTap: viewModel.goHome,
                color: faint,
                pressedColor: muted,
                fontSize: 13,
              ),
              const SizedBox(height: 18),
              Text(
                "What you're noticing",
                style: PauseTextStyles.title(fontSize: 25, color: text),
              ),
              const SizedBox(height: 22),
              if (insights != null) ...[
                card(_totalBlock(insights.total, text, muted, faint)),
                if (insights.hasInsights) ...[
                  const SizedBox(height: 14),
                  card(
                    _feelingBlock(insights, metaLabel, text, muted, amber, chip),
                  ),
                  const SizedBox(height: 14),
                  card(_timeBlock(insights, metaLabel, text, faint, amber, line)),
                  const SizedBox(height: 14),
                  card(_daysBlock(insights, metaLabel, muted, amber, chip, line)),
                ] else ...[
                  const SizedBox(height: 14),
                  card(_emptyBlock(text, muted)),
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
  ) => Column(
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
  ) => Column(
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

  @override
  void onViewModelReady(ProgressViewModel viewModel) => viewModel.load();

  @override
  ProgressViewModel viewModelBuilder(BuildContext context) =>
      ProgressViewModel();
}
