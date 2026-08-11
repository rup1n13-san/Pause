import 'package:drift/drift.dart';
import 'package:mobile/core/data/database/app_database.dart';
import 'package:mobile/core/models/pause_enums.dart';

/// Thin app-facing wrapper over the Drift database. All event persistence
/// goes through here so ViewModels never touch Drift directly.
class DatabaseService {
  final AppDatabase _db = AppDatabase();

  Future<int> recordEvent({
    required Feeling feeling,
    String? substitute,
    required UrgeOutcome outcome,
    bool? withinInvitationWindow,
  }) {
    return _db.insertEvent(
      UrgeEventsCompanion.insert(
        createdAt: DateTime.now(),
        feeling: feeling.label,
        substitute: Value(substitute),
        outcome: outcome.value,
        withinInvitationWindow: Value(withinInvitationWindow),
      ),
    );
  }

  Future<int> eventCount() => _db.countEvents();

  Future<List<UrgeEvent>> allEvents() => _db.getAllEvents();

  Future<void> upsertUsageBuckets(List<UsageBucket> buckets) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.usageBuckets,
        buckets.map((b) => UsageBucketsCompanion.insert(
              day: b.day,
              hour: b.hour,
              screenMinutes: b.screenMinutes,
              unlocks: b.unlocks,
            )),
      );
    });
  }

  Future<List<UsageBucket>> getUsageBucketsSince(DateTime since) {
    final sinceDay = since.year * 10000 + since.month * 100 + since.day;
    return (_db.select(_db.usageBuckets)
          ..where((t) => t.day.isBiggerOrEqualValue(sinceDay)))
        .get();
  }

  Future<void> insertAppUsageSessions(List<AppUsageSession> sessions) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.appUsageSessions,
        sessions.map((s) => AppUsageSessionsCompanion.insert(
              packageName: s.packageName,
              startTime: s.startTime,
              endTime: s.endTime,
            )),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<List<AppUsageSession>> getAppUsageSessionsForDay(DateTime day) {
    final startOfDay = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    return (_db.select(_db.appUsageSessions)
          ..where((t) => t.startTime.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(t) => OrderingTerm(expression: t.startTime)]))
        .get();
  }
}
