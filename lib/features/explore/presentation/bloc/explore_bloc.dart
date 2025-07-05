import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/explore/domain/usecases/get_explore_posts.dart';
import 'package:instagram_clone/features/explore/domain/usecases/search_users.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExplorePosts getExplorePosts;
  final SearchUsers searchUsers;

  ExploreBloc({
    required this.getExplorePosts,
    required this.searchUsers,
  }) : super(ExploreInitial()) {
    on<LoadExplorePostsEvent>(_onLoadExplorePosts);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoadExplorePosts(
      LoadExplorePostsEvent event, Emitter<ExploreState> emit) async {
    // Only emit loading if it's the initial load or refresh
    if (state is! ExplorePostsLoaded || event.isRefresh) {
      emit(ExploreLoading());
    }
    final result = await getExplorePosts(
        GetExplorePostsParams(limit: event.limit, offset: event.offset));
    result.fold(
      (failure) =>
          emit(ExploreError(failure.toString())), // Use failure.message
      (posts) => emit(ExplorePostsLoaded(posts)),
    );
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<ExploreState> emit) async {
    final query = event.query;
    if (query.isEmpty) {
      // If query is cleared, go back to showing explore posts
      // Or emit a specific SearchIdle state if needed
      add(LoadExplorePostsEvent()); // Reload explore posts
      return;
    }

    emit(ExploreSearchLoading());
    final result = await searchUsers(SearchUsersParams(query: query));
    result.fold(
      (failure) =>
          emit(ExploreError(failure.toString())), // Use failure.message
      (users) => emit(ExploreSearchResultsLoaded(users)),
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<ExploreState> emit) {
    // Transition back to showing explore posts when search is explicitly cleared
    add(LoadExplorePostsEvent());
  }
}
