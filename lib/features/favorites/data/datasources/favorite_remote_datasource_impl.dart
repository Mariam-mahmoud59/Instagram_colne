import 'package:instagram_clone/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:instagram_clone/features/favorites/data/models/favorite_model.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final SupabaseClient supabaseClient;

  FavoriteRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<FavoriteModel>> getFavorites(String userId) async {
    try {
      final response = await supabaseClient
          .from('favorites')
          .select('*, post:posts(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((favorite) => FavoriteModel.fromJson(favorite))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isPostSaved(String userId, String postId) async {
    try {
      final response = await supabaseClient
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('post_id', postId)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      throw ServerException(message: 'Failed to check if post is saved: $e');
    }
  }

  @override
  Future<FavoriteModel> savePost(String userId, String postId) async {
    try {
      final favoriteData = {
        'user_id': userId,
        'post_id': postId,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('favorites')
          .insert(favoriteData)
          .select('*, post:posts(*)')
          .single();

      return FavoriteModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Failed to save post: $e');
    }
  }

  @override
  Future<void> unsavePost(String favoriteId) async {
    try {
      await supabaseClient.from('favorites').delete().eq('id', favoriteId);
    } catch (e) {
      throw ServerException(message: 'Failed to unsave post: $e');
    }
  }
}
