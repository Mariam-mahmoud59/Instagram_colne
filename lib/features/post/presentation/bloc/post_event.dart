part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger creating a new post
class CreateNewPost extends PostEvent {
  final String authorId;
  final PostType type;
  final List<File> mediaFiles;
  final String? description;

  const CreateNewPost({
    required this.authorId,
    required this.type,
    required this.mediaFiles,
    this.description,
  });

  @override
  List<Object?> get props => [authorId, type, mediaFiles, description];
}

// Event to load posts for the main feed
class LoadFeedPosts extends PostEvent {
  final String currentUserId; // Needed for like status
  // Add pagination params later if needed

  const LoadFeedPosts({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

// Event to load posts for a specific user's profile
class LoadUserPosts extends PostEvent {
  final String userId;
  // Add pagination params later if needed

  const LoadUserPosts({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Event to like a post
class LikePostEvent extends PostEvent {
  final String postId;
  final String userId; // User performing the like

  const LikePostEvent({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

// Event to unlike a post
class UnlikePostEvent extends PostEvent {
  final String postId;
  final String userId; // User performing the unlike

  const UnlikePostEvent({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

// Event to load post details
class LoadPostDetail extends PostEvent {
  final String postId;
  const LoadPostDetail({required this.postId});
  @override
  List<Object?> get props => [postId];
}

// Event to load video explore posts
class LoadVideoExplorePosts extends PostEvent {
  final int limit;
  final int offset;
  const LoadVideoExplorePosts({this.limit = 10, this.offset = 0});
  @override
  List<Object?> get props => [limit, offset];
}
