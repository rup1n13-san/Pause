import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database/app_database.dart';
import 'package:sqlite3/open.dart';

// On-device, sqlite3_flutter_libs bundles the native lib. Host test VMs may not
// have libsqlite3 on the linker path, so point drift at one if we can find it;
// otherwise skip rather than fail (the write path is also verified on device).
bool _prepareSqlite() {
  if (!Platform.isLinux) return true;
  const candidates = [
    'libsqlite3.so',
    'libsqlite3.so.0',
    '/snap/core20/2866/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
    '/snap/gnome-46-2404/153/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
  ];
  for (final candidate in candidates) {
    try {
      final lib = DynamicLibrary.open(candidate);
      open.overrideFor(OperatingSystem.linux, () => lib);
      return true;
    } catch (_) {
      // try the next candidate
    }
  }
  return false;
}

void main() {
  final skipReason = _prepareSqlite()
      ? null
      : 'libsqlite3 not available on this host';

  group('AppDatabase write path -', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('a completed run writes one well-formed event row', () async {
      await db.insertEvent(
        UrgeEventsCompanion.insert(
          createdAt: DateTime(2026, 6, 30, 22, 0),
          feeling: 'Bored',
          substitute: const Value('Walk'),
          outcome: 'passed',
        ),
      );

      expect(await db.countEvents(), 1);

      final row = (await db.getAllEvents()).single;
      expect(row.feeling, 'Bored');
      expect(row.substitute, 'Walk');
      expect(row.outcome, 'passed');
    });

    test('substitute is nullable (run can end without one)', () async {
      await db.insertEvent(
        UrgeEventsCompanion.insert(
          createdAt: DateTime(2026, 6, 30, 23, 0),
          feeling: 'Autopilot',
          outcome: 'not_yet',
        ),
      );

      final row = (await db.getAllEvents()).single;
      expect(row.substitute, isNull);
      expect(row.outcome, 'not_yet');
    });
  }, skip: skipReason);
}
