import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProgressViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();

  int showedUpCount = 0;

  // Slice 0: just the count. Feeling/time-of-day insights come in Slice 3.
  Future<void> load() async {
    showedUpCount = await _databaseService.eventCount();
    rebuildUi();
  }

  void goHome() => _navigationService.back();
}
