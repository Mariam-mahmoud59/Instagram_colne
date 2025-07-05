import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth feature imports
import '../../features/auth/domain/auth_injection.dart' as auth_injection;
// Profile feature imports
import '../../features/profile/di/profile_injection.dart' as profile_injection;
// Post feature imports
import '../../features/post/di/post_injection.dart' as post_injection;
// Story feature imports
import '../../features/story/di/story_injection.dart' as story_injection;
// Follow feature imports
import '../../features/follow/presentation/di/follow_injection.dart'
    as follow_injection;
// Explore feature imports
import '../../features/explore/di/explore_injection.dart' as explore_injection;
// Chat feature imports
import '../../features/chat/di/chat_injection.dart' as chat_injection;
// Favorites feature imports
import '../../features/favorites/di/favorite_injection.dart'
    as favorite_injection;
// Notifications feature imports
import '../../features/notifications/di/notification_injection.dart'
    as notification_injection;
// Settings feature imports
import '../../features/settings/di/settings_injection.dart'
    as settings_injection;

final sl = GetIt.instance;

Future<void> init() async {
  // Register Supabase client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Register all features
  auth_injection.initAuth(sl);
  profile_injection.initProfile(sl);
  post_injection.initPost(sl);
  story_injection.initStoryInjection(sl);
  follow_injection.initFollow(sl);
  explore_injection.initExplore(sl);
  chat_injection.initChatDependencies(sl);
  favorite_injection.registerFavoriteDependencies(sl);
  notification_injection.registerNotificationDependencies(sl);
  settings_injection.registerSettingsDependencies(sl);

  // --- Core ---
  // Register core components like NetworkInfo if needed
  // e.g., sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // --- External Dependencies ---
  // Register external packages like http client or connectivity checker if needed
  // e.g., sl.registerLazySingleton(() => http.Client());
  // e.g., sl.registerLazySingleton(() => InternetConnectionChecker());
}
