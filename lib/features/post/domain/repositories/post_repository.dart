import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, Post>> createPost({
    required String authorId,
    required PostType type,
    required List<File> mediaFiles, // List of image files or single video file
    String? description,
  });

  Future<Either<Failure, Post>> getPost(String postId);

  Future<Either<Failure, List<Post>>> getUserPosts(String userId);

  Future<Either<Failure, List<Post>>> getFeedPosts(String currentUserId); // For the main feed

  Future<Either<Failure, List<Post>>> getVideoExplorePosts({int limit = 10, int offset = 0}); // For video explore screen

  Future<Either<Failure, void>> likePost(String postId, String userId);

  Future<Either<Failure, void>> unlikePost(String postId, String userId);

  // Add other post-related methods if needed (e.g., deletePost, getComments, addComment)
}

