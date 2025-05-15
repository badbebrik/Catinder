import 'dart:async';
import '../../domain/entities/liked_cat.dart';

class LocalLikedCatDatasource {
  final _controller = StreamController<List<LikedCat>>.broadcast();
  final _storage = <LikedCat>[];

  LocalLikedCatDatasource() {
    _controller.add(const []);
  }

  Stream<List<LikedCat>> watchAll() async* {
    yield List.unmodifiable(_storage);
    yield* _controller.stream;
  }

  Future<void> save(LikedCat liked) async {
    _storage.add(liked);
    _controller.add(List.unmodifiable(_storage));
  }

  Future<void> remove(String catId) async {
    _storage.removeWhere((c) => c.cat.id == catId);
    _controller.add(List.unmodifiable(_storage));
  }
}