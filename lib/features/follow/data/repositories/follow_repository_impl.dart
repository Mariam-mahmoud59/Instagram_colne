import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
// import 'package:instagram_clone/core/network/network_info.dart'; // Optional
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/follow/data/datasources/follow_remote_datasource.dart';
import 'package:instagram_clone/features/follow/domain/repositories/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional

  FollowRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> followUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await remoteDataSource.followUser(
          followerId: followerId, followingId: followingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await remoteDataSource.unfollowUser(
          followerId: followerId, followingId: followingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getFollowers(String userId) async {
    try {
      final users = await remoteDataSource.getFollowers(userId);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getFollowing(String userId) async {
    try {
      final users = await remoteDataSource.getFollowing(userId);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      final status = await remoteDataSource.checkFollowStatus(
          currentUserId: currentUserId, targetUserId: targetUserId);
      return Right(status);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
