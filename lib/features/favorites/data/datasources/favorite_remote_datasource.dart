import 'package:instagram_clone/features/favorites/data/models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites(String userId);
  Future<bool> isPostSaved(String userId, String postId);
  Future<FavoriteModel> savePost(String userId, String postId);
  Future<void> unsavePost(String favoriteId);
}
