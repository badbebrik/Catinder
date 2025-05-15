// liked_cats_state.dart – без изменений

part of 'liked_cats_cubit.dart';

abstract class LikedCatsState {}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<LikedCat> cats;
  final List<LikedCat> allCats;
  final String? selectedBreed;

  LikedCatsLoaded({
    required this.cats,
    required this.allCats,
    required this.selectedBreed,
  });
}

class LikedCatsError extends LikedCatsState {
  final String message;
  LikedCatsError(this.message);
}
