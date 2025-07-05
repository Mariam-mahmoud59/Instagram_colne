// lib/features/follow/di/follow_injection.dart

import 'package:get_it/get_it.dart';
// Assuming Supabase is used for data source

import '../../data/datasources/follow_remote_datasource.dart';
import '../../data/datasources/follow_remote_datasource_impl.dart';
import '../../data/repositories/follow_repository_impl.dart';
import '../../domain/repositories/follow_repository.dart';
import '../../domain/usecases/check_follow_status.dart';
import '../../domain/usecases/follow_user.dart';
import '../../domain/usecases/get_followers.dart';
import '../../domain/usecases/get_following.dart';
import '../../domain/usecases/unfollow_user.dart';
import '../bloc/follow_bloc.dart';

/// Registers all the dependencies for the Follow feature.
void initFollow(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => FollowBloc(
      followUser: sl<FollowUser>(),
      unfollowUser: sl<UnfollowUser>(),
      checkFollowStatus: sl<CheckFollowStatus>(),
      getFollowers: sl<GetFollowers>(),
      getFollowing: sl<GetFollowing>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FollowUser(sl()));
  sl.registerLazySingleton(() => UnfollowUser(sl()));
  sl.registerLazySingleton(() => CheckFollowStatus(sl()));
  sl.registerLazySingleton(() => GetFollowers(sl()));
  sl.registerLazySingleton(() => GetFollowing(sl()));

  // Repository
  sl.registerLazySingleton<FollowRepository>(
    () => FollowRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FollowRemoteDataSource>(
    () => FollowRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // External (SupabaseClient is registered in the main injection_container.dart)
  // No need to register SupabaseClient here again, it's a global dependency.
}
