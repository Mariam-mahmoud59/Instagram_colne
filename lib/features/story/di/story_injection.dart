// lib/features/story/di/story_injection.dart

import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/story/data/datasources/story_remote_datasource.dart';
import 'package:instagram_clone/features/story/data/datasources/story_remote_datasource_impl.dart';
import 'package:instagram_clone/features/story/data/repositories/story_repository_impl.dart';
import 'package:instagram_clone/features/story/domain/repositories/story_repository.dart';
import 'package:instagram_clone/features/story/domain/usecases/create_story.dart';
import 'package:instagram_clone/features/story/domain/usecases/get_stories.dart';
import 'package:instagram_clone/features/story/presentation/bloc/story_bloc.dart';

void initStoryInjection(GetIt sl) {
  // Bloc
  sl.registerFactory(() => StoryBloc(getStories: sl(), createStory: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetStories(sl()));
  sl.registerLazySingleton(() => CreateStory(sl()));

  // Repository
  sl.registerLazySingleton<StoryRepository>(
      () => StoryRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<StoryRemoteDataSource>(
      () => StoryRemoteDataSourceImpl(supabaseClient: sl()));
}
