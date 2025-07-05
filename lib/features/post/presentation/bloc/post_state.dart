part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

// Initial state
class PostInitial extends PostState {}

// State while posts (feed or user posts) are being loaded
class PostsLoading extends PostState {}

// State when posts are successfully loaded
class PostsLoaded extends PostState {
  final List<Post> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

// State when loading posts fails
class PostsLoadFailure extends PostState {
  final String message;

  const PostsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

// State while a new post is being uploaded
class PostUploading extends PostState {}

// State when a new post is successfully uploaded
class PostUploadSuccess extends PostState {
  final Post newPost;

  const PostUploadSuccess(this.newPost);

  @override
  List<Object> get props => [newPost];
}

// State for general post operation failures (like, unlike, create)
class PostOperationFailure extends PostState {
  final String message;

  const PostOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Optional: States for like/unlike operations if more specific feedback is needed
// class PostLikeInProgress extends PostState { ... }
// class PostLikeSuccess extends PostState { ... }
// class PostUnlikeInProgress extends PostState { ... }
// class PostUnlikeSuccess extends PostState { ... }

class PostDetailLoaded extends PostState {
  final Post post;
  const PostDetailLoaded(this.post);
  @override
  List<Object> get props => [post];
}

class PostDetailFailure extends PostState {
  final String message;
  const PostDetailFailure(this.message);
  @override
  List<Object> get props => [message];
}

class VideoExplorePostsLoaded extends PostState {
  final List<Post> posts;
  const VideoExplorePostsLoaded(this.posts);
  @override
  List<Object> get props => [posts];
}
