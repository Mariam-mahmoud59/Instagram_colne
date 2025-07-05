import '../repositories/follow_repository.dart';

class FollowUser {
  final FollowRepository repository;
  FollowUser(this.repository);

  Future<void> call(
      {required String followerId, required String followingId}) async {
    await repository.followUser(
        followerId: followerId, followingId: followingId);
  }
}
