// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedCatsTable extends CachedCats
    with TableInfo<$CachedCatsTable, CachedCat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_cats';
  @override
  VerificationContext validateIntegrity(Insertable<CachedCat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
    );
  }

  @override
  $CachedCatsTable createAlias(String alias) {
    return $CachedCatsTable(attachedDatabase, alias);
  }
}

class CachedCat extends DataClass implements Insertable<CachedCat> {
  final String id;
  final String json;
  const CachedCat({required this.id, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    return map;
  }

  CachedCatsCompanion toCompanion(bool nullToAbsent) {
    return CachedCatsCompanion(
      id: Value(id),
      json: Value(json),
    );
  }

  factory CachedCat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCat(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
    };
  }

  CachedCat copyWith({String? id, String? json}) => CachedCat(
        id: id ?? this.id,
        json: json ?? this.json,
      );
  CachedCat copyWithCompanion(CachedCatsCompanion data) {
    return CachedCat(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCat(')
          ..write('id: $id, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCat && other.id == this.id && other.json == this.json);
}

class CachedCatsCompanion extends UpdateCompanion<CachedCat> {
  final Value<String> id;
  final Value<String> json;
  final Value<int> rowid;
  const CachedCatsCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCatsCompanion.insert({
    required String id,
    required String json,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        json = Value(json);
  static Insertable<CachedCat> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCatsCompanion copyWith(
      {Value<String>? id, Value<String>? json, Value<int>? rowid}) {
    return CachedCatsCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCatsCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LikedCatsTableTable extends LikedCatsTable
    with TableInfo<$LikedCatsTableTable, LikedCatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LikedCatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
      'cat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _likedAtMeta =
      const VerificationMeta('likedAt');
  @override
  late final GeneratedColumn<DateTime> likedAt = GeneratedColumn<DateTime>(
      'liked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [catId, likedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liked_cats_table';
  @override
  VerificationContext validateIntegrity(Insertable<LikedCatsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cat_id')) {
      context.handle(
          _catIdMeta, catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta));
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('liked_at')) {
      context.handle(_likedAtMeta,
          likedAt.isAcceptableOrUnknown(data['liked_at']!, _likedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {catId};
  @override
  LikedCatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LikedCatsTableData(
      catId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cat_id'])!,
      likedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}liked_at'])!,
    );
  }

  @override
  $LikedCatsTableTable createAlias(String alias) {
    return $LikedCatsTableTable(attachedDatabase, alias);
  }
}

class LikedCatsTableData extends DataClass
    implements Insertable<LikedCatsTableData> {
  final String catId;
  final DateTime likedAt;
  const LikedCatsTableData({required this.catId, required this.likedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cat_id'] = Variable<String>(catId);
    map['liked_at'] = Variable<DateTime>(likedAt);
    return map;
  }

  LikedCatsTableCompanion toCompanion(bool nullToAbsent) {
    return LikedCatsTableCompanion(
      catId: Value(catId),
      likedAt: Value(likedAt),
    );
  }

  factory LikedCatsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LikedCatsTableData(
      catId: serializer.fromJson<String>(json['catId']),
      likedAt: serializer.fromJson<DateTime>(json['likedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'catId': serializer.toJson<String>(catId),
      'likedAt': serializer.toJson<DateTime>(likedAt),
    };
  }

  LikedCatsTableData copyWith({String? catId, DateTime? likedAt}) =>
      LikedCatsTableData(
        catId: catId ?? this.catId,
        likedAt: likedAt ?? this.likedAt,
      );
  LikedCatsTableData copyWithCompanion(LikedCatsTableCompanion data) {
    return LikedCatsTableData(
      catId: data.catId.present ? data.catId.value : this.catId,
      likedAt: data.likedAt.present ? data.likedAt.value : this.likedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LikedCatsTableData(')
          ..write('catId: $catId, ')
          ..write('likedAt: $likedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(catId, likedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikedCatsTableData &&
          other.catId == this.catId &&
          other.likedAt == this.likedAt);
}

class LikedCatsTableCompanion extends UpdateCompanion<LikedCatsTableData> {
  final Value<String> catId;
  final Value<DateTime> likedAt;
  final Value<int> rowid;
  const LikedCatsTableCompanion({
    this.catId = const Value.absent(),
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LikedCatsTableCompanion.insert({
    required String catId,
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : catId = Value(catId);
  static Insertable<LikedCatsTableData> custom({
    Expression<String>? catId,
    Expression<DateTime>? likedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (catId != null) 'cat_id': catId,
      if (likedAt != null) 'liked_at': likedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LikedCatsTableCompanion copyWith(
      {Value<String>? catId, Value<DateTime>? likedAt, Value<int>? rowid}) {
    return LikedCatsTableCompanion(
      catId: catId ?? this.catId,
      likedAt: likedAt ?? this.likedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (likedAt.present) {
      map['liked_at'] = Variable<DateTime>(likedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LikedCatsTableCompanion(')
          ..write('catId: $catId, ')
          ..write('likedAt: $likedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedCatsTable cachedCats = $CachedCatsTable(this);
  late final $LikedCatsTableTable likedCatsTable = $LikedCatsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedCats, likedCatsTable];
}

typedef $$CachedCatsTableCreateCompanionBuilder = CachedCatsCompanion Function({
  required String id,
  required String json,
  Value<int> rowid,
});
typedef $$CachedCatsTableUpdateCompanionBuilder = CachedCatsCompanion Function({
  Value<String> id,
  Value<String> json,
  Value<int> rowid,
});

class $$CachedCatsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCatsTable> {
  $$CachedCatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));
}

class $$CachedCatsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCatsTable> {
  $$CachedCatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));
}

class $$CachedCatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCatsTable> {
  $$CachedCatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$CachedCatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedCatsTable,
    CachedCat,
    $$CachedCatsTableFilterComposer,
    $$CachedCatsTableOrderingComposer,
    $$CachedCatsTableAnnotationComposer,
    $$CachedCatsTableCreateCompanionBuilder,
    $$CachedCatsTableUpdateCompanionBuilder,
    (CachedCat, BaseReferences<_$AppDatabase, $CachedCatsTable, CachedCat>),
    CachedCat,
    PrefetchHooks Function()> {
  $$CachedCatsTableTableManager(_$AppDatabase db, $CachedCatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCatsCompanion(
            id: id,
            json: json,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String json,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCatsCompanion.insert(
            id: id,
            json: json,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedCatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedCatsTable,
    CachedCat,
    $$CachedCatsTableFilterComposer,
    $$CachedCatsTableOrderingComposer,
    $$CachedCatsTableAnnotationComposer,
    $$CachedCatsTableCreateCompanionBuilder,
    $$CachedCatsTableUpdateCompanionBuilder,
    (CachedCat, BaseReferences<_$AppDatabase, $CachedCatsTable, CachedCat>),
    CachedCat,
    PrefetchHooks Function()>;
typedef $$LikedCatsTableTableCreateCompanionBuilder = LikedCatsTableCompanion
    Function({
  required String catId,
  Value<DateTime> likedAt,
  Value<int> rowid,
});
typedef $$LikedCatsTableTableUpdateCompanionBuilder = LikedCatsTableCompanion
    Function({
  Value<String> catId,
  Value<DateTime> likedAt,
  Value<int> rowid,
});

class $$LikedCatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LikedCatsTableTable> {
  $$LikedCatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get catId => $composableBuilder(
      column: $table.catId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get likedAt => $composableBuilder(
      column: $table.likedAt, builder: (column) => ColumnFilters(column));
}

class $$LikedCatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LikedCatsTableTable> {
  $$LikedCatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get catId => $composableBuilder(
      column: $table.catId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get likedAt => $composableBuilder(
      column: $table.likedAt, builder: (column) => ColumnOrderings(column));
}

class $$LikedCatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LikedCatsTableTable> {
  $$LikedCatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get catId =>
      $composableBuilder(column: $table.catId, builder: (column) => column);

  GeneratedColumn<DateTime> get likedAt =>
      $composableBuilder(column: $table.likedAt, builder: (column) => column);
}

class $$LikedCatsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LikedCatsTableTable,
    LikedCatsTableData,
    $$LikedCatsTableTableFilterComposer,
    $$LikedCatsTableTableOrderingComposer,
    $$LikedCatsTableTableAnnotationComposer,
    $$LikedCatsTableTableCreateCompanionBuilder,
    $$LikedCatsTableTableUpdateCompanionBuilder,
    (
      LikedCatsTableData,
      BaseReferences<_$AppDatabase, $LikedCatsTableTable, LikedCatsTableData>
    ),
    LikedCatsTableData,
    PrefetchHooks Function()> {
  $$LikedCatsTableTableTableManager(
      _$AppDatabase db, $LikedCatsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LikedCatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LikedCatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LikedCatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> catId = const Value.absent(),
            Value<DateTime> likedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LikedCatsTableCompanion(
            catId: catId,
            likedAt: likedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String catId,
            Value<DateTime> likedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LikedCatsTableCompanion.insert(
            catId: catId,
            likedAt: likedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LikedCatsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LikedCatsTableTable,
    LikedCatsTableData,
    $$LikedCatsTableTableFilterComposer,
    $$LikedCatsTableTableOrderingComposer,
    $$LikedCatsTableTableAnnotationComposer,
    $$LikedCatsTableTableCreateCompanionBuilder,
    $$LikedCatsTableTableUpdateCompanionBuilder,
    (
      LikedCatsTableData,
      BaseReferences<_$AppDatabase, $LikedCatsTableTable, LikedCatsTableData>
    ),
    LikedCatsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedCatsTableTableManager get cachedCats =>
      $$CachedCatsTableTableManager(_db, _db.cachedCats);
  $$LikedCatsTableTableTableManager get likedCatsTable =>
      $$LikedCatsTableTableTableManager(_db, _db.likedCatsTable);
}
