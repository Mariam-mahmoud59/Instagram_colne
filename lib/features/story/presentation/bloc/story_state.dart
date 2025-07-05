part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  const StoryState();
  @override
  List<Object?> get props => [];
}

// Initial state
class StoryInitial extends StoryState {
  const StoryInitial();
}

// State while stories are being loaded
class StoriesLoading extends StoryState {
  const StoriesLoading();
}

// State when stories are successfully loaded
class StoriesLoaded extends StoryState {
  final List<Story> stories;

  const StoriesLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}

// State when loading stories fails
class StoriesLoadFailure extends StoryState {
  final String message;

  const StoriesLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// State while a new story item is being uploaded
class StoryUploadInProgress extends StoryState {
  const StoryUploadInProgress();
}

// State when a new story item is successfully uploaded
class StoryUploadSuccess extends StoryState {
  const StoryUploadSuccess();
}

// State for general story operation failures (create, view, delete)
class StoryOperationFailure extends StoryState {
  final String message;

  const StoryOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
