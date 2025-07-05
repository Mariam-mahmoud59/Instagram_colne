import '../repositories/follow_repository.dart';

class CheckFollowStatus {
  final FollowRepository repository;
  CheckFollowStatus(this.repository);

  Future<bool> call(
      {required String currentUserId, required String targetUserId}) async {
    final result = await repository.checkFollowStatus(
        currentUserId: currentUserId, targetUserId: targetUserId);
    return result.fold((l) => false, (r) => r);
  }
}
