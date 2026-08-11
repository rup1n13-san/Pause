import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:mobile/core/services/invitation_service.dart';
import 'package:mobile/core/services/interception_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile/core/services/usage_stats_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DatabaseService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<SettingsService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<InvitationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<UsageStatsService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<InterceptionService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
  ],
)
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterDatabaseService();
  getAndRegisterSettingsService();
  getAndRegisterInvitationService();
  getAndRegisterUsageStatsService();
  getAndRegisterInterceptionService();
// @stacked-mock-register
}

MockDatabaseService getAndRegisterDatabaseService() {
  _removeRegistrationIfExists<DatabaseService>();
  final service = MockDatabaseService();
  locator.registerSingleton<DatabaseService>(service);
  return service;
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(
    service.showCustomSheet<T, T>(
      enableDrag: anyNamed('enableDrag'),
      enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
      exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
      ignoreSafeArea: anyNamed('ignoreSafeArea'),
      isScrollControlled: anyNamed('isScrollControlled'),
      barrierDismissible: anyNamed('barrierDismissible'),
      additionalButtonTitle: anyNamed('additionalButtonTitle'),
      variant: anyNamed('variant'),
      title: anyNamed('title'),
      hasImage: anyNamed('hasImage'),
      imageUrl: anyNamed('imageUrl'),
      showIconInMainButton: anyNamed('showIconInMainButton'),
      mainButtonTitle: anyNamed('mainButtonTitle'),
      showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
      secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
      showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
      takesInput: anyNamed('takesInput'),
      barrierColor: anyNamed('barrierColor'),
      barrierLabel: anyNamed('barrierLabel'),
      customData: anyNamed('customData'),
      data: anyNamed('data'),
      description: anyNamed('description'),
    ),
  ).thenAnswer(
    (realInvocation) =>
        Future.value(showCustomSheetResponse ?? SheetResponse<T>()),
  );

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockUsageStatsService getAndRegisterUsageStatsService() {
  _removeRegistrationIfExists<UsageStatsService>();
  final service = MockUsageStatsService();
  locator.registerSingleton<UsageStatsService>(service);
  return service;
}
// @stacked-mock-create

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockInvitationService getAndRegisterInvitationService() {
  _removeRegistrationIfExists<InvitationService>();
  final service = MockInvitationService();
  locator.registerSingleton<InvitationService>(service);
  return service;
}

MockInterceptionService getAndRegisterInterceptionService() {
  _removeRegistrationIfExists<InterceptionService>();
  final service = MockInterceptionService();
  locator.registerSingleton<InterceptionService>(service);
  return service;
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
