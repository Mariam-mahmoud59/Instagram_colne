import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // For returning user lists

abstract class FollowRemoteDataSource {
  Future<void> followUser(
      {required String followerId, required String followingId});
  Future<void> unfollowUser(
      {required String followerId, required String followingId});
  Future<List<User>> getFollowers(String userId);
  Future<List<User>> getFollowing(String userId);
  Future<bool> checkFollowStatus(
      {required String currentUserId, required String targetUserId});
}
