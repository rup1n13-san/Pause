import 'package:mobile/app/app.locator.dart';
import 'package:mobile/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// Slice 0 placeholder. The real un-skippable 4-7-8 breath ritual is Slice 1
// (built via the flutter-perf-builder agent) — no skip control ships here.
class BreathViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void continueToOfframp() => _navigationService.navigateToOfframpView();
}
