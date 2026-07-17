import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:intl/intl.dart';

class TimelineSessionItem {
  final String appName;
  final String packageName;
  final int startTimeMs;
  final int durationMs;
  final String startTimeFormatted;
  final String durationFormatted;

  TimelineSessionItem({
    required this.appName,
    required this.packageName,
    required this.startTimeMs,
    required this.durationMs,
    required this.startTimeFormatted,
    required this.durationFormatted,
  });
}

class DailyTimelineViewModel extends BaseViewModel {
  final _db = locator<DatabaseService>();
  final _nav = locator<NavigationService>();

  List<TimelineSessionItem> timelineSessions = [];
  String totalScreenTimeFormatted = "0h 0m";
  String longestSessionFormatted = "0m";

  Future<void> init() async {
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  Future<void> _loadData() async {
    final today = DateTime.now();
    final sessions = await _db.getAppUsageSessionsForDay(today);

    int totalMs = 0;
    int maxMs = 0;
    timelineSessions = [];

    for (var s in sessions) {
      final duration = s.endTime - s.startTime;
      if (duration > 60 * 1000) { // Only show sessions > 1 minute to reduce clutter
        totalMs += duration;
        if (duration > maxMs) maxMs = duration;

        String friendlyName = s.packageName.split('.').last;
        try {
            final appInfo = await InstalledApps.getAppInfo(s.packageName);
            if (appInfo != null && appInfo.name != "") {
                friendlyName = appInfo.name;
            }
        } catch (_) {}

        final startDate = DateTime.fromMillisecondsSinceEpoch(s.startTime);
        final startFormatted = DateFormat('HH:mm').format(startDate);

        int sHours = duration ~/ (1000 * 60 * 60);
        int sMins = (duration % (1000 * 60 * 60)) ~/ (1000 * 60);
        String durFormatted = sHours > 0 ? "${sHours}h ${sMins}m" : "${sMins}m";

        timelineSessions.add(TimelineSessionItem(
           appName: friendlyName,
           packageName: s.packageName,
           startTimeMs: s.startTime,
           durationMs: duration,
           startTimeFormatted: startFormatted,
           durationFormatted: durFormatted,
        ));
      }
    }

    // Reverse to show latest first or keep chronological based on preference.
    // HTML seems chronological top-down.
    // Sort just to be sure.
    timelineSessions.sort((a, b) => a.startTimeMs.compareTo(b.startTimeMs));

    int hours = totalMs ~/ (1000 * 60 * 60);
    int minutes = (totalMs % (1000 * 60 * 60)) ~/ (1000 * 60);
    totalScreenTimeFormatted = "${hours}h ${minutes}m";

    int mHours = maxMs ~/ (1000 * 60 * 60);
    int mMins = (maxMs % (1000 * 60 * 60)) ~/ (1000 * 60);
    longestSessionFormatted = mHours > 0 ? "${mHours}h ${mMins}m" : "${mMins}m";
  }

  void goBack() {
    _nav.back();
  }
}
