import '../repositories/follow_repository.dart';

class UnfollowUser {
  final FollowRepository repository;
  UnfollowUser(this.repository);

  Future<void> call(
      {required String followerId, required String followingId}) async {
    await repository.unfollowUser(
        followerId: followerId, followingId: followingId);
  }
}
