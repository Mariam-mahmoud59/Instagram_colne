// lib/features/feed/presentation/bloc/feed_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart'; // Assuming Failure definitions are here
import '../../domain/usecases/get_feed.dart'; // Assuming GetFeed use case is defined
import '../../domain/usecases/refresh_feed.dart'; // Assuming RefreshFeed use case is defined
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/feed_item.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeed _getFeed;
  final RefreshFeed _refreshFeed;

  FeedBloc({
    required GetFeed getFeed,
    required RefreshFeed refreshFeed,
  })  : _getFeed = getFeed,
        _refreshFeed = refreshFeed,
        super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<RefreshFeedEvent>(_onRefreshFeed);
    on<UpdateFeedPostLikeStatus>(_onUpdateFeedPostLikeStatus);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    if (state is FeedLoaded && (state as FeedLoaded).hasReachedMax) return;

    final currentState = state;
    List<FeedItem> oldFeedItems = [];
    if (currentState is FeedLoaded) {
      oldFeedItems = currentState.feedItems;
    }

    emit(FeedLoading()); // Emit loading state before fetching

    final result =
        await _getFeed(GetFeedParams(page: event.page, limit: event.limit));

    result.fold(
      (failure) => emit(FeedError(message: _mapFailureToMessage(failure))),
      (newFeedItems) {
        final allFeedItems = oldFeedItems + newFeedItems;
        emit(FeedLoaded(
          feedItems: allFeedItems,
          hasReachedMax:
              newFeedItems.isEmpty, // If no new items, we've reached max
        ));
      },
    );
  }

  Future<void> _onRefreshFeed(
      RefreshFeedEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoading()); // Emit loading state for refresh

    final result = await _refreshFeed(NoParams());

    result.fold(
      (failure) => emit(FeedError(message: _mapFailureToMessage(failure))),
      (feedItems) =>
          emit(FeedLoaded(feedItems: feedItems, hasReachedMax: false)),
    );
  }

  void _onUpdateFeedPostLikeStatus(
      UpdateFeedPostLikeStatus event, Emitter<FeedState> emit) {
    if (state is FeedLoaded) {
      final currentFeed = (state as FeedLoaded).feedItems;
      final updatedFeed = currentFeed.map((item) {
        if (item.id == event.postId) {
          return item.copyWith(
            likesCount: event.likesCount,
            // Assuming you have an 'isLiked' property in FeedItem
            // isLiked: event.isLiked,
          );
        }
        return item;
      }).toList();
      emit((state as FeedLoaded).copyWith(feedItems: updatedFeed));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      case NetworkFailure:
        return (failure as NetworkFailure).message;
      case SupabaseFailure:
        return (failure as SupabaseFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}
