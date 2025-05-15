import 'package:catinder/domain/entities/liked_cat.dart';

import '../entities/cat.dart';

abstract class CatRepository {
  Future<Cat> getRandomCat();
  Future<void> likeCat(Cat cat);
  Future<void> dislikeCat(Cat cat);
  Future<void> removeLike(String catId);
  Stream<List<LikedCat>> watchLikedCats();
}