import 'dart:io';
import 'package:instagram_clone/features/post/data/models/post_model.dart'; // To be created
import 'package:instagram_clone/features/post/domain/entities/post.dart'; // For PostType

abstract class PostRemoteDataSource {
  Future<PostModel> createPost({
    required String authorId,
    required PostType type,
    required List<File> mediaFiles,
    String? description,
  });

  Future<PostModel> getPost(String postId);

  Future<List<PostModel>> getUserPosts(String userId);

  Future<List<PostModel>> getFeedPosts(String currentUserId);

  Future<List<PostModel>> getVideoExplorePosts({int limit = 10, int offset = 0}); // Added for video explore

  Future<void> likePost(String postId, String userId);

  Future<void> unlikePost(String postId, String userId);

  Future<List<String>> uploadMediaFiles(List<File> files, String userId, PostType type);
}

