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
  static const VerificationMeta _withinInvitationWindowMeta =
      const VerificationMeta('withinInvitationWindow');
  @override
  late final GeneratedColumn<bool> withinInvitationWindow =
      GeneratedColumn<bool>('within_invitation_window', aliasedName, true,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("within_invitation_window" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, feeling, substitute, outcome, withinInvitationWindow];
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
    if (data.containsKey('within_invitation_window')) {
      context.handle(
          _withinInvitationWindowMeta,
          withinInvitationWindow.isAcceptableOrUnknown(
              data['within_invitation_window']!, _withinInvitationWindowMeta));
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
      withinInvitationWindow: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}within_invitation_window']),
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
  final bool? withinInvitationWindow;
  const UrgeEvent(
      {required this.id,
      required this.createdAt,
      required this.feeling,
      this.substitute,
      required this.outcome,
      this.withinInvitationWindow});
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
    if (!nullToAbsent || withinInvitationWindow != null) {
      map['within_invitation_window'] = Variable<bool>(withinInvitationWindow);
    }
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
      withinInvitationWindow: withinInvitationWindow == null && nullToAbsent
          ? const Value.absent()
          : Value(withinInvitationWindow),
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
      withinInvitationWindow:
          serializer.fromJson<bool?>(json['withinInvitationWindow']),
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
      'withinInvitationWindow':
          serializer.toJson<bool?>(withinInvitationWindow),
    };
  }

  UrgeEvent copyWith(
          {int? id,
          DateTime? createdAt,
          String? feeling,
          Value<String?> substitute = const Value.absent(),
          String? outcome,
          Value<bool?> withinInvitationWindow = const Value.absent()}) =>
      UrgeEvent(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        feeling: feeling ?? this.feeling,
        substitute: substitute.present ? substitute.value : this.substitute,
        outcome: outcome ?? this.outcome,
        withinInvitationWindow: withinInvitationWindow.present
            ? withinInvitationWindow.value
            : this.withinInvitationWindow,
      );
  UrgeEvent copyWithCompanion(UrgeEventsCompanion data) {
    return UrgeEvent(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      substitute:
          data.substitute.present ? data.substitute.value : this.substitute,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      withinInvitationWindow: data.withinInvitationWindow.present
          ? data.withinInvitationWindow.value
          : this.withinInvitationWindow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UrgeEvent(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('feeling: $feeling, ')
          ..write('substitute: $substitute, ')
          ..write('outcome: $outcome, ')
          ..write('withinInvitationWindow: $withinInvitationWindow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createdAt, feeling, substitute, outcome, withinInvitationWindow);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UrgeEvent &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.feeling == this.feeling &&
          other.substitute == this.substitute &&
          other.outcome == this.outcome &&
          other.withinInvitationWindow == this.withinInvitationWindow);
}

class UrgeEventsCompanion extends UpdateCompanion<UrgeEvent> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> feeling;
  final Value<String?> substitute;
  final Value<String> outcome;
  final Value<bool?> withinInvitationWindow;
  const UrgeEventsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.feeling = const Value.absent(),
    this.substitute = const Value.absent(),
    this.outcome = const Value.absent(),
    this.withinInvitationWindow = const Value.absent(),
  });
  UrgeEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String feeling,
    this.substitute = const Value.absent(),
    required String outcome,
    this.withinInvitationWindow = const Value.absent(),
  })  : createdAt = Value(createdAt),
        feeling = Value(feeling),
        outcome = Value(outcome);
  static Insertable<UrgeEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? feeling,
    Expression<String>? substitute,
    Expression<String>? outcome,
    Expression<bool>? withinInvitationWindow,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (feeling != null) 'feeling': feeling,
      if (substitute != null) 'substitute': substitute,
      if (outcome != null) 'outcome': outcome,
      if (withinInvitationWindow != null)
        'within_invitation_window': withinInvitationWindow,
    });
  }

  UrgeEventsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<String>? feeling,
      Value<String?>? substitute,
      Value<String>? outcome,
      Value<bool?>? withinInvitationWindow}) {
    return UrgeEventsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      feeling: feeling ?? this.feeling,
      substitute: substitute ?? this.substitute,
      outcome: outcome ?? this.outcome,
      withinInvitationWindow:
          withinInvitationWindow ?? this.withinInvitationWindow,
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
    if (withinInvitationWindow.present) {
      map['within_invitation_window'] =
          Variable<bool>(withinInvitationWindow.value);
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
          ..write('outcome: $outcome, ')
          ..write('withinInvitationWindow: $withinInvitationWindow')
          ..write(')'))
        .toString();
  }
}

