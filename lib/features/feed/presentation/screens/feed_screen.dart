// lib/features/feed/presentation/screens/feed_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/common_widgets/error_widget.dart';
import 'package:instagram_clone/features/common_widgets/loading_indicator.dart';
import 'package:instagram_clone/features/post/presentation/screens/post_detail_screen.dart'; // To navigate to post details
import 'package:instagram_clone/features/explore/presentation/screens/search_screen.dart';
import 'package:instagram_clone/features/common_widgets/app_bar.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/feed_item_card.dart';
import '../widgets/feed_refresh_indicator.dart';
import '../widgets/feed_stories_bar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load of feed posts
    context.read<FeedBloc>().add(const LoadFeed(page: 0));
  }

  void _onScroll() {
    if (_isBottom) {
      _currentPage++;
      context.read<FeedBloc>().add(LoadFeed(page: _currentPage));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load more when 90% scrolled
  }

  Future<void> _onRefresh() async {
    _currentPage = 0; // Reset page on refresh
    context.read<FeedBloc>().add(const RefreshFeedEvent());
    // Wait for the bloc to emit a new state
    await BlocProvider.of<FeedBloc>(context)
        .stream
        .firstWhere((state) => state is! FeedLoading);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // قصص دائرية في الأعلى
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FeedStoriesBar(),
          ),
          // منشورات مربعة
          Expanded(
            child: FeedRefreshIndicator(
              onRefresh: _onRefresh,
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state is FeedLoading && _currentPage == 0) {
                    return const LoadingIndicator();
                  } else if (state is FeedError) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<FeedBloc>().add(const LoadFeed(page: 0)),
                    );
                  } else if (state is FeedLoaded) {
                    if (state.feedItems.isEmpty) {
                      return const Center(
                          child: Text(
                              'No posts in your feed. Follow more people!'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.feedItems.length +
                          (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        final isLast = index == state.feedItems.length;
                        if (isLast && !state.hasReachedMax) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final feedItem = state.feedItems[index];
                        return FeedItemCard(
                          feedItem: feedItem,
                          onPostTap: (postId) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(postId: postId),
                              ),
                            );
                          },
                          onLikeToggle: (postId, isLiked, likesCount) {
                            context.read<FeedBloc>().add(
                                  UpdateFeedPostLikeStatus(
                                    postId: postId,
                                    isLiked: isLiked,
                                    likesCount: likesCount,
                                  ),
                                );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
