import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/core/services/invitation_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProgressViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();
  final _settingsService = locator<SettingsService>();
  final _invitationService = locator<InvitationService>();

  /// Null until the first load resolves; the view shows only its header
  /// until then.
  ProgressInsights? insights;

  bool get invitesEnabled => _settingsService.invitesEnabled ?? false;

  bool get showReofferCard =>
      insights?.hasInsights == true &&
      !invitesEnabled &&
      !_settingsService.inviteOfferDismissed;

  Future<void> load() async {
    insights = ProgressInsights.fromEvents(await _databaseService.allEvents());
    rebuildUi();
  }

  Future<void> toggleInvites(bool value) async {
    if (value) {
      final plugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await plugin?.requestNotificationsPermission();
      if (granted == true) {
        await _settingsService.setInvitesEnabled(true);
        await _invitationService.syncSchedule();
      }
    } else {
      await _settingsService.setInvitesEnabled(false);
      await _invitationService.syncSchedule();
    }
    rebuildUi();
  }

  Future<void> dismissReoffer() async {
    await _settingsService.setInviteOfferDismissed(true);
    rebuildUi();
  }

  void goHome() => _navigationService.back();
}
