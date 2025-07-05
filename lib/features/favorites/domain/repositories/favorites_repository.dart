import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';

abstract class FavoriteRepository {
  /// Save a post to favorites
  Future<Either<Failure, Favorite>> savePost(String userId, String postId);

  /// Remove a post from favorites
  Future<Either<Failure, void>> unsavePost(String favoriteId);

  /// Check if a post is saved by the user
  Future<Either<Failure, bool>> isPostSaved(String userId, String postId);

  /// Get all favorites for a user
  Future<Either<Failure, List<Favorite>>> getFavorites(String userId);
}
