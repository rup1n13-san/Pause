import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'daily_timeline_viewmodel.dart';
import 'package:intl/intl.dart';

class DailyTimelineView extends StackedView<DailyTimelineViewModel> {
  const DailyTimelineView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DailyTimelineViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: PauseColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PauseColors.text),
          onPressed: viewModel.goBack,
        ),
        title: Text(
          "Today's Journey",
          style: PauseTextStyles.title(fontSize: 24, color: PauseColors.text),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: PauseTextStyles.body(color: PauseColors.muted, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PauseColors.muted.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOTAL TIME', style: PauseTextStyles.meta(color: PauseColors.muted)),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.totalScreenTimeFormatted,
                            style: PauseTextStyles.title(fontSize: 24, color: PauseColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PauseColors.muted.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LONGEST SESSION', style: PauseTextStyles.meta(color: PauseColors.muted)),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.longestSessionFormatted,
                            style: PauseTextStyles.title(fontSize: 24, color: PauseColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Timeline
              Stack(
                children: [
                  Positioned(
                    left: 23,
                    top: 16,
                    bottom: 0,
                    width: 2,
                    child: Container(color: PauseColors.panel),
                  ),
                  Column(
                    children: [
                      for (final session in viewModel.timelineSessions)
                        _TimelineItem(session: session),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  DailyTimelineViewModel viewModelBuilder(BuildContext context) => DailyTimelineViewModel();

  @override
  void onViewModelReady(DailyTimelineViewModel viewModel) => viewModel.init();
}

class _TimelineItem extends StatelessWidget {
  final TimelineSessionItem session;

  const _TimelineItem({required this.session});

  @override
  Widget build(BuildContext context) {
    bool isBinge = session.durationMs > (60 * 60 * 1000); // > 1 hour

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  session.startTimeFormatted,
                  style: TextStyle(fontWeight: FontWeight.bold, color: PauseColors.text),
                ),
                Text(
                  session.durationFormatted,
                  style: TextStyle(fontSize: 12, color: isBinge ? PauseColors.amber : PauseColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: isBinge ? PauseColors.amber : PauseColors.text,
              shape: BoxShape.circle,
              border: Border.all(color: PauseColors.bg, width: 3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isBinge ? PauseColors.amber.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isBinge ? PauseColors.amber.withValues(alpha: 0.3) : PauseColors.muted.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PauseColors.panel,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.apps, color: PauseColors.text),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              session.appName,
                              style: PauseTextStyles.title(fontSize: 16, color: PauseColors.text),
                            ),
                            if (isBinge) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: PauseColors.panel,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'LONG SESSION',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: PauseColors.muted),
                                ),
                              )
                            ]
                          ],
                        ),
                        Text(
                          'Continuous focus',
                          style: PauseTextStyles.body(fontSize: 13, color: PauseColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
