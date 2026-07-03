import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProgressViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();

  /// Null until the first load resolves; the view shows only its header
  /// until then.
  ProgressInsights? insights;

  Future<void> load() async {
    insights = ProgressInsights.fromEvents(await _databaseService.allEvents());
    rebuildUi();
  }

  void goHome() => _navigationService.back();
}
