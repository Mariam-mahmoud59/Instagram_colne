import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/story/domain/entities/story.dart';

abstract class StoryRepository {
  Future<Either<Failure, void>> createStoryItem({
    required String userId,
    required File mediaFile,
    required StoryMediaType mediaType,
  });

  // Gets stories from users the current user follows, plus their own
  Future<Either<Failure, List<Story>>> getStories(String currentUserId);

  // Optional: Mark a story item as viewed (implementation depends on tracking strategy)
  // Future<Either<Failure, void>> viewStoryItem(String storyItemId, String viewerId);

  // Optional: Get stories for a specific user (e.g., for their profile highlight)
  // Future<Either<Failure, List<StoryItem>>> getUserStoryItems(String userId);

  // Optional: Delete a story item
  // Future<Either<Failure, void>> deleteStoryItem(String storyItemId, String userId);
}

