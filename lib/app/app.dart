import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/ritual_session_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:mobile/features/breath/breath_view.dart';
import 'package:mobile/features/feeling/feeling_view.dart';
import 'package:mobile/features/home/home_view.dart';
import 'package:mobile/features/offramp/offramp_view.dart';
import 'package:mobile/features/onboarding/onboarding_view.dart';
import 'package:mobile/features/progress/progress_view.dart';
import 'package:mobile/features/resolution/resolution_view.dart';
import 'package:mobile/features/startup/startup_view.dart';
import 'package:mobile/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:mobile/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: FeelingView),
    MaterialRoute(page: BreathView),
    MaterialRoute(page: OfframpView),
    MaterialRoute(page: ResolutionView),
    MaterialRoute(page: ProgressView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: RitualSessionService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
