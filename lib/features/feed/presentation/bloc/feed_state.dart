// lib/features/feed/presentation/bloc/feed_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/feed_item.dart'; // Assuming FeedItem entity is defined

/// Base class for all Feed States.
abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

/// Initial state of the Feed Bloc.
class FeedInitial extends FeedState {}

/// State when feed items are being loaded.
class FeedLoading extends FeedState {}

/// State when feed items have been successfully loaded.
class FeedLoaded extends FeedState {
  final List<FeedItem> feedItems;
  final bool hasReachedMax; // Indicates if all posts have been loaded

  const FeedLoaded({
    required this.feedItems,
    this.hasReachedMax = false,
  });

  FeedLoaded copyWith({
    List<FeedItem>? feedItems,
    bool? hasReachedMax,
  }) {
    return FeedLoaded(
      feedItems: feedItems ?? this.feedItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [feedItems, hasReachedMax];
}

/// State when an error occurs while loading feed items.
class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object> get props => [message];
}
