// lib/features/post/di/post_injection.dart

import 'package:get_it/get_it.dart';

import '../data/datasources/post_remote_datasource.dart';
import '../data/datasources/post_remote_datasource_impl.dart';
import '../data/repositories/post_repository_impl.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/usecases/create_post.dart';
import '../domain/usecases/get_feed_posts.dart';
import '../domain/usecases/get_post.dart';
import '../domain/usecases/get_user_posts.dart';
import '../domain/usecases/get_video_explore_posts.dart';
import '../domain/usecases/like_post.dart';
import '../domain/usecases/unlike_post.dart';
import '../presentation/bloc/post_bloc.dart';

/// Registers all the dependencies for the Post feature.
void initPost(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => PostBloc(
      createPost: sl(),
      getPost: sl(),
      getUserPosts: sl(),
      getFeedPosts: sl(),
      getVideoExplorePosts: sl(),
      likePost: sl(),
      unlikePost: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreatePost(sl()));
  sl.registerLazySingleton(() => GetPost(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));
  sl.registerLazySingleton(() => GetFeedPosts(sl()));
  sl.registerLazySingleton(() => GetVideoExplorePosts(sl()));
  sl.registerLazySingleton(() => LikePost(sl()));
  sl.registerLazySingleton(() => UnlikePost(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
