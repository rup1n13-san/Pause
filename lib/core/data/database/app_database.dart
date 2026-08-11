import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// One "showed up" moment. Substitute is nullable (the run can end at any step);
/// outcome is 'passed' or 'not_yet'.
class UrgeEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get feeling => text()();
  TextColumn get substitute => text().nullable()();
  TextColumn get outcome => text()();
  BoolColumn get withinInvitationWindow => boolean().nullable()();
}

/// Hourly aggregated usage stats.
class UsageBuckets extends Table {
  IntColumn get day => integer()();
  IntColumn get hour => integer()();
  IntColumn get screenMinutes => integer()();
  IntColumn get unlocks => integer()();

  @override
  Set<Column> get primaryKey => {day, hour};
}

/// Granular app usage sessions.
class AppUsageSessions extends Table {
  TextColumn get packageName => text()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer()();

  @override
  Set<Column> get primaryKey => {packageName, startTime, endTime};
}

@DriftDatabase(tables: [UrgeEvents, UsageBuckets, AppUsageSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory database for tests (no path_provider / platform channels).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(urgeEvents, urgeEvents.withinInvitationWindow);
        }
        if (from < 3) {
          await m.createTable(usageBuckets);
        }
        if (from < 5) {
          // Changed schema for AppUsageSessions to have composite primary key
          await m.createTable(appUsageSessions);
        }
      },
    );
  }

  Future<int> insertEvent(UrgeEventsCompanion entry) =>
      into(urgeEvents).insert(entry);

  Future<int> countEvents() async {
    final count = urgeEvents.id.count();
    final query = selectOnly(urgeEvents)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<UrgeEvent>> getAllEvents() => (select(
        urgeEvents,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pause.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
