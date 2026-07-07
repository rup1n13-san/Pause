import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/invitation_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// First-run setup and the "your substitutes" editor are the same screen. On
/// first run it replaces into Home; reached from Home to edit, it pops back.
class OnboardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();
  final _invitationService = locator<InvitationService>();

  final noteController = TextEditingController();
  final Set<String> _selected = {};
  
  bool _invitesEnabled = false;
  bool get invitesEnabled => _invitesEnabled;

  /// Captured once, before we persist anything, so it reflects how the screen
  /// was entered.
  late final bool isEditing = _settingsService.setupComplete;

  List<String> get presets => SettingsService.presetSubstitutes;
  bool isSelected(String substitute) => _selected.contains(substitute);

  void init() {
    _selected
      ..clear()
      ..addAll(_settingsService.substitutes);
    noteController.text = _settingsService.habitNote;
    _invitesEnabled = _settingsService.invitesEnabled ?? false;
    rebuildUi();
  }

  Future<void> toggleInvites(bool value) async {
    if (value) {
      final plugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await plugin?.requestNotificationsPermission();
      _invitesEnabled = granted ?? false;
    } else {
      _invitesEnabled = false;
    }
    rebuildUi();
  }

  void toggle(String substitute) {
    if (!_selected.remove(substitute)) _selected.add(substitute);
    rebuildUi();
  }

  Future<void> finishSetup() async {
    // Preserve preset order; never persist an empty list (the Off-ramp needs
    // at least one option).
    final chosen = presets.where(_selected.contains).toList();
    final substitutes = chosen.isEmpty ? const ['Walk'] : chosen;

    await _settingsService.completeSetup(
      substitutes: substitutes,
      note: noteController.text.trim(),
    );
    await _settingsService.setInvitesEnabled(_invitesEnabled);
    await _invitationService.syncSchedule();

    if (isEditing) {
      _navigationService.back();
    } else {
      await _navigationService.replaceWithHomeView();
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
