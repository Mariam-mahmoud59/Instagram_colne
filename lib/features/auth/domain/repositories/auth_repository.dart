import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String password,
    String? username, // Optional: Collect during signup or profile setup
  });

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}