class $UsageBucketsTable extends UsageBuckets
    with TableInfo<$UsageBucketsTable, UsageBucket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
      'day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _screenMinutesMeta =
      const VerificationMeta('screenMinutes');
  @override
  late final GeneratedColumn<int> screenMinutes = GeneratedColumn<int>(
      'screen_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unlocksMeta =
      const VerificationMeta('unlocks');
  @override
  late final GeneratedColumn<int> unlocks = GeneratedColumn<int>(
      'unlocks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [day, hour, screenMinutes, unlocks];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_buckets';
  @override
  VerificationContext validateIntegrity(Insertable<UsageBucket> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('screen_minutes')) {
      context.handle(
          _screenMinutesMeta,
          screenMinutes.isAcceptableOrUnknown(
              data['screen_minutes']!, _screenMinutesMeta));
    } else if (isInserting) {
      context.missing(_screenMinutesMeta);
    }
    if (data.containsKey('unlocks')) {
      context.handle(_unlocksMeta,
          unlocks.isAcceptableOrUnknown(data['unlocks']!, _unlocksMeta));
    } else if (isInserting) {
      context.missing(_unlocksMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day, hour};
  @override
  UsageBucket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageBucket(
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      screenMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}screen_minutes'])!,
      unlocks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unlocks'])!,
    );
  }

  @override
  $UsageBucketsTable createAlias(String alias) {
    return $UsageBucketsTable(attachedDatabase, alias);
  }
}

