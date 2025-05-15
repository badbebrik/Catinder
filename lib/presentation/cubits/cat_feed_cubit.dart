import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usecases/get_random_cat.dart';
import '../../domain/usecases/like_cat.dart';
import '../../domain/usecases/dislike_cat.dart';

part 'cat_feed_state.dart';

class CatFeedCubit extends Cubit<CatFeedState> {
  final GetRandomCat _getRandomCat;
  final LikeCat _likeCat;
  final DislikeCat _dislikeCat;

  int _likes = 0;
  Cat? _current;

  CatFeedCubit({
    required GetRandomCat getRandomCat,
    required LikeCat likeCat,
    required DislikeCat dislikeCat,
  })  : _getRandomCat = getRandomCat,
        _likeCat = likeCat,
        _dislikeCat = dislikeCat,
        super(CatFeedInitial());

  Future<void> loadNext() async {
    emit(CatFeedLoading(likes: _likes));
    try {
      _current = await _getRandomCat();
      emit(CatFeedLoaded(_current!, likes: _likes));
    } catch (e) {
      emit(CatFeedError(e.toString(), likes: _likes));
    }
  }

  Future<void> likeCurrent() async {
    if (_current == null) return;
    await _likeCat(_current!);
    _likes++;
    await loadNext();
  }

  Future<void> dislikeCurrent() async {
    if (_current == null) return;
    await _dislikeCat(_current!);
    await loadNext();
  }
}
