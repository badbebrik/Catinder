import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cat.dart';
import '../../domain/entities/liked_cat.dart';
import '../../domain/usecases/get_random_cat.dart';
import '../../domain/usecases/like_cat.dart';
import '../../domain/usecases/dislike_cat.dart';
import '../../domain/usecases/watch_liked_cats.dart';

part 'cat_feed_state.dart';

class CatFeedCubit extends Cubit<CatFeedState> {
  final GetRandomCat _getRandomCat;
  final LikeCat _likeCat;
  final DislikeCat _dislikeCat;
  final WatchLikedCats _watchLiked;

  StreamSubscription<List<LikedCat>>? _sub;
  Cat? _current;

  CatFeedCubit({
    required GetRandomCat getRandomCat,
    required LikeCat likeCat,
    required DislikeCat dislikeCat,
    required WatchLikedCats watchLiked,
  })  : _getRandomCat = getRandomCat,
        _likeCat = likeCat,
        _dislikeCat = dislikeCat,
        _watchLiked = watchLiked,
        super(const CatFeedInitial(likes: 0)) {
    _sub = _watchLiked().listen((list) {
      emit(_rebuildWithLikes(list.length));
    });
  }

  Future<void> loadNext() async {
    emit(CatFeedLoading(likes: state.likes));
    try {
      _current = await _getRandomCat();
      emit(CatFeedLoaded(_current!, likes: state.likes));
    } catch (e) {
      emit(CatFeedError(e.toString(), likes: state.likes));
    }
  }

  Future<void> likeCurrent() async {
    if (_current == null) return;
    await _likeCat(_current!);
    await loadNext();
  }

  Future<void> dislikeCurrent() async {
    if (_current == null) return;
    await _dislikeCat(_current!);
    await loadNext();
  }

  CatFeedState _rebuildWithLikes(int likes) {
    return switch (state) {
      CatFeedLoaded s  => CatFeedLoaded(s.cat, likes: likes),
      CatFeedLoading _ => CatFeedLoading(likes: likes),
      CatFeedError  s  => CatFeedError(s.message, likes: likes),
      _                => CatFeedInitial(likes: likes),
    };
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
