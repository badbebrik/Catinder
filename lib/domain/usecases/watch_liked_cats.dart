import '../entities/liked_cat.dart';
import '../repositories/cat_repository.dart';

class WatchLikedCats {
  final CatRepository repo;
  WatchLikedCats(this.repo);
  Stream<List<LikedCat>> call() => repo.watchLikedCats();
}
