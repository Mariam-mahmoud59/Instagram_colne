part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger creating a new story item
class CreateNewStoryItem extends StoryEvent {
  final String userId;
  final File mediaFile;
  final StoryMediaType mediaType;

  const CreateNewStoryItem({
    required this.userId,
    required this.mediaFile,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [userId, mediaFile, mediaType];
}

// Event to load stories for the feed (users followed + self)
class LoadStories extends StoryEvent {
  final String currentUserId;

  const LoadStories({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

// Optional: Event to mark a story as viewed
// class ViewStory extends StoryEvent { ... }

// Optional: Event to delete a story
// class DeleteStory extends StoryEvent { ... }
