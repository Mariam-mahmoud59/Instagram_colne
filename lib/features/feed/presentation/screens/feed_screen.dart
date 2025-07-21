// lib/features/feed/presentation/screens/feed_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/common_widgets/error_widget.dart';
import 'package:instagram_clone/features/common_widgets/loading_indicator.dart';
import 'package:instagram_clone/features/post/presentation/screens/post_detail_screen.dart';
import 'package:instagram_clone/features/explore/presentation/screens/search_screen.dart';
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
    return Column(
      children: [
        // Stories Section - Clean design without any app bar elements
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFDBDBDB),
                width: 0.5,
              ),
            ),
          ),
          child:  FeedStoriesBar(),
        ),
        
        // Feed Posts
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
                    return _buildEmptyFeedState();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: state.feedItems.length +
                        (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      final isLast = index == state.feedItems.length;
                      if (isLast && !state.hasReachedMax) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF262626),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      final feedItem = state.feedItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFDBDBDB),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: FeedItemCard(
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
                        ),
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
    );
  }

  Widget _buildEmptyFeedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF262626),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: Color(0xFF262626),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Welcome to Instagram',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Color(0xFF262626),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'When you follow people, you\'ll see the photos and videos they post here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8E8E8E),
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Find People Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text(
                'Find People to Follow',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}