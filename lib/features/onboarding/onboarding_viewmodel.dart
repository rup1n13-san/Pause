import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/invitation_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();
  final _invitationService = locator<InvitationService>();

  late List<String> presets;
  final Set<String> _selected = {};
  final noteController = TextEditingController();

  late final bool isEditing = _settingsService.setupComplete;

  void init() {
    presets = List.of(SettingsService.presetSubstitutes);
    _selected.addAll(_settingsService.substitutes);
    noteController.text = _settingsService.habitNote;
    notifyListeners();
  }

  bool isSelected(String sub) => _selected.contains(sub);

  void toggle(String sub) {
    if (_selected.contains(sub)) {
      _selected.remove(sub);
    } else {
      _selected.add(sub);
    }
    notifyListeners();
  }

  bool get invitesEnabled => _settingsService.invitesEnabled ?? false;

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
    notifyListeners();
  }

  Future<void> finishSetup() async {
    final note = noteController.text.trim();
    await _settingsService.completeSetup(
      substitutes: _selected.toList(),
      note: note.isNotEmpty ? note : null,
    );
    if (isEditing) {
        _navigationService.back();
    } else {
        await _navigationService.replaceWithMainDashboardView();
    }
  }
}
