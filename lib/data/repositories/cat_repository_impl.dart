import 'package:catinder/domain/entities/liked_cat.dart';

import '../../domain/repositories/cat_repository.dart';
import '../datasources/local_liked_cat_datasource.dart';
import '../datasources/remote_cat_datasource.dart';
import '../../domain/entities/cat.dart';

class CatRepositoryImpl implements CatRepository {
  final RemoteCatDatasource remote;
  final LocalLikedCatDatasource local;

  CatRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Cat> getRandomCat() async {
    final dto = await remote.fetchRandomCat();
    if (dto == null) {
      throw Exception('Empty response from API');
    }

    return Cat.fromDTO(dto);
  }

  @override
  Future<void> dislikeCat(Cat cat) async {
    await remote.vote(cat.id, -1);
  }

  @override
  Future<void> likeCat(Cat cat) async {
    await remote.vote(cat.id, 1);
    await local.save(LikedCat(cat: cat, likedAt: DateTime.now()));
  }

  @override
  Future<void> removeLike(String catId) => local.remove(catId);

  @override
  Stream<List<LikedCat>> watchLikedCats() => local.watchAll();
}
