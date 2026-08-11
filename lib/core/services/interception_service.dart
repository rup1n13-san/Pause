import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:mobile/core/services/usage_stats_service.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // We need to initialize our locator in the background isolate
  setupLocator();
  await locator.allReady();

  final settings = locator<SettingsService>();
  await settings.init();

  final usageStats = locator<UsageStatsService>();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Timer.periodic(const Duration(seconds: 3), (timer) async {
    if (!settings.interceptionEnabled) return;

    final hasAccess = await usageStats.hasAccess();
    if (!hasAccess) return;

    final foregroundApp = await usageStats.getForegroundApp();
    if (foregroundApp == null) return;

    final interceptedApps = settings.interceptedApps;
    if (interceptedApps.contains(foregroundApp)) {
      final lastIntercepted = settings.lastInterceptedAt;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Cooldown of 5 minutes to prevent notification spam
      if (lastIntercepted == null || (now - lastIntercepted) > 5 * 60 * 1000) {
        await settings.setLastInterceptedAt(now);

        await flutterLocalNotificationsPlugin.show(
          id: 888,
          title: 'Take a pause?',
          body: 'You just opened a distracting app.',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'pause_interception',
              'App Interception',
              channelDescription: 'Nudges when you open distracting apps.',
              importance: Importance.max,
              priority: Priority.max,
            ),
          ),
        );
      }
    }
  });
}

class InterceptionService {
  final _settings = locator<SettingsService>();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(
      settings: initializationSettings,
    );

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: _settings.interceptionEnabled,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
      ),
    );

    _initialized = true;
  }

  Future<void> startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  Future<void> stopService() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
  }
}
