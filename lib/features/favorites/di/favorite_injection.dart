import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:instagram_clone/features/favorites/data/datasources/favorite_remote_datasource_impl.dart';

import 'package:instagram_clone/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/get_favorites.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/is_post_saved.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/save_post.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/unsave_post.dart';
import 'package:instagram_clone/features/favorites/presentation/bloc/favorite_bloc.dart';

void registerFavoriteDependencies(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => FavoriteBloc(
      getFavorites: sl(),
      savePost: sl(),
      unsavePost: sl(),
      isPostSaved: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => SavePost(sl()));
  sl.registerLazySingleton(() => UnsavePost(sl()));
  sl.registerLazySingleton(() => IsPostSaved(sl()));

  // Repository
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );
}
