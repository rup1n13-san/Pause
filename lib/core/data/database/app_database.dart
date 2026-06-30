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
}

@DriftDatabase(tables: [UrgeEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory database for tests (no path_provider / platform channels).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pause.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
