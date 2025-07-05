part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

// Initial state
class ExploreInitial extends ExploreState {}

// State when loading explore posts or search results
class ExploreLoading extends ExploreState {}
class ExploreSearchLoading extends ExploreState {}

// State when explore posts are loaded successfully
class ExplorePostsLoaded extends ExploreState {
  final List<Post> posts;

  const ExplorePostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

// State when search results are loaded successfully
class ExploreSearchResultsLoaded extends ExploreState {
  final List<User> users;

  const ExploreSearchResultsLoaded(this.users);

  @override
  List<Object> get props => [users];
}

// State when an error occurs during loading or searching
class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object> get props => [message];
}

