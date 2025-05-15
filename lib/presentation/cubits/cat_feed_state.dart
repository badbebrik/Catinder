part of 'cat_feed_cubit.dart';

abstract class CatFeedState {
  final int likes;
  const CatFeedState({required this.likes});
}

class CatFeedInitial extends CatFeedState {
  CatFeedInitial() : super(likes: 0);
}

class CatFeedLoading extends CatFeedState {
  CatFeedLoading({required super.likes});
}

class CatFeedLoaded extends CatFeedState {
  final Cat cat;
  CatFeedLoaded(this.cat, {required super.likes});
}

class CatFeedError extends CatFeedState {
  final String message;
  CatFeedError(this.message, {required super.likes});
}
