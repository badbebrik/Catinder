import 'package:catinder/data/datasources/remote_cat_datasource.dart';
import 'package:catinder/data/repositories/cat_repository_impl.dart';
import 'package:catinder/data/services/cat_api_service.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/local_cat_datasource.dart';
import '../data/local/app_database.dart';
import '../domain/repositories/cat_repository.dart';
import '../domain/usecases/dislike_cat.dart';
import '../domain/usecases/get_random_cat.dart';
import '../domain/usecases/like_cat.dart';
import '../domain/usecases/remove_like.dart';
import '../domain/usecases/watch_liked_cats.dart';
import '../presentation/cubits/cat_feed_cubit.dart';
import '../presentation/cubits/connectivity_cubit.dart';
import '../presentation/cubits/liked_cats_cubit.dart';

final sl = GetIt.instance;

Future<void> initDi() async {
  sl.registerLazySingleton(() => CatApiService());
  sl.registerLazySingleton(() => RemoteCatDatasource(api: sl<CatApiService>()));

  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => LocalCatDatasource(sl<AppDatabase>()));

  sl.registerLazySingleton(() => CatRepositoryImpl(remote: sl(), local: sl(), db: sl()));

  sl.registerLazySingleton<CatRepository>(
      () => CatRepositoryImpl(remote: sl(), local: sl(), db: sl()));

  sl.registerLazySingleton(() => GetRandomCat(sl()));
  sl.registerLazySingleton(() => LikeCat(sl()));
  sl.registerLazySingleton(() => DislikeCat(sl()));
  sl.registerLazySingleton(() => RemoveLike(sl()));
  sl.registerLazySingleton(() => WatchLikedCats(sl()));

  sl.registerFactory(() => CatFeedCubit(
        getRandomCat: sl(),
        likeCat: sl(),
        dislikeCat: sl(),
        watchLiked: sl(),
      ));

  sl.registerFactory(() => LikedCatsCubit(
        watchLiked: sl(),
        removeLike: sl(),
      ));
  sl.registerLazySingleton(() => ConnectivityCubit());
}
