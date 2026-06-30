import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();

  Future<void> runStartupLogic() async {
    await _settingsService.init();

    if (_settingsService.setupComplete) {
      await _navigationService.replaceWithHomeView();
    } else {
      await _navigationService.replaceWithOnboardingView();
    }
  }
}
