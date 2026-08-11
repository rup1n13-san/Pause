import 'package:flutter/widgets.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/usage_stats_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UsageOptInViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _usage = locator<UsageStatsService>();
  final _nav = locator<NavigationService>();

  bool _hasAccess = false;
  bool get hasAccess => _hasAccess;

  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    _checkAccess();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    _hasAccess = await _usage.hasAccess();
    notifyListeners();
    if (_hasAccess) {
      await _usage.syncUsage();
      _nav.back();
    }
  }

  Future<void> openSettings() async {
    await _usage.openSettings();
  }

  void onDecline() {
    _nav.back();
  }
}
