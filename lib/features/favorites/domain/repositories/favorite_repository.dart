import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites(String userId);
  Future<Either<Failure, bool>> isPostSaved(String userId, String postId);
  Future<Either<Failure, Favorite>> savePost(String userId, String postId);
  Future<Either<Failure, void>> unsavePost(String favoriteId);
}
