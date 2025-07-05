// lib/features/feed/presentation/bloc/feed_event.dart

import 'package:equatable/equatable.dart';

/// Base class for all Feed Events.
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the initial feed or load more posts (pagination).
class LoadFeed extends FeedEvent {
  final int page;
  final int limit;

  const LoadFeed({this.page = 0, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

/// Event to refresh the feed (pull-to-refresh).
class RefreshFeedEvent extends FeedEvent {
  const RefreshFeedEvent();
}

/// Event to indicate that a post has been liked/unliked.
/// This might be dispatched from a post widget and handled by the FeedBloc
/// to update the UI without re-fetching the entire feed.
class UpdateFeedPostLikeStatus extends FeedEvent {
  final String postId;
  final bool isLiked;
  final int likesCount;

  const UpdateFeedPostLikeStatus({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  List<Object> get props => [postId, isLiked, likesCount];
}

// Add other events as needed, e.g., for comments, saving posts, etc.
