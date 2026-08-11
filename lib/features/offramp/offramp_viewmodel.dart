import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OfframpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _session = locator<RitualSessionService>();
  final _settingsService = locator<SettingsService>();

  List<String> get substitutes => _settingsService.substitutes;

  void pick(String substitute) {
    _session.substitute = substitute;
    _navigationService.navigateToResolutionView();
  }
}
