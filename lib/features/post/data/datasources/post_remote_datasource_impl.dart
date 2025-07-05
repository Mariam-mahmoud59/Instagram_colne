import 'dart:io';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/post/data/datasources/post_remote_datasource.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p; // For getting file extension

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String postsTable = 'posts';
  static const String likesTable = 'likes';
  static const String profilesTable = 'profiles'; // Needed for author info
  static const String postMediaBucket = 'post-media'; // Storage bucket

  PostRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<String>> uploadMediaFiles(
      List<File> files, String userId, PostType type) async {
    final uploadedUrls = <String>[];
    try {
      for (final file in files) {
        final fileExtension =
            p.extension(file.path).substring(1); // Get extension without dot
        final fileName =
            '$userId/${DateTime.now().millisecondsSinceEpoch}_${files.indexOf(file)}.$fileExtension';

        await supabaseClient.storage.from(postMediaBucket).upload(
              fileName,
              file,
              fileOptions: FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                  contentType: type == PostType.image
                      ? 'image/$fileExtension'
                      : 'video/$fileExtension'),
            );

        final publicUrl =
            supabaseClient.storage.from(postMediaBucket).getPublicUrl(fileName);
        uploadedUrls.add(publicUrl);
      }
      return uploadedUrls;
    } on StorageException catch (e) {
      print('Supabase storage error uploading media: ${e.message}');
      // Attempt to remove already uploaded files if error occurs mid-upload?
      throw ServerException(message: 'Failed to upload media: ${e.message}');
    } catch (e) {
      print('Unexpected error uploading media: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred during media upload.');
    }
  }

  @override
  Future<PostModel> createPost({
    required String authorId,
    required PostType type,
    required List<File> mediaFiles,
    String? description,
  }) async {
    try {
      // 1. Upload media files
      final mediaUrls = await uploadMediaFiles(mediaFiles, authorId, type);
      if (mediaUrls.isEmpty) {
        throw ServerException(
            message: 'Media upload failed, no URLs returned.');
      }

      // 2. Create post record in the database
      final postData = {
        'author_id': authorId,
        'type': type.name, // Store enum name as string
        'media_urls': mediaUrls,
        'description': description,
        // created_at is handled by default value in Supabase
      };

      final response =
          await supabaseClient.from(postsTable).insert(postData).select('''
            *,
            author:profiles!author_id(username, profile_image_url),
            likes(count),
            comments(count)
            ''').single();

      return PostModel.fromJson(response,
          userId: authorId); // Pass current user ID for isLiked
    } on PostgrestException catch (e) {
      print('Supabase error creating post: ${e.message}');
      throw ServerException(message: 'Failed to create post: ${e.message}');
    } on ServerException catch (e) {
      // Catch exception from uploadMediaFiles
      throw ServerException(message: e.message);
    } catch (e) {
      print('Unexpected error creating post: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while creating the post.');
    }
  }

  @override
  Future<PostModel> getPost(String postId) async {
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) {
      throw ServerException(message: 'User not logged in');
    }
    try {
      final response = await supabaseClient.from(postsTable).select('''
            *,
            author:profiles!author_id(username, profile_image_url),
            likes(count),
            comments(count),
            liked_by_user:likes!inner(count).eq(user_id, $currentUserId)
            ''').eq('id', postId).single();
      return PostModel.fromJson(response, userId: currentUserId);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // Resource Not Found
        throw ServerException(message: 'Post not found: $postId');
      }
      print('Supabase error getting post: ${e.message}');
      throw ServerException(message: 'Failed to get post: ${e.message}');
    } catch (e) {
      print('Unexpected error getting post: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while fetching the post.');
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) {
      throw ServerException(message: 'User not logged in');
    }
    try {
      final response = await supabaseClient.from(postsTable).select('''
            *,
            author:profiles!author_id(username, profile_image_url),
            likes(count),
            comments(count),
            liked_by_user:likes!inner(count).eq(user_id, $currentUserId)
            ''').eq('author_id', userId).order('created_at', ascending: false);

      return (response as List)
          .map(
              (postJson) => PostModel.fromJson(postJson, userId: currentUserId))
          .toList();
    } on PostgrestException catch (e) {
      print('Supabase error getting user posts: ${e.message}');
      throw ServerException(message: 'Failed to get user posts: ${e.message}');
    } catch (e) {
      print('Unexpected error getting user posts: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while fetching user posts.');
    }
  }

  @override
  Future<List<PostModel>> getFeedPosts(String currentUserId) async {
    // This is a basic feed implementation (e.g., posts from followed users)
    // A real feed often involves more complex logic or a dedicated feed service/table
    try {
      // 1. Get IDs of users the current user follows
      final followingResponse = await supabaseClient
          .from('follows')
          .select('following_id')
          .eq('follower_id', currentUserId);

      final followingIds = (followingResponse as List)
          .map((row) => row['following_id'] as String)
          .toList();

      // Include the current user's own posts in the feed
      final authorIds = [...followingIds, currentUserId];

      if (authorIds.isEmpty) return []; // Return empty if not following anyone

      // 2. Fetch posts from those users
      final response = await supabaseClient
          .from(postsTable)
          .select('''
            *,
            author:profiles!author_id(username, profile_image_url),
            likes(count),
            comments(count),
            liked_by_user:likes!inner(count).eq(user_id, $currentUserId)
            ''')
          .inFilter('author_id', authorIds)
          .order('created_at', ascending: false);
      // Add limit/pagination later
      // .limit(20);

      return (response as List)
          .map(
              (postJson) => PostModel.fromJson(postJson, userId: currentUserId))
          .toList();
    } on PostgrestException catch (e) {
      print('Supabase error getting feed posts: ${e.message}');
      throw ServerException(message: 'Failed to get feed posts: ${e.message}');
    } catch (e) {
      print('Unexpected error getting feed posts: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while fetching feed posts.');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await supabaseClient.from(likesTable).insert({
        'post_id': postId,
        'user_id': userId,
      });
    } on PostgrestException catch (e) {
      // Handle potential errors like duplicate likes (unique constraint violation)
      if (e.code == '23505') {
        // unique_violation
        // Already liked, ignore or log
        print('Post $postId already liked by user $userId');
        return;
      }
      print('Supabase error liking post: ${e.message}');
      throw ServerException(message: 'Failed to like post: ${e.message}');
    } catch (e) {
      print('Unexpected error liking post: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while liking the post.');
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await supabaseClient
          .from(likesTable)
          .delete()
          .match({'post_id': postId, 'user_id': userId});
    } on PostgrestException catch (e) {
      print('Supabase error unliking post: ${e.message}');
      throw ServerException(message: 'Failed to unlike post: ${e.message}');
    } catch (e) {
      print('Unexpected error unliking post: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while unliking the post.');
    }
  }

  @override
  Future<List<PostModel>> getVideoExplorePosts(
      {int limit = 10, int offset = 0}) async {
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) {
      throw ServerException(message: 'User not logged in');
    }

    try {
      final response = await supabaseClient
          .from(postsTable)
          .select('''
            *,
            author:profiles!author_id(username, profile_image_url),
            likes(count),
            comments(count),
            liked_by_user:likes!inner(count).eq(user_id, $currentUserId)
            ''')
          .eq('type', 'video')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map(
              (postJson) => PostModel.fromJson(postJson, userId: currentUserId))
          .toList();
    } on PostgrestException catch (e) {
      print('Supabase error getting video explore posts: ${e.message}');
      throw ServerException(
          message: 'Failed to get video explore posts: ${e.message}');
    } catch (e) {
      print('Unexpected error getting video explore posts: ${e.toString()}');
      throw ServerException(
          message:
              'An unexpected error occurred while fetching video explore posts.');
    }
  }
}
