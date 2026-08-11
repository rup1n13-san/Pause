import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _session = locator<RitualSessionService>();
  final _databaseService = locator<DatabaseService>();

  /// Drives the small "noticed N× this week" banner. Null until loaded and
  /// only shown once there's enough history to be meaningful.
  ProgressInsights? insights;

  Future<void> load() async {
    insights = ProgressInsights.fromEvents(await _databaseService.allEvents());
    rebuildUi();
  }

  void beginFlow() {
    _session.startNewRun();
    _navigationService.navigateToFeelingView();
  }

  void openProgress() => _navigationService.navigateToProgressView();

  void openSubstitutes() => _navigationService.navigateToOnboardingView();
}
