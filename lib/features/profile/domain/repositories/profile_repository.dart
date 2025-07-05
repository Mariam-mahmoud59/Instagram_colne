import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile.dart';
import 'dart:io'; // For File type if handling image uploads

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);

  Future<Either<Failure, Profile>> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? bio,
    File? profileImage, // Pass File object for new image
  });

  // Add other profile-related methods if needed, e.g.:
  // Future<Either<Failure, List<Post>>> getUserPosts(String userId);
  // Future<Either<Failure, void>> followUser(String userIdToFollow);
  // Future<Either<Failure, void>> unfollowUser(String userIdToUnfollow);
}

