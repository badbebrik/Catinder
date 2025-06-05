import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/entities/liked_cat.dart';
import 'package:catinder/domain/usecases/dislike_cat.dart';
import 'package:catinder/domain/usecases/get_random_cat.dart';
import 'package:catinder/domain/usecases/like_cat.dart';
import 'package:catinder/domain/usecases/watch_liked_cats.dart';
import 'package:catinder/presentation/cubits/cat_feed_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetRandomCat, LikeCat, DislikeCat, WatchLikedCats])
import 'cat_feed_cubit_test.mocks.dart';

void main() {
  late MockGetRandomCat mockGetRandomCat;
  late MockLikeCat mockLikeCat;
  late MockDislikeCat mockDislikeCat;
  late MockWatchLikedCats mockWatchLikedCats;
  late CatFeedCubit cubit;

  final fakeCat = Cat(
    id: 'fake_id_1',
    imageUrl: 'https://example.com/fake.png',
    width: 200,
    height: 200,
    mimeType: 'image/png',
    breed: null,
  );

  final fakeLikedCat = LikedCat(
    cat: fakeCat,
    likedAt: DateTime(2025, 6, 5, 12, 0, 0),
  );

  setUp(() {
    mockGetRandomCat = MockGetRandomCat();
    mockLikeCat = MockLikeCat();
    mockDislikeCat = MockDislikeCat();
    mockWatchLikedCats = MockWatchLikedCats();

    when(mockWatchLikedCats.call()).thenAnswer((_) => const Stream.empty());

    cubit = CatFeedCubit(
      getRandomCat: mockGetRandomCat,
      likeCat: mockLikeCat,
      dislikeCat: mockDislikeCat,
      watchLiked: mockWatchLikedCats,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('CatFeedCubit: инициализация', () {
    test('начальное состояние — CatFeedInitial(likes: 0)', () {
      expect(cubit.state, isA<CatFeedInitial>());
      expect(cubit.state.likes, 0);
    });

    test('subscribe на watchLiked: при эмиссии двух элементов likes == 2',
        () async {
      final controller = StreamController<List<LikedCat>>();
      when(mockWatchLikedCats.call()).thenAnswer((_) => controller.stream);

      await cubit.close();
      cubit = CatFeedCubit(
        getRandomCat: mockGetRandomCat,
        likeCat: mockLikeCat,
        dislikeCat: mockDislikeCat,
        watchLiked: mockWatchLikedCats,
      );

      final emitted = <CatFeedState>[];
      final sub = cubit.stream.listen(emitted.add);

      controller.add([fakeLikedCat, fakeLikedCat]);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(emitted.last.likes, 2);

      await controller.close();
      await sub.cancel();
    });
  });

  group('loadNext()', () {
    blocTest<CatFeedCubit, CatFeedState>(
      'успешно возвращается кот → [CatFeedLoading, CatFeedLoaded]',
      build: () {
        when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);
        return cubit;
      },
      act: (c) => c.loadNext(),
      expect: () => [
        isA<CatFeedLoading>().having((s) => s.likes, 'likes', 0),
        isA<CatFeedLoaded>()
            .having((s) => s.cat.id, 'cat.id', 'fake_id_1')
            .having((s) => s.likes, 'likes', 0),
      ],
      verify: (_) {
        verify(mockGetRandomCat.call()).called(1);
      },
    );

    blocTest<CatFeedCubit, CatFeedState>(
      'GetRandomCat кидает исключение → [CatFeedLoading, CatFeedError]',
      build: () {
        when(mockGetRandomCat.call()).thenThrow(Exception('API failure'));
        return cubit;
      },
      act: (c) => c.loadNext(),
      expect: () => [
        isA<CatFeedLoading>().having((s) => s.likes, 'likes', 0),
        isA<CatFeedError>()
            .having((s) => s.message, 'message', contains('API failure'))
            .having((s) => s.likes, 'likes', 0),
      ],
      verify: (_) {
        verify(mockGetRandomCat.call()).called(1);
      },
    );
  });

  group('likeCurrent()', () {
    setUp(() {
      when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);
    });

    blocTest<CatFeedCubit, CatFeedState>(
      'если current != null и _busy == false, вызывается LikeCat и затем один loadNext',
      build: () {
        when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);
        return cubit;
      },
      act: (c) async {
        await c.loadNext();
        clearInteractions(mockLikeCat);
        clearInteractions(mockGetRandomCat);

        when(mockLikeCat.call(fakeCat)).thenAnswer((_) async => Future.value());
        when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);

        await c.likeCurrent();
      },
      expect: () => [
        isA<CatFeedLoading>(),
        isA<CatFeedLoaded>(),
        isA<CatFeedTransition>(),
        isA<CatFeedLoading>(),
        isA<CatFeedLoaded>(),
      ],
      verify: (_) {
        verify(mockLikeCat.call(fakeCat)).called(1);
        verify(mockGetRandomCat.call()).called(1);
      },
    );
  });

  group('dislikeCurrent()', () {
    setUp(() {
      when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);
    });

    blocTest<CatFeedCubit, CatFeedState>(
      'если current != null и _busy == false, вызывается DislikeCat и затем один loadNext',
      build: () {
        when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);
        return cubit;
      },
      act: (c) async {
        await c.loadNext();
        clearInteractions(mockDislikeCat);
        clearInteractions(mockGetRandomCat);

        when(mockDislikeCat.call(fakeCat)).thenAnswer((_) async {
          return;
        });
        when(mockGetRandomCat.call()).thenAnswer((_) async => fakeCat);

        await c.dislikeCurrent();
      },
      expect: () => [
        isA<CatFeedLoading>(),
        isA<CatFeedLoaded>(),
        isA<CatFeedTransition>(),
        isA<CatFeedLoading>(),
        isA<CatFeedLoaded>(),
      ],
      verify: (_) {
        verify(mockDislikeCat.call(fakeCat)).called(1);
        verify(mockGetRandomCat.call()).called(1);
      },
    );
  });
}
