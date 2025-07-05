import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';

class SignupUser implements UseCase<User, SignupParams> {
  final AuthRepository repository;

  SignupUser(this.repository);

  @override
  Future<Either<Failure, User>> call(SignupParams params) async {
    return await repository.signupWithEmailPassword(
      email: params.email,
      password: params.password,
      username: params.username, // Pass username if collected at signup
    );
  }
}

class SignupParams extends Equatable {
  final String email;
  final String password;
  final String? username; // Optional, based on requirements

  const SignupParams({required this.email, required this.password, this.username});

  @override
  List<Object?> get props => [email, password, username];
}

