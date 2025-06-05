import '../../domain/entities/cat.dart';
import '../local/app_database.dart';

class LocalCatDatasource {
  final AppDatabase db;
  LocalCatDatasource(this.db);

  Future<void> save(Cat cat) => db.cacheCat(cat);
  Future<Cat?> getRandom() => db.getRandomCachedCat();
}
