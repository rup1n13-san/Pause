import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FeelingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _session = locator<RitualSessionService>();

  List<Feeling> get feelings => Feeling.values;

  void choose(Feeling feeling) {
    _session.feeling = feeling;
    _navigationService.navigateToBreathView();
  }

  void back() => _navigationService.back();
}
