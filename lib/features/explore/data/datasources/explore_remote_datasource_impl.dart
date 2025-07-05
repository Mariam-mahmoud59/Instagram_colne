import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'
    as app_user;
import 'package:instagram_clone/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String postsTable = 'posts';
  static const String profilesTable = 'profiles';

  ExploreRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<Post>> getExplorePosts({int limit = 21, int offset = 0}) async {
    try {
      // Fetch recent posts, ordered by creation time, with author details
      // Adjust the query based on how you want the explore feed populated
      // (e.g., random, popular, recent from non-followed users)
      // This example fetches recent posts globally.
      final response = await supabaseClient
          .from(postsTable)
          .select(
              '*, author:user_id(id, username, profile_image_url)') // Join with profiles
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<Post> posts = (response as List)
          .map((data) => PostModel.fromJson(data as Map<String, dynamic>,
              userId: data['author_id'] as String))
          .toList();
      return posts;
    } on PostgrestException catch (e) {
      print('Supabase error getting explore posts: ${e.message}');
      throw ServerException(
          message: 'Failed to get explore posts: ${e.message}');
    } catch (e) {
      print('Unexpected error getting explore posts: ${e.toString()}');
      throw ServerException(
          message:
              'An unexpected error occurred while fetching explore posts.');
    }
  }

  @override
  Future<List<app_user.User>> searchUsers(String query) async {
    try {
      // Search profiles where username contains the query (case-insensitive)
      final response = await supabaseClient
          .from(profilesTable)
          .select('id, username, profile_image_url')
          .ilike('username', '%$query%') // Case-insensitive search
          .limit(20); // Limit search results

      final List<app_user.User> users = (response as List).map((data) {
        return UserModel.fromJson({
          'id': data['id'],
          'email': '', // Email not needed for search results
          'username': data['username'],
          'profile_image_url': data['profile_image_url'],
          // Add other fields if needed from your UserModel.fromJson
        });
      }).toList();

      return users;
    } on PostgrestException catch (e) {
      print('Supabase error searching users: ${e.message}');
      throw ServerException(message: 'Failed to search users: ${e.message}');
    } catch (e) {
      print('Unexpected error searching users: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while searching users.');
    }
  }
}
