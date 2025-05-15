import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class LikeCat {
  final CatRepository repo;
  LikeCat(this.repo);
  Future<void> call(Cat cat) => repo.likeCat(cat);
}