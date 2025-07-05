import 'package:get_it/get_it.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart' as data_repo;
import '../domain/repositories/auth_repository.dart' as domain_repo;
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/login_user.dart';
import '../domain/usecases/signup_user.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Registers all the dependencies for the Auth feature.
void initAuth(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      loginUser: sl(),
      signupUser: sl(),
      supabaseClient: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));

  // Repository
  sl.registerLazySingleton<domain_repo.AuthRepository>(
    () => data_repo.AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
