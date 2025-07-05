import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // For search results
import 'package:instagram_clone/features/post/domain/entities/post.dart'; // For explore grid

abstract class ExploreRepository {
  // Get posts for the explore grid (e.g., recent public posts)
  Future<Either<Failure, List<Post>>> getExplorePosts({int limit = 21, int offset = 0});

  // Search for users based on a query string
  Future<Either<Failure, List<User>>> searchUsers(String query);
}

