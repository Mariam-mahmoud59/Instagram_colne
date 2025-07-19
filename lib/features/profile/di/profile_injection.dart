// lib/features/profile/di/profile_injection.dart

import 'package:get_it/get_it.dart';

import '../data/datasources/profile_remote_datasource_impl.dart';
import '../data/datasources/profile_remote_datasource.dart';
import '../data/repositories/profile_repository_impl.dart'
    hide ProfileRemoteDataSourceImpl;
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_user_profile.dart';
import '../domain/usecases/get_profile.dart';
import '../domain/usecases/update_user_profile.dart';
import '../domain/usecases/get_user_posts.dart'; // If user posts are managed by profile feature
import '../presentation/bloc/profile_bloc.dart';

/// Registers all the dependencies for the Profile feature.
void initProfile(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      updateProfile: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetProfile>(() => GetProfile(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
