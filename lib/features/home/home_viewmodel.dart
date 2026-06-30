import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _session = locator<RitualSessionService>();

  void beginFlow() {
    _session.startNewRun();
    _navigationService.navigateToFeelingView();
  }

  void openProgress() => _navigationService.navigateToProgressView();

  void openSubstitutes() => _navigationService.navigateToOnboardingView();
}
