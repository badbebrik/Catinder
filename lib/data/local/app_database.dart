import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/cat.dart';
import '../../domain/entities/liked_cat.dart';
import '../dto/cat_dto.dart';

part 'app_database.g.dart';

class CachedCats extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class LikedCatsTable extends Table {
  TextColumn get catId => text()();
  DateTimeColumn get likedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {catId};
}

Cat _catFromJson(String raw) =>
    Cat.fromDTO(CatDTO.fromJson(jsonDecode(raw) as Map<String, dynamic>));
String _catToJson(Cat cat) => jsonEncode({
      'id': cat.id,
      'url': cat.imageUrl,
      'width': cat.width,
      'height': cat.height,
      'mime_type': cat.mimeType,
      'breeds': cat.breed == null ? [] : [_breedToMap(cat.breed!)],
    });

Map<String, dynamic> _breedToMap(Breed b) => {
      'id': b.id,
      'name': b.name,
      'weight': {'metric': b.weight},
      'temperament': b.temperament,
      'origin': b.origin,
      'description': b.description,
      'life_span': b.lifeSpan,
    };

@DriftDatabase(tables: [CachedCats, LikedCatsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  Future<void> cacheCat(Cat cat) => into(cachedCats).insertOnConflictUpdate(
        CachedCatsCompanion(
          id: Value(cat.id),
          json: Value(_catToJson(cat)),
        ),
      );

  Future<Cat?> getRandomCachedCat() async {
    final row = await customSelect(
      'SELECT * FROM cached_cats ORDER BY RANDOM() LIMIT 1',
    ).getSingleOrNull();
    if (row == null) return null;
    return _catFromJson(row.read<String>('json'));
  }

  Stream<List<LikedCat>> watchLiked() {
    final joined = select(likedCatsTable).join([
      innerJoin(
        cachedCats,
        cachedCats.id.equalsExp(likedCatsTable.catId),
      ),
    ])
      ..orderBy([
        OrderingTerm(
          expression: likedCatsTable.likedAt,
          mode: OrderingMode.desc,
        ),
      ]);

    return joined.watch().map((rows) {
      return rows.map((row) {
        final catJson = row.readTable(cachedCats).json;
        final cat = _catFromJson(catJson);
        final likedAt = row.readTable(likedCatsTable).likedAt;
        return LikedCat(cat: cat, likedAt: likedAt);
      }).toList();
    });
  }

  Future<void> likeCat(Cat cat) async {
    await batch((b) {
      b.insert(
        likedCatsTable,
        LikedCatsTableCompanion.insert(catId: cat.id),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> removeLike(String catId) =>
      (delete(likedCatsTable)..where((t) => t.catId.equals(catId))).go();
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'catinder.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
