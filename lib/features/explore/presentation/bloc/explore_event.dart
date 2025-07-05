part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

// Event to load posts for the explore grid
class LoadExplorePostsEvent extends ExploreEvent {
  final int limit;
  final int offset;
  final bool isRefresh; // Flag to indicate if it's a pull-to-refresh

  const LoadExplorePostsEvent({this.limit = 21, this.offset = 0, this.isRefresh = false});

  @override
  List<Object> get props => [limit, offset, isRefresh];
}

// Event triggered when the search query changes
class SearchQueryChangedEvent extends ExploreEvent {
  final String query;

  const SearchQueryChangedEvent({required this.query});

  @override
  List<Object> get props => [query];
}

// Event to clear the search results and go back to explore grid
class ClearSearchEvent extends ExploreEvent {}

