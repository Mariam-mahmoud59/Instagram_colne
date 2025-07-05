import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:instagram_clone/features/settings/data/datasources/settings_remote_datasource_impl.dart';
import 'package:instagram_clone/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';
import 'package:instagram_clone/features/settings/domain/usecases/get_settings.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_language.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_notifications_enabled.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_theme_mode.dart';
import 'package:instagram_clone/features/settings/presentation/bloc/settings_bloc.dart';

void registerSettingsDependencies(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      updateThemeMode: sl(),
      updateLanguage: sl(),
      updateNotificationsEnabled: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateThemeMode(sl()));
  sl.registerLazySingleton(() => UpdateLanguage(sl()));
  sl.registerLazySingleton(() => UpdateNotificationsEnabled(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );
}
