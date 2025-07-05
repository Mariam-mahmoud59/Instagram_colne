import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile.dart';
import 'package:instagram_clone/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile implements UseCase<Profile, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      userId: params.userId,
      username: params.username,
      fullName: params.fullName,
      bio: params.bio,
      profileImage: params.profileImage,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final String? username;
  final String? fullName;
  final String? bio;
  final File? profileImage; // File object for the new image

  const UpdateProfileParams({
    required this.userId,
    this.username,
    this.fullName,
    this.bio,
    this.profileImage,
  });

  @override
  List<Object?> get props => [userId, username, fullName, bio, profileImage];
}

