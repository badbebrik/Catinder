import 'dart:async';
import '../../domain/entities/liked_cat.dart';

class LocalLikedCatDataSource {
  final _controller = StreamController<List<LikedCat>>.broadcast();
  final _storage = <LikedCat>[];

  Stream<List<LikedCat>> watchAll() => _controller.stream;

  Future<void> save(LikedCat liked) async {
    _storage.add(liked);
    _controller.add(List.unmodifiable(_storage));
  }

  Future<void> remove(String catId) async {
    _storage.removeWhere((c) => c.cat.id == catId);
    _controller.add(List.unmodifiable(_storage));
  }
}