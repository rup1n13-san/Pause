import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/models/pause_enums.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum ResolutionStage { ask, passed, notYet }

class ResolutionViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();
  final _session = locator<RitualSessionService>();

  ResolutionStage stage = ResolutionStage.ask;
  bool _recorded = false;

  // Both outcomes are a "rep" — the event is written either way, exactly once.
  Future<void> _record(UrgeOutcome outcome) async {
    if (!_recorded) {
      _recorded = true;
      await _databaseService.recordEvent(
        feeling: _session.feeling ?? Feeling.autopilot,
        substitute: _session.substitute,
        outcome: outcome,
      );
    }
  }

  Future<void> resolveYes() async {
    await _record(UrgeOutcome.passed);
    stage = ResolutionStage.passed;
    rebuildUi();
  }

  Future<void> resolveNotYet() async {
    await _record(UrgeOutcome.notYet);
    stage = ResolutionStage.notYet;
    rebuildUi();
  }

  void breatheAgain() => _navigationService.navigateToBreathView();

  void goHome() => _navigationService.clearStackAndShow(Routes.homeView);
}
