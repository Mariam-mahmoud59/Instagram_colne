import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile.dart';
import 'package:instagram_clone/features/profile/domain/repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile, GetProfileParams> {
  final ProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(GetProfileParams params) async {
    return await repository.getProfile(params.userId);
  }
}

class GetProfileParams extends Equatable {
  final String userId;

  const GetProfileParams({required this.userId});

  @override
  List<Object> get props => [userId];
}

