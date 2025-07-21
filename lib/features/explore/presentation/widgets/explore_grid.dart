import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/profile/presentation/screens/profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    context.read<ExploreBloc>().add(const LoadExplorePostsEvent());
    _animationController.forward();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        if (_searchController.text.isEmpty) {
          context.read<ExploreBloc>().add(ClearSearchEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFFAFAFA),
      appBar: _buildModernAppBar(isDark),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state is ExploreLoading ||
              (state is ExploreInitial && _searchController.text.isEmpty)) {
            return _buildLoadingState(isDark);
          } else if (state is ExplorePostsLoaded &&
              _searchController.text.isEmpty) {
            return _buildExploreGrid(state.posts, isDark);
          } else if (state is ExploreSearchLoading &&
              _searchController.text.isNotEmpty) {
            return _buildSearchLoadingState(isDark);
          } else if (state is ExploreSearchResultsLoaded &&
              _searchController.text.isNotEmpty) {
            return _buildUserSearchList(state.users, isDark);
          } else if (state is ExploreError) {
            return _buildErrorState(state.message, isDark);
          } else if (_searchController.text.isNotEmpty &&
              state is! ExploreSearchResultsLoaded) {
            return _buildSearchLoadingState(isDark);
          } else if (_searchController.text.isEmpty &&
              state is! ExplorePostsLoaded) {
            context.read<ExploreBloc>().add(const LoadExplorePostsEvent());
            return _buildLoadingState(isDark);
          }
          return _buildEmptyState(isDark);
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: _buildSearchField(isDark),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color: isDark ? const Color(0xFF262626) : const Color(0xFFDBDBDB),
        ),
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return AnimatedBuilder(
      animation: _searchAnimationController,
      builder: (context, child) {
        return Container(
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(12),
            border: _searchFocusNode.hasFocus
                ? Border.all(color: const Color(0xFF0095F6), width: 1.5)
                : null,
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color:
                    isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.search,
                color:
                    isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: isDark
                            ? const Color(0xFF8E8E8E)
                            : const Color(0xFF8E8E8E),
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ExploreBloc>().add(ClearSearchEvent());
                        _searchFocusNode.unfocus();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            ),
            onChanged: (query) {
              setState(() {});
              if (query.isNotEmpty) {
                context
                    .read<ExploreBloc>()
                    .add(SearchQueryChangedEvent(query: query));
              } else {
                context.read<ExploreBloc>().add(ClearSearchEvent());
              }
            },
            onTap: () {
              if (_searchController.text.isNotEmpty) {
                context.read<ExploreBloc>().add(
                    SearchQueryChangedEvent(query: _searchController.text));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: 15,
              itemBuilder: (context, index) => _buildSkeletonItem(isDark),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonItem(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSearchLoadingState(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) => _buildUserSkeletonItem(isDark),
    );
  }

  Widget _buildUserSkeletonItem(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF262626)
                        : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF262626)
                        : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreGrid(List<Post> posts, bool isDark) {
    if (posts.isEmpty) {
      return _buildEmptyExploreState(isDark);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ExploreBloc>()
                  .add(const LoadExplorePostsEvent(isRefresh: true));
            },
            color: const Color(0xFF0095F6),
            backgroundColor: isDark ? const Color(0xFF262626) : Colors.white,
            child: GridView.builder(
              padding: const EdgeInsets.all(1.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200 + (index * 30)),
                  curve: Curves.easeOutCubic,
                  child: EnhancedPostGridItem(
                    post: post,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserSearchList(List<User> users, bool isDark) {
    if (users.isEmpty) {
      return _buildNoUsersFoundState(isDark);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return AnimatedContainer(
                duration: Duration(milliseconds: 100 + (index * 50)),
                curve: Curves.easeOutCubic,
                child: EnhancedUserListItem(
                  user: user,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: user.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyExploreState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.explore_outlined,
              size: 48,
              color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Explore posts',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Discover new posts and content from the community.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUsersFoundState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for a different username',
            style: TextStyle(
              color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ExploreBloc>().add(const LoadExplorePostsEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0095F6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        'Explore content or search for users.',
        style: TextStyle(
          color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
          fontSize: 16,
        ),
      ),
    );
  }
}

class EnhancedPostGridItem extends StatefulWidget {
  final Post post;
  final bool isDark;

  const EnhancedPostGridItem({
    Key? key,
    required this.post,
    required this.isDark,
  }) : super(key: key);

  @override
  State<EnhancedPostGridItem> createState() => _EnhancedPostGridItemState();
}

class _EnhancedPostGridItemState extends State<EnhancedPostGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _scaleController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _scaleController.reverse();
              // Handle post tap
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _scaleController.reverse();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPostImage(),
                    _buildOverlayIndicators(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostImage() {
    return Image.network(
      widget.post.mediaUrl ?? '',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color:
              widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color:
              widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                color: widget.isDark
                    ? const Color(0xFF8E8E8E)
                    : const Color(0xFF8E8E8E),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Unable to load',
                style: TextStyle(
                  color: widget.isDark
                      ? const Color(0xFF8E8E8E)
                      : const Color(0xFF8E8E8E),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverlayIndicators() {
    return Stack(
      children: [
        // Video indicator
        if (widget.post.mediaType == 'video')
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

        // Multiple images indicator
        if (widget.post.mediaUrls.length > 1)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }
}

class EnhancedUserListItem extends StatelessWidget {
  final User user;
  final bool isDark;
  final VoidCallback onTap;

  const EnhancedUserListItem({
    Key? key,
    required this.user,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF262626)
                        : const Color(0xFFDBDBDB),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: user.profileImageUrl != null &&
                          user.profileImageUrl!.isNotEmpty
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  backgroundColor: isDark
                      ? const Color(0xFF262626)
                      : const Color(0xFFF0F0F0),
                  child: user.profileImageUrl == null ||
                          user.profileImageUrl!.isEmpty
                      ? Icon(
                          Icons.person,
                          color: isDark
                              ? const Color(0xFF8E8E8E)
                              : const Color(0xFF8E8E8E),
                          size: 28,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username ?? 'Unknown User',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
