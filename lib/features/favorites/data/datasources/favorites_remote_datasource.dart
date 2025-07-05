import 'package:instagram_clone/features/favorites/data/models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  /// Save a post to favorites
  Future<FavoriteModel> savePost(String userId, String postId);

  /// Remove a post from favorites
  Future<void> unsavePost(String favoriteId);

  /// Check if a post is saved by the user
  Future<bool> isPostSaved(String userId, String postId);

  /// Get all favorites for a user
  Future<List<FavoriteModel>> getFavorites(String userId);
}
