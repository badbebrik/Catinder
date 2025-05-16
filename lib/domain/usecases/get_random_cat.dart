import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class GetRandomCat {
  final CatRepository repo;
  GetRandomCat(this.repo);
  Future<Cat> call() => repo.getRandomCat();
}
