part of 'cat_feed_cubit.dart';

abstract class CatFeedState {
  final int likes;
  const CatFeedState({required this.likes});
}

class CatFeedInitial extends CatFeedState {
  const CatFeedInitial({required int likes}) : super(likes: likes);
}

class CatFeedLoading extends CatFeedState {
  const CatFeedLoading({required int likes}) : super(likes: likes);
}

class CatFeedLoaded extends CatFeedState {
  final Cat cat;
  const CatFeedLoaded(this.cat, {required int likes}) : super(likes: likes);
}

class CatFeedError extends CatFeedState {
  final String message;
  const CatFeedError(this.message, {required int likes})
      : super(likes: likes);
}

class CatFeedTransition extends CatFeedState {
  final Cat previous;
  const CatFeedTransition(this.previous, {required int likes})
      : super(likes: likes);
}