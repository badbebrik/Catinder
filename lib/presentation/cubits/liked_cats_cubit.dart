import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/liked_cat.dart';
import '../../domain/usecases/watch_liked_cats.dart';
import '../../domain/usecases/remove_like.dart';

part 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final WatchLikedCats _watchLiked;
  final RemoveLike _removeLike;

  StreamSubscription<List<LikedCat>>? _sub;
  String? _breedFilter;

  LikedCatsCubit({
    required WatchLikedCats watchLiked,
    required RemoveLike removeLike,
  })  : _watchLiked = watchLiked,
        _removeLike = removeLike,
        super(LikedCatsLoading()) {
    _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    _sub = _watchLiked().listen(_onData, onError: _onError);
  }

  void _onData(List<LikedCat> list) {
    final hasSelectedBreed = list.any((e) => e.cat.breed?.id == _breedFilter);
    if (!hasSelectedBreed) _breedFilter = null;

    final filtered = _breedFilter == null
        ? list
        : list.where((e) => e.cat.breed?.id == _breedFilter).toList();

    emit(LikedCatsLoaded(
      cats: filtered,
      allCats: list,
      selectedBreed: _breedFilter,
    ));
  }

  void _onError(Object e) => emit(LikedCatsError(e.toString()));

  void setBreedFilter(String? breedId) {
    _breedFilter = breedId;
    _onData((state as LikedCatsLoaded).allCats);
  }

  Future<void> delete(String catId) => _removeLike(catId);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
