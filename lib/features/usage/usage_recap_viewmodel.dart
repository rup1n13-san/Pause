import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/usage_stats_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:installed_apps/installed_apps.dart';

class AppUsageItem {
  final String packageName;
  final String name;
  final int totalTimeMs;
  final String durationFormatted;
  final double fraction;

  AppUsageItem({
    required this.packageName,
    required this.name,
    required this.totalTimeMs,
    required this.durationFormatted,
    required this.fraction,
  });
}

class UsageRecapViewModel extends BaseViewModel {
  final _usageService = locator<UsageStatsService>();
  final _db = locator<DatabaseService>();
  final _nav = locator<NavigationService>();

  bool _hasAccess = false;
  bool get hasAccess => _hasAccess;

  int _selectedTab = 0; // 0: Daily, 1: Weekly, 2: Monthly
  int get selectedTab => _selectedTab;

  List<AppUsageItem> topApps = [];
  String totalScreenTimeFormatted = "0h 0m";

  Future<void> init() async {
    setBusy(true);
    _hasAccess = await _usageService.hasAccess();
    if (_hasAccess) {
      await _loadData();
    }
    setBusy(false);
  }

  Future<void> _loadData() async {
    final now = DateTime.now();
    DateTime startDate;

    if (_selectedTab == 0) {
      // Daily
      startDate = DateTime(now.year, now.month, now.day);
    } else if (_selectedTab == 1) {
      // Weekly (last 7 days)
      startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    } else {
      // Monthly (last 30 days)
      startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
    }

    // Fetch sessions for the time range
    Map<String, int> usageByApp = {};
    int totalMs = 0;

    for (int i = 0; i <= now.difference(startDate).inDays; i++) {
        final day = startDate.add(Duration(days: i));
        final sessions = await _db.getAppUsageSessionsForDay(day);

        for (var s in sessions) {
          final duration = s.endTime - s.startTime;
          if (duration > 0) {
            usageByApp[s.packageName] = (usageByApp[s.packageName] ?? 0) + duration;
            totalMs += duration;
          }
        }
    }

    int hours = totalMs ~/ (1000 * 60 * 60);
    int minutes = (totalMs % (1000 * 60 * 60)) ~/ (1000 * 60);
    totalScreenTimeFormatted = "${hours}h ${minutes}m";

    var sortedApps = usageByApp.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topApps = [];
    for (var i = 0; i < sortedApps.length && i < 5; i++) {
        final entry = sortedApps[i];
        final pName = entry.key;
        final ms = entry.value;

        String friendlyName = pName.split('.').last; // Fallback
        try {
            // Try to get real name
            final appInfo = await InstalledApps.getAppInfo(pName);
            if (appInfo != null && appInfo.name != "") {
                friendlyName = appInfo.name;
            }
        } catch (_) {}

        int aHours = ms ~/ (1000 * 60 * 60);
        int aMins = (ms % (1000 * 60 * 60)) ~/ (1000 * 60);
        String formatted = aHours > 0 ? "${aHours}h ${aMins}m" : "${aMins}m";

        topApps.add(AppUsageItem(
            packageName: pName,
            name: friendlyName,
            totalTimeMs: ms,
            durationFormatted: formatted,
            fraction: totalMs > 0 ? ms / totalMs : 0.0,
        ));
    }
  }

  void setTab(int index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    _loadData().then((_) => notifyListeners());
  }

  Future<void> openSettings() async {
    await _usageService.openSettings();
    Future.delayed(const Duration(seconds: 2), () => init());
  }

  void openTimeline() {
    _nav.navigateTo(Routes.dailyTimelineView);
  }
}
