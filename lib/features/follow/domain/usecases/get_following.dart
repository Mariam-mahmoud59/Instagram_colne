import '../repositories/follow_repository.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';

class GetFollowing {
  final FollowRepository repository;
  GetFollowing(this.repository);

  Future<List<User>> call(String userId) async {
    final result = await repository.getFollowing(userId);
    return result.fold((l) => [], (r) => r);
  }
}
