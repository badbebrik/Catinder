import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class DislikeCat {
  final CatRepository repo;
  DislikeCat(this.repo);
  Future<void> call(Cat cat) => repo.dislikeCat(cat);
}