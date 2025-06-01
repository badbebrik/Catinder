import 'package:catinder/domain/entities/liked_cat.dart';

import '../../domain/repositories/cat_repository.dart';
import '../datasources/local_cat_datasource.dart';
import '../datasources/remote_cat_datasource.dart';
import '../../domain/entities/cat.dart';
import '../local/app_database.dart';

class CatRepositoryImpl implements CatRepository {
  final RemoteCatDatasource remote;
  final LocalCatDatasource local;
  final AppDatabase db;

  CatRepositoryImpl({
    required this.remote,
    required this.local,
    required this.db,
  });

  @override
  Future<Cat> getRandomCat() async {
    try {
      final dto = await remote.fetchRandomCat();
      if (dto == null) throw Exception('Empty response');
      final cat = Cat.fromDTO(dto);
      await local.save(cat);
      return cat;
    } catch (_) {
      final cached = await local.getRandom();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<void> likeCat(Cat cat) async {
    await remote.vote(cat.id, 1);
    await db.cacheCat(cat);
    await db.likeCat(cat);
  }

  @override
  Future<void> dislikeCat(Cat cat) => remote.vote(cat.id, -1);

  @override
  Future<void> removeLike(String catId) => db.removeLike(catId);

  @override
  Stream<List<LikedCat>> watchLikedCats() => db.watchLiked();
}
