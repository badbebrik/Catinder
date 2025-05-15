import '../repositories/cat_repository.dart';

class RemoveLike {
  final CatRepository repo;
  RemoveLike(this.repo);
  Future<void> call(String catId) => repo.removeLike(catId);
}