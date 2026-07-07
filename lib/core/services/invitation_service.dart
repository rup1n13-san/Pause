import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/models/progress_insights.dart';
import 'package:mobile/core/services/database_service.dart';
import 'package:mobile/core/services/settings_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class InvitationService {
  final _db = locator<DatabaseService>();
  final _settings = locator<SettingsService>();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        await _settings.setLastInvitationFiredAt(
          DateTime.now().millisecondsSinceEpoch,
        );
      },
    );

    _initialized = true;
  }

  Future<void> syncSchedule() async {
    await _notifications.cancelAll();

    if (_settings.invitesEnabled != true) return;

    final events = await _db.allEvents();
    final insights = ProgressInsights.fromEvents(events);

    if (!insights.hasInsights) return;

    final peakHour = insights.peakHour;

    for (var i = 0; i < 7; i++) {
      final scheduledDate =
          _nextInstanceOfHour(peakHour).add(Duration(days: i));

      await _notifications.zonedSchedule(
        id: i,
        title: 'Time to Pause',
        body: 'Take a moment for your breath ritual.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'pause_invitations',
            'Pause Invitations',
            channelDescription:
                'Opt-in daily invitations at your peak urge time.',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  bool get isWithinInvitationWindow {
    final lastFired = _settings.lastInvitationFiredAt;
    if (lastFired == null) return false;

    final firedTime = DateTime.fromMillisecondsSinceEpoch(lastFired);
    final diff = DateTime.now().difference(firedTime);
    return diff.inMinutes <= 30 && diff.inMinutes >= 0;
  }
}
