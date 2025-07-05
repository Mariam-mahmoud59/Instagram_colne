import 'dart:io';
import 'package:instagram_clone/features/story/data/models/story_model.dart'; // To be created
import 'package:instagram_clone/features/story/domain/entities/story.dart'; // For StoryMediaType

abstract class StoryRemoteDataSource {
  Future<void> createStoryItem({
    required String userId,
    required File mediaFile,
    required StoryMediaType mediaType,
  });

  // Returns a list of StoryModels, grouped by user
  Future<List<StoryModel>> getStories(String currentUserId);

  Future<String> uploadStoryMedia(File file, String userId, StoryMediaType type);

  // Optional: Add methods for viewing, deleting stories if needed
}