class UsageBucket extends DataClass implements Insertable<UsageBucket> {
  final int day;
  final int hour;
  final int screenMinutes;
  final int unlocks;
  const UsageBucket(
      {required this.day,
      required this.hour,
      required this.screenMinutes,
      required this.unlocks});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['hour'] = Variable<int>(hour);
    map['screen_minutes'] = Variable<int>(screenMinutes);
    map['unlocks'] = Variable<int>(unlocks);
    return map;
  }

  UsageBucketsCompanion toCompanion(bool nullToAbsent) {
    return UsageBucketsCompanion(
      day: Value(day),
      hour: Value(hour),
      screenMinutes: Value(screenMinutes),
      unlocks: Value(unlocks),
    );
  }

  factory UsageBucket.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageBucket(
      day: serializer.fromJson<int>(json['day']),
      hour: serializer.fromJson<int>(json['hour']),
      screenMinutes: serializer.fromJson<int>(json['screenMinutes']),
      unlocks: serializer.fromJson<int>(json['unlocks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'hour': serializer.toJson<int>(hour),
      'screenMinutes': serializer.toJson<int>(screenMinutes),
      'unlocks': serializer.toJson<int>(unlocks),
    };
  }

  UsageBucket copyWith(
          {int? day, int? hour, int? screenMinutes, int? unlocks}) =>
      UsageBucket(
        day: day ?? this.day,
        hour: hour ?? this.hour,
        screenMinutes: screenMinutes ?? this.screenMinutes,
        unlocks: unlocks ?? this.unlocks,
      );
  UsageBucket copyWithCompanion(UsageBucketsCompanion data) {
    return UsageBucket(
      day: data.day.present ? data.day.value : this.day,
      hour: data.hour.present ? data.hour.value : this.hour,
      screenMinutes: data.screenMinutes.present
          ? data.screenMinutes.value
          : this.screenMinutes,
      unlocks: data.unlocks.present ? data.unlocks.value : this.unlocks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageBucket(')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('screenMinutes: $screenMinutes, ')
          ..write('unlocks: $unlocks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, hour, screenMinutes, unlocks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageBucket &&
          other.day == this.day &&
          other.hour == this.hour &&
          other.screenMinutes == this.screenMinutes &&
          other.unlocks == this.unlocks);
}

class UsageBucketsCompanion extends UpdateCompanion<UsageBucket> {
  final Value<int> day;
  final Value<int> hour;
  final Value<int> screenMinutes;
  final Value<int> unlocks;
  final Value<int> rowid;
  const UsageBucketsCompanion({
    this.day = const Value.absent(),
    this.hour = const Value.absent(),
    this.screenMinutes = const Value.absent(),
    this.unlocks = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageBucketsCompanion.insert({
    required int day,
    required int hour,
    required int screenMinutes,
    required int unlocks,
    this.rowid = const Value.absent(),
  })  : day = Value(day),
        hour = Value(hour),
        screenMinutes = Value(screenMinutes),
        unlocks = Value(unlocks);
  static Insertable<UsageBucket> custom({
    Expression<int>? day,
    Expression<int>? hour,
    Expression<int>? screenMinutes,
    Expression<int>? unlocks,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (hour != null) 'hour': hour,
      if (screenMinutes != null) 'screen_minutes': screenMinutes,
      if (unlocks != null) 'unlocks': unlocks,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageBucketsCompanion copyWith(
      {Value<int>? day,
      Value<int>? hour,
      Value<int>? screenMinutes,
      Value<int>? unlocks,
      Value<int>? rowid}) {
    return UsageBucketsCompanion(
      day: day ?? this.day,
      hour: hour ?? this.hour,
      screenMinutes: screenMinutes ?? this.screenMinutes,
      unlocks: unlocks ?? this.unlocks,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (screenMinutes.present) {
      map['screen_minutes'] = Variable<int>(screenMinutes.value);
    }
    if (unlocks.present) {
      map['unlocks'] = Variable<int>(unlocks.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageBucketsCompanion(')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('screenMinutes: $screenMinutes, ')
          ..write('unlocks: $unlocks, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UrgeEventsTable urgeEvents = $UrgeEventsTable(this);
  late final $UsageBucketsTable usageBuckets = $UsageBucketsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [urgeEvents, usageBuckets];
}

typedef $$UrgeEventsTableCreateCompanionBuilder = UrgeEventsCompanion Function({
  Value<int> id,
  required DateTime createdAt,
  required String feeling,
  Value<String?> substitute,
  required String outcome,
  Value<bool?> withinInvitationWindow,
});
typedef $$UrgeEventsTableUpdateCompanionBuilder = UrgeEventsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<String> feeling,
  Value<String?> substitute,
  Value<String> outcome,
  Value<bool?> withinInvitationWindow,
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

  ColumnFilters<bool> get withinInvitationWindow => $composableBuilder(
      column: $table.withinInvitationWindow,
      builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<bool> get withinInvitationWindow => $composableBuilder(
      column: $table.withinInvitationWindow,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<bool> get withinInvitationWindow => $composableBuilder(
      column: $table.withinInvitationWindow, builder: (column) => column);
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
            Value<bool?> withinInvitationWindow = const Value.absent(),
          }) =>
              UrgeEventsCompanion(
            id: id,
            createdAt: createdAt,
            feeling: feeling,
            substitute: substitute,
            outcome: outcome,
            withinInvitationWindow: withinInvitationWindow,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime createdAt,
            required String feeling,
            Value<String?> substitute = const Value.absent(),
            required String outcome,
            Value<bool?> withinInvitationWindow = const Value.absent(),
          }) =>
              UrgeEventsCompanion.insert(
            id: id,
            createdAt: createdAt,
            feeling: feeling,
            substitute: substitute,
            outcome: outcome,
            withinInvitationWindow: withinInvitationWindow,
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
typedef $$UsageBucketsTableCreateCompanionBuilder = UsageBucketsCompanion
    Function({
  required int day,
  required int hour,
  required int screenMinutes,
  required int unlocks,
  Value<int> rowid,
});
typedef $$UsageBucketsTableUpdateCompanionBuilder = UsageBucketsCompanion
    Function({
  Value<int> day,
  Value<int> hour,
  Value<int> screenMinutes,
  Value<int> unlocks,
  Value<int> rowid,
});

class $$UsageBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $UsageBucketsTable> {
  $$UsageBucketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get screenMinutes => $composableBuilder(
      column: $table.screenMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlocks => $composableBuilder(
      column: $table.unlocks, builder: (column) => ColumnFilters(column));
}

class $$UsageBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageBucketsTable> {
  $$UsageBucketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get screenMinutes => $composableBuilder(
      column: $table.screenMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlocks => $composableBuilder(
      column: $table.unlocks, builder: (column) => ColumnOrderings(column));
}

class $$UsageBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageBucketsTable> {
  $$UsageBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get screenMinutes => $composableBuilder(
      column: $table.screenMinutes, builder: (column) => column);

  GeneratedColumn<int> get unlocks =>
      $composableBuilder(column: $table.unlocks, builder: (column) => column);
}

class $$UsageBucketsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsageBucketsTable,
    UsageBucket,
    $$UsageBucketsTableFilterComposer,
    $$UsageBucketsTableOrderingComposer,
    $$UsageBucketsTableAnnotationComposer,
    $$UsageBucketsTableCreateCompanionBuilder,
    $$UsageBucketsTableUpdateCompanionBuilder,
    (
      UsageBucket,
      BaseReferences<_$AppDatabase, $UsageBucketsTable, UsageBucket>
    ),
    UsageBucket,
    PrefetchHooks Function()> {
  $$UsageBucketsTableTableManager(_$AppDatabase db, $UsageBucketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageBucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageBucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageBucketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> day = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> screenMinutes = const Value.absent(),
            Value<int> unlocks = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsageBucketsCompanion(
            day: day,
            hour: hour,
            screenMinutes: screenMinutes,
            unlocks: unlocks,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int day,
            required int hour,
            required int screenMinutes,
            required int unlocks,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsageBucketsCompanion.insert(
            day: day,
            hour: hour,
            screenMinutes: screenMinutes,
            unlocks: unlocks,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsageBucketsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsageBucketsTable,
    UsageBucket,
    $$UsageBucketsTableFilterComposer,
    $$UsageBucketsTableOrderingComposer,
    $$UsageBucketsTableAnnotationComposer,
    $$UsageBucketsTableCreateCompanionBuilder,
    $$UsageBucketsTableUpdateCompanionBuilder,
    (
      UsageBucket,
      BaseReferences<_$AppDatabase, $UsageBucketsTable, UsageBucket>
    ),
    UsageBucket,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UrgeEventsTableTableManager get urgeEvents =>
      $$UrgeEventsTableTableManager(_db, _db.urgeEvents);
  $$UsageBucketsTableTableManager get usageBuckets =>
      $$UsageBucketsTableTableManager(_db, _db.usageBuckets);
}
