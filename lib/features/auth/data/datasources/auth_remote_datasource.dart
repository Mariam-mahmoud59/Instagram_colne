import 'package:instagram_clone/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<User> signupWithEmailPassword({
    required String email,
    required String password,
    String? username,
  });

  Future<User?> getCurrentUser();

  Future<void> logout();
}
