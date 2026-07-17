import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/interception_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:mobile/core/services/usage_stats_service.dart';
import 'package:stacked/stacked.dart';

class AppInterceptionViewModel extends BaseViewModel {
  final _settings = locator<SettingsService>();
  final _usageStats = locator<UsageStatsService>();
  final _interceptionService = locator<InterceptionService>();

  bool _hasAccess = false;
  bool get hasAccess => _hasAccess;

  bool get isEnabled => _settings.interceptionEnabled;

  List<AppInfo> _installedApps = [];
  List<AppInfo> get installedApps => _installedApps;

  List<String> get interceptedApps => _settings.interceptedApps;

  Future<void> init() async {
    setBusy(true);
    await checkAccess();
    if (_hasAccess) {
      await _loadApps();
    }
    setBusy(false);
  }

  Future<void> checkAccess() async {
    _hasAccess = await _usageStats.hasAccess();
    notifyListeners();
  }

  Future<void> openSettings() async {
    await _usageStats.openSettings();
  }

  Future<void> toggleEnabled(bool value) async {
    await _settings.setInterceptionEnabled(value);

    if (value) {
      await _interceptionService.startService();
    } else {
      await _interceptionService.stopService();
    }

    notifyListeners();
  }

  Future<void> _loadApps() async {
    try {
      final apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: true,
        withIcon: true,
      );

      // Sort alphabetically
      apps.sort((a, b) => a.name.compareTo(b.name));
      _installedApps = apps;
    } catch (e) {
      // Ignore errors fetching apps
      _installedApps = [];
    }
  }

  Future<void> toggleAppInterception(String packageName, bool value) async {
    final currentList = List<String>.from(_settings.interceptedApps);

    if (value && !currentList.contains(packageName)) {
      currentList.add(packageName);
    } else if (!value && currentList.contains(packageName)) {
      currentList.remove(packageName);
    }

    await _settings.setInterceptedApps(currentList);
    notifyListeners();
  }
}
