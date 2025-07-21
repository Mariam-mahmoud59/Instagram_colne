import 'package:get_it/get_it.dart';
import '../presentation/bloc/notification_bloc.dart';
import '../domain/usecases/get_notifications.dart';
import '../domain/usecases/mark_notification_as_read.dart';
import '../domain/usecases/mark_all_notifications_as_read.dart';
import '../domain/usecases/delete_notification.dart';
import '../domain/usecases/create_notification.dart';
import '../domain/usecases/subscribe_to_notifications.dart';
import 'package:instagram_clone/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:instagram_clone/features/notifications/data/datasources/notification_remote_datasource_impl.dart';
import 'package:instagram_clone/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void registerNotificationDependencies(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => NotificationBloc(
      getNotifications: sl(),
      markNotificationAsRead: sl(),
      markAllNotificationsAsRead: sl(),
      deleteNotification: sl(),
      createNotification: sl(),
      subscribeToNotifications: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsAsRead(sl()));
  sl.registerLazySingleton(() => DeleteNotification(sl()));
  sl.registerLazySingleton(() => CreateNotification(sl()));
  sl.registerLazySingleton(() => SubscribeToNotifications(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () =>
        NotificationRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()),
  );
}
