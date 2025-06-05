import 'dart:async';

import 'package:catinder/domain/entities/breed.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/entities/liked_cat.dart';
import 'package:catinder/domain/usecases/remove_like.dart';
import 'package:catinder/domain/usecases/watch_liked_cats.dart';
import 'package:catinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([WatchLikedCats, RemoveLike])
import 'liked_cat_cubit_test.mocks.dart';

void main() {
  late MockWatchLikedCats mockWatchLikedCats;
  late MockRemoveLike mockRemoveLike;
  late LikedCatsCubit cubit;

  final cat1 = Cat(
    id: 'id1',
    imageUrl: 'https://example.com/cat1.png',
    width: 100,
    height: 100,
    mimeType: 'image/png',
    breed: null,
  );

  final cat2 = Cat(
    id: 'id2',
    imageUrl: 'https://example.com/cat2.png',
    width: 150,
    height: 150,
    mimeType: 'image/jpeg',
    breed: null,
  );

  final likedCat1 = LikedCat(cat: cat1, likedAt: DateTime(2025, 6, 1));
  final likedCat2 = LikedCat(cat: cat2, likedAt: DateTime(2025, 6, 2));

  setUp(() {
    mockWatchLikedCats = MockWatchLikedCats();
    mockRemoveLike = MockRemoveLike();

    when(mockWatchLikedCats.call()).thenAnswer(
      (_) => Stream.value([likedCat1, likedCat2]),
    );

    cubit = LikedCatsCubit(
      watchLiked: mockWatchLikedCats,
      removeLike: mockRemoveLike,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LikedCatsCubit: инициализация', () {
    test(
      'после подписки на watchLiked состояние должно стать LikedCatsLoaded с cats.length == 2',
      () async {
        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<LikedCatsLoaded>());

        final loaded = cubit.state as LikedCatsLoaded;
        expect(loaded.allCats.length, 2);
        expect(loaded.cats.length, 2);
        expect(loaded.selectedBreed, isNull);
      },
    );
  });

  group('setBreedFilter()', () {
    test(
      'если передать несуществующий breedId, selectedBreed сбрасывается в null и cats == allCats',
      () async {
        await Future.delayed(const Duration(milliseconds: 100));
        final before = cubit.state as LikedCatsLoaded;
        expect(before.allCats.length, 2);

        cubit.setBreedFilter('non_existent_breed');
        final after = cubit.state as LikedCatsLoaded;

        expect(after.selectedBreed, isNull);
        expect(after.cats.length, 2);
      },
    );

    test(
      'если передать существующий breedId, cats фильтруются по этому id',
      () async {
        final fakeBreedId = 'breed_123';
        final breed = Breed(
          id: fakeBreedId,
          name: 'FakeBreed',
          weight: null,
          cfaUrl: null,
          vetstreetUrl: null,
          vcahospitalsUrl: null,
          temperament: null,
          origin: null,
          countryCode: null,
          description: null,
          lifeSpan: null,
          indoor: null,
          altNames: null,
          adaptability: null,
          affectionLevel: null,
          childFriendly: null,
          dogFriendly: null,
          energyLevel: null,
          grooming: null,
          healthIssues: null,
          intelligence: null,
          sheddingLevel: null,
          socialNeeds: null,
          strangerFriendly: null,
          vocalisation: null,
          experimental: null,
          hairless: null,
          natural: null,
          rare: null,
          rex: null,
          suppressedTail: null,
          shortLegs: null,
          wikipediaUrl: null,
          hypoallergenic: null,
          referenceImageId: null,
        );

        final catWithBreed = Cat(
          id: 'id3',
          imageUrl: 'https://test.com/cat3.png',
          width: 120,
          height: 120,
          mimeType: 'image/png',
          breed: breed,
        );
        final likedCatWithBreed = LikedCat(
          cat: catWithBreed,
          likedAt: DateTime(2025, 6, 3),
        );

        when(mockWatchLikedCats.call()).thenAnswer(
          (_) => Stream.value([likedCat1, likedCatWithBreed]),
        );

        await cubit.close();
        cubit = LikedCatsCubit(
          watchLiked: mockWatchLikedCats,
          removeLike: mockRemoveLike,
        );

        await Future.delayed(const Duration(milliseconds: 100));
        final initial = cubit.state as LikedCatsLoaded;
        expect(initial.allCats.length, 2);

        cubit.setBreedFilter(fakeBreedId);
        final filtered = cubit.state as LikedCatsLoaded;
        expect(filtered.selectedBreed, fakeBreedId);
        expect(filtered.cats.length, 1);
        expect(filtered.cats.first.cat.id, 'id3');
      },
    );
  });

  group('delete()', () {
    test(
      'вызов removeLike должен произойти ровно один раз с нужным ID',
      () async {
        await Future.delayed(const Duration(milliseconds: 100));
        final loaded = cubit.state as LikedCatsLoaded;
        expect(loaded.allCats.length, 2);

        when(mockRemoveLike.call(cat1.id)).thenAnswer((_) async {});

        await cubit.delete(cat1.id);

        verify(mockRemoveLike.call(cat1.id)).called(1);
      },
    );
  });
}
