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
  }) {
    return _db.insertEvent(
      UrgeEventsCompanion.insert(
        createdAt: DateTime.now(),
        feeling: feeling.label,
        substitute: Value(substitute),
        outcome: outcome.value,
      ),
    );
  }

  Future<int> eventCount() => _db.countEvents();

  Future<List<UrgeEvent>> allEvents() => _db.getAllEvents();
}
