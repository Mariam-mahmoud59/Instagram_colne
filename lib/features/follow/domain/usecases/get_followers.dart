import '../repositories/follow_repository.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';

class GetFollowers {
  final FollowRepository repository;
  GetFollowers(this.repository);

  Future<List<User>> call(String userId) async {
    final result = await repository.getFollowers(userId);
    return result.fold((l) => [], (r) => r);
  }
}
