import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
// import 'package:instagram_clone/core/network/network_info.dart'; // Optional
import 'package:instagram_clone/features/post/data/datasources/post_remote_datasource.dart';

import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase; // For Supabase exceptions

typedef _PostOrListOperation<T> = Future<T> Function();
typedef _VoidOperation = Future<void> Function();

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional

  PostRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  Future<Either<Failure, T>> _handlePostOperation<T>(
      _PostOrListOperation<T> operation) async {
    // Optional: Check network connectivity
    // if (!await networkInfo.isConnected) {
    //   return Left(NetworkFailure());
    // }
    try {
      final result = await operation();
      // Assuming PostModel can be directly used as Post or has a toEntity() method
      // If result is List<PostModel>, it's handled correctly by Dart's type system
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on supabase.StorageException catch (e) {
      // Catch potential storage errors
      return Left(ServerFailure(message: 'Storage Error: ${e.message}'));
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(message: 'Database Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<Either<Failure, void>> _handleVoidOperation(
      _VoidOperation operation) async {
    // Optional: Check network connectivity
    // if (!await networkInfo.isConnected) {
    //   return Left(NetworkFailure());
    // }
    try {
      await operation();
      return const Right(null); // Indicate success with void
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on supabase.PostgrestException catch (e) {
      // Handle specific DB errors like constraint violations if needed
      return Left(ServerFailure(message: 'Database Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String authorId,
    required PostType type,
    required List<File> mediaFiles,
    String? description,
  }) async {
    return await _handlePostOperation<Post>(() => remoteDataSource.createPost(
          authorId: authorId,
          type: type,
          mediaFiles: mediaFiles,
          description: description,
        ));
  }

  @override
  Future<Either<Failure, Post>> getPost(String postId) async {
    return await _handlePostOperation<Post>(
        () => remoteDataSource.getPost(postId));
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPosts(String userId) async {
    return await _handlePostOperation<List<Post>>(
        () => remoteDataSource.getUserPosts(userId));
  }

  @override
  Future<Either<Failure, List<Post>>> getFeedPosts(String currentUserId) async {
    return await _handlePostOperation<List<Post>>(
        () => remoteDataSource.getFeedPosts(currentUserId));
  }

  @override
  Future<Either<Failure, void>> likePost(String postId, String userId) async {
    return await _handleVoidOperation(
        () => remoteDataSource.likePost(postId, userId));
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId, String userId) async {
    return await _handleVoidOperation(
        () => remoteDataSource.unlikePost(postId, userId));
  }

  @override
  Future<Either<Failure, List<Post>>> getVideoExplorePosts(
      {int limit = 10, int offset = 0}) async {
    return await _handlePostOperation<List<Post>>(() =>
        remoteDataSource.getVideoExplorePosts(limit: limit, offset: offset));
  }
}
