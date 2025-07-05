// lib/features/explore/di/explore_injection.dart

import 'package:get_it/get_it.dart';
import '../data/datasources/explore_remote_datasource.dart';
import '../data/datasources/explore_remote_datasource_impl.dart';
import '../data/repositories/explore_repository_impl.dart';
import '../domain/repositories/explore_repository.dart';
import '../domain/usecases/get_explore_posts.dart';
import '../domain/usecases/search_users.dart';
import '../presentation/bloc/explore_bloc.dart';

/// Registers all the dependencies for the Explore feature.
void initExplore(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => ExploreBloc(
      getExplorePosts: sl(),
      searchUsers: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExplorePosts(sl()));
  sl.registerLazySingleton(() => SearchUsers(sl()));

  // Repository
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
