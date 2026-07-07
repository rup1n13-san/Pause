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
}
