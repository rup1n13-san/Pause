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

  // Total reps recorded, including the one just written. Null until an outcome
  // is chosen (so the view renders "…" for the one frame before it resolves).
  int? _eventCount;
  int? get eventCount => _eventCount;

  /// "N time(s) you've shown up" — singular at 1. Null until [_eventCount] is
  /// populated, so the view can fall back to a placeholder.
  String? get repCountLabel {
    final count = _eventCount;
    if (count == null) return null;
    final noun = count == 1 ? 'time' : 'times';
    return "$count $noun you've shown up";
  }

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
    _eventCount = await _databaseService.eventCount();
    stage = ResolutionStage.passed;
    rebuildUi();
  }

  Future<void> resolveNotYet() async {
    await _record(UrgeOutcome.notYet);
    _eventCount = await _databaseService.eventCount();
    stage = ResolutionStage.notYet;
    rebuildUi();
  }

  void breatheAgain() => _navigationService.navigateToBreathView();

  void goHome() => _navigationService.clearStackAndShow(Routes.homeView);
}
