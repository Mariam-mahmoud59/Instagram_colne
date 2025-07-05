import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/repositories/feed_repository.dart';
import '../domain/usecases/get_feed.dart';
import '../domain/usecases/refresh_feed.dart';
import '../data/repositories/feed_repository_impl.dart';
import '../data/datasources/feed_remote_datasource.dart';
import '../data/datasources/feed_remote_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> initFeedDependencies() async {
  // Bloc
  sl.registerFactory(
    () => FeedBloc(
      getFeed: sl(),
      refreshFeed: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFeed(sl()));
  sl.registerLazySingleton(() => RefreshFeed(sl()));

  // Repository
  sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
  );
}
