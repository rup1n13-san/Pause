// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UrgeEventsTable extends UrgeEvents
    with TableInfo<$UrgeEventsTable, UrgeEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UrgeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _feelingMeta =
      const VerificationMeta('feeling');
  @override
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
      'feeling', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _substituteMeta =
      const VerificationMeta('substitute');
  @override
  late final GeneratedColumn<String> substitute = GeneratedColumn<String>(
      'substitute', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outcomeMeta =
      const VerificationMeta('outcome');
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
      'outcome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, feeling, substitute, outcome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'urge_events';
  @override
  VerificationContext validateIntegrity(Insertable<UrgeEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('feeling')) {
      context.handle(_feelingMeta,
          feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta));
    } else if (isInserting) {
      context.missing(_feelingMeta);
    }
    if (data.containsKey('substitute')) {
      context.handle(
          _substituteMeta,
          substitute.isAcceptableOrUnknown(
              data['substitute']!, _substituteMeta));
    }
    if (data.containsKey('outcome')) {
      context.handle(_outcomeMeta,
          outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta));
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UrgeEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UrgeEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      feeling: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feeling'])!,
      substitute: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}substitute']),
      outcome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}outcome'])!,
    );
  }

  @override
  $UrgeEventsTable createAlias(String alias) {
    return $UrgeEventsTable(attachedDatabase, alias);
  }
}

class UrgeEvent extends DataClass implements Insertable<UrgeEvent> {
  final int id;
  final DateTime createdAt;
  final String feeling;
  final String? substitute;
  final String outcome;
  const UrgeEvent(
      {required this.id,
      required this.createdAt,
      required this.feeling,
      this.substitute,
      required this.outcome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['feeling'] = Variable<String>(feeling);
    if (!nullToAbsent || substitute != null) {
      map['substitute'] = Variable<String>(substitute);
    }
    map['outcome'] = Variable<String>(outcome);
    return map;
  }

  UrgeEventsCompanion toCompanion(bool nullToAbsent) {
    return UrgeEventsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      feeling: Value(feeling),
      substitute: substitute == null && nullToAbsent
          ? const Value.absent()
          : Value(substitute),
      outcome: Value(outcome),
    );
  }

  factory UrgeEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UrgeEvent(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      feeling: serializer.fromJson<String>(json['feeling']),
      substitute: serializer.fromJson<String?>(json['substitute']),
      outcome: serializer.fromJson<String>(json['outcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'feeling': serializer.toJson<String>(feeling),
      'substitute': serializer.toJson<String?>(substitute),
      'outcome': serializer.toJson<String>(outcome),
    };
  }

  UrgeEvent copyWith(
          {int? id,
          DateTime? createdAt,
          String? feeling,
          Value<String?> substitute = const Value.absent(),
          String? outcome}) =>
      UrgeEvent(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        feeling: feeling ?? this.feeling,
        substitute: substitute.present ? substitute.value : this.substitute,
        outcome: outcome ?? this.outcome,
      );
  UrgeEvent copyWithCompanion(UrgeEventsCompanion data) {
    return UrgeEvent(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      substitute:
          data.substitute.present ? data.substitute.value : this.substitute,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UrgeEvent(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('feeling: $feeling, ')
          ..write('substitute: $substitute, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, feeling, substitute, outcome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UrgeEvent &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.feeling == this.feeling &&
          other.substitute == this.substitute &&
          other.outcome == this.outcome);
}

class UrgeEventsCompanion extends UpdateCompanion<UrgeEvent> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> feeling;
  final Value<String?> substitute;
  final Value<String> outcome;
  const UrgeEventsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.feeling = const Value.absent(),
    this.substitute = const Value.absent(),
    this.outcome = const Value.absent(),
  });
  UrgeEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String feeling,
    this.substitute = const Value.absent(),
    required String outcome,
  })  : createdAt = Value(createdAt),
        feeling = Value(feeling),
        outcome = Value(outcome);
  static Insertable<UrgeEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? feeling,
    Expression<String>? substitute,
    Expression<String>? outcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (feeling != null) 'feeling': feeling,
      if (substitute != null) 'substitute': substitute,
      if (outcome != null) 'outcome': outcome,
    });
  }

  UrgeEventsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<String>? feeling,
      Value<String?>? substitute,
      Value<String>? outcome}) {
    return UrgeEventsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      feeling: feeling ?? this.feeling,
      substitute: substitute ?? this.substitute,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (substitute.present) {
      map['substitute'] = Variable<String>(substitute.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UrgeEventsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('feeling: $feeling, ')
          ..write('substitute: $substitute, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UrgeEventsTable urgeEvents = $UrgeEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [urgeEvents];
}

typedef $$UrgeEventsTableCreateCompanionBuilder = UrgeEventsCompanion Function({
  Value<int> id,
  required DateTime createdAt,
  required String feeling,
  Value<String?> substitute,
  required String outcome,
});
typedef $$UrgeEventsTableUpdateCompanionBuilder = UrgeEventsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<String> feeling,
  Value<String?> substitute,
  Value<String> outcome,
});

class $$UrgeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feeling => $composableBuilder(
      column: $table.feeling, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get substitute => $composableBuilder(
      column: $table.substitute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outcome => $composableBuilder(
      column: $table.outcome, builder: (column) => ColumnFilters(column));
}

class $$UrgeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feeling => $composableBuilder(
      column: $table.feeling, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get substitute => $composableBuilder(
      column: $table.substitute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outcome => $composableBuilder(
      column: $table.outcome, builder: (column) => ColumnOrderings(column));
}

class $$UrgeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<String> get substitute => $composableBuilder(
      column: $table.substitute, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);
}

class $$UrgeEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UrgeEventsTable,
    UrgeEvent,
    $$UrgeEventsTableFilterComposer,
    $$UrgeEventsTableOrderingComposer,
    $$UrgeEventsTableAnnotationComposer,
    $$UrgeEventsTableCreateCompanionBuilder,
    $$UrgeEventsTableUpdateCompanionBuilder,
    (UrgeEvent, BaseReferences<_$AppDatabase, $UrgeEventsTable, UrgeEvent>),
    UrgeEvent,
    PrefetchHooks Function()> {
  $$UrgeEventsTableTableManager(_$AppDatabase db, $UrgeEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UrgeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UrgeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UrgeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> feeling = const Value.absent(),
            Value<String?> substitute = const Value.absent(),
            Value<String> outcome = const Value.absent(),
          }) =>
              UrgeEventsCompanion(
            id: id,
            createdAt: createdAt,
            feeling: feeling,
            substitute: substitute,
            outcome: outcome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime createdAt,
            required String feeling,
            Value<String?> substitute = const Value.absent(),
            required String outcome,
          }) =>
              UrgeEventsCompanion.insert(
            id: id,
            createdAt: createdAt,
            feeling: feeling,
            substitute: substitute,
            outcome: outcome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UrgeEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UrgeEventsTable,
    UrgeEvent,
    $$UrgeEventsTableFilterComposer,
    $$UrgeEventsTableOrderingComposer,
    $$UrgeEventsTableAnnotationComposer,
    $$UrgeEventsTableCreateCompanionBuilder,
    $$UrgeEventsTableUpdateCompanionBuilder,
    (UrgeEvent, BaseReferences<_$AppDatabase, $UrgeEventsTable, UrgeEvent>),
    UrgeEvent,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UrgeEventsTableTableManager get urgeEvents =>
      $$UrgeEventsTableTableManager(_db, _db.urgeEvents);
}
