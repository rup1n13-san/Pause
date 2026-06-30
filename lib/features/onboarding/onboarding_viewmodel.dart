import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();

  // Slice 0: complete setup with the default substitutes. The picker UI
  // (choosing substitutes + optional note) is built in Slice 3.
  Future<void> finishSetup() async {
    await _settingsService.completeSetup(
      substitutes: _settingsService.substitutes,
    );
    await _navigationService.replaceWithHomeView();
  }
}
