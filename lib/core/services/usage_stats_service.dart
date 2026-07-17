import 'package:flutter/services.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/core/data/database/app_database.dart';
import 'package:mobile/core/services/database_service.dart';

class UsageStatsService {
  final _channel = const MethodChannel('pause/usage');
  final _db = locator<DatabaseService>();

  Future<bool> hasAccess() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasUsageAccess');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
    } catch (_) {}
  }

  Future<String?> getForegroundApp() async {
    try {
      return await _channel.invokeMethod<String>('getForegroundApp');
    } catch (_) {
      return null;
    }
  }

  Future<void> syncUsage() async {
    if (!await hasAccess()) return;

    try {
      final endMs = DateTime.now().millisecondsSinceEpoch;
      // Fetch the last 7 days of usage stats
      final startMs = DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;

      final result = await _channel.invokeMethod<List<dynamic>>(
        'queryHourlyScreenBuckets',
        {'startMs': startMs, 'endMs': endMs},
      );

      if (result != null) {
        final buckets = result.map((item) {
          final map = Map<String, dynamic>.from(item);
          final date =
              DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
          return UsageBucket(
            day: date.year * 10000 + date.month * 100 + date.day,
            hour: date.hour,
            screenMinutes: map['screenMinutes'] as int,
            unlocks: map['unlocks'] as int,
          );
        }).toList();

        await _db.upsertUsageBuckets(buckets);
      }

      // Also sync granular timeline sessions for the last 7 days
      final timelineResult = await _channel.invokeMethod<List<dynamic>>(
          'queryUsageTimeline',
          {'startMs': startMs, 'endMs': endMs},
      );

      if (timelineResult != null) {
          final sessions = timelineResult.map((item) {
              final map = Map<String, dynamic>.from(item);
              return AppUsageSession(

                  packageName: map['packageName'] as String,
                  startTime: map['startTime'] as int,
                  endTime: map['endTime'] as int,
              );
          }).toList();
          await _db.insertAppUsageSessions(sessions);
      }

    } catch (_) {
      // Fail-soft: swallow errors, app never degrades
    }
  }
}
