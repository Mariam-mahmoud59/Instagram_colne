import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:instagram_clone/features/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'package:instagram_clone/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';
import 'package:instagram_clone/features/chat/domain/usecases/get_chats.dart';
import 'package:instagram_clone/features/chat/domain/usecases/get_messages.dart';
import 'package:instagram_clone/features/chat/domain/usecases/get_or_create_chat.dart';
import 'package:instagram_clone/features/chat/domain/usecases/mark_messages_as_read.dart';
import 'package:instagram_clone/features/chat/domain/usecases/send_message.dart';
import 'package:instagram_clone/features/chat/domain/usecases/subscribe_to_chats.dart';
import 'package:instagram_clone/features/chat/domain/usecases/subscribe_to_messages.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';

void initChatDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => ChatBloc(
      getChats: sl(),
      getMessages: sl(),
      sendMessage: sl(),
      subscribeToMessages: sl(),
      subscribeToChats: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => GetOrCreateChat(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => MarkMessagesAsRead(sl()));
  sl.registerLazySingleton(() => SubscribeToMessages(sl()));
  sl.registerLazySingleton(() => SubscribeToChats(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      supabaseClient: sl(),
      authRemoteDataSource: sl(),
    ),
  );
}
