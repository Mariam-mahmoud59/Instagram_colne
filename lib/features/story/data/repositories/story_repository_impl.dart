import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/story/data/datasources/story_remote_datasource.dart';

import 'package:instagram_clone/features/story/domain/entities/story.dart';
import 'package:instagram_clone/features/story/domain/repositories/story_repository.dart';
import 'dart:io';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Story>>> getStories(String currentUserId) async {
    try {
      final stories = await remoteDataSource.getStories(currentUserId);
      return Right(stories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createStoryItem({
    required String userId,
    required File mediaFile,
    required StoryMediaType mediaType,
  }) async {
    try {
      await remoteDataSource.createStoryItem(
        userId: userId,
        mediaFile: mediaFile,
        mediaType: mediaType,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
