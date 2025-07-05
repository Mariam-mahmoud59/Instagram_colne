import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // For returning user lists

abstract class FollowRepository {
  Future<Either<Failure, void>> followUser(
      {required String followerId, required String followingId});
  Future<Either<Failure, void>> unfollowUser(
      {required String followerId, required String followingId});
  Future<Either<Failure, List<User>>> getFollowers(String userId);
  Future<Either<Failure, List<User>>> getFollowing(String userId);
  Future<Either<Failure, bool>> checkFollowStatus(
      {required String currentUserId, required String targetUserId});
}
