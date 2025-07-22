import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;

class FavoritesScreen extends StatelessWidget {
  final String userId;

  const FavoritesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteBloc>(
      create: (_) => di.sl<FavoriteBloc>(),
      child: _FavoritesScreenContent(userId: userId),
    );
  }
}

class _FavoritesScreenContent extends StatefulWidget {
  final String userId;
  const _FavoritesScreenContent({required this.userId});

  @override
  State<_FavoritesScreenContent> createState() =>
      _FavoritesScreenContentState();
}

class _FavoritesScreenContentState extends State<_FavoritesScreenContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    context.read<FavoriteBloc>().add(LoadFavoritesEvent(userId: widget.userId));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFFAFAFA),
      appBar: _buildModernAppBar(context, isDark),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoritesError && state is! FavoritesLoaded) {
            _showErrorSnackBar(context, state.message);
          } else if (state is PostUnsaved) {
            context
                .read<FavoriteBloc>()
                .add(LoadFavoritesEvent(userId: widget.userId));
            _showSuccessSnackBar(context, 'Post removed from saved');
          }
        },
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return _buildEmptyState(isDark);
            }
            return _buildFavoritesList(favorites, isDark);
          } else if (state is FavoritesError) {
            return Center(
                child:
                    Text(state.message, style: TextStyle(color: Colors.red)));
          }
          // fallback for any other state
          return Center(
              child: Text('No data.', style: TextStyle(color: Colors.grey)));
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black,
          size: 22,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Saved',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: isDark ? Colors.white : Colors.black,
            size: 24,
          ),
          onPressed: () {
            _showOptionsBottomSheet(context, isDark);
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color: isDark ? const Color(0xFF262626) : const Color(0xFFDBDBDB),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0,
              ),
              itemCount: 12,
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
      child: const SizedBox.expand(),
    );
  }

  Widget _buildEmptyState(bool isDark) {
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
              Icons.bookmark_outline,
              size: 48,
              color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Save posts for later',
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
              'Bookmark posts to easily find them again in the future.',
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

  Widget _buildErrorState(bool isDark) {
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
            'Unable to load saved posts',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              color: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context
                  .read<FavoriteBloc>()
                  .add(LoadFavoritesEvent(userId: widget.userId));
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

  Widget _buildFavoritesList(List<Favorite> favorites, bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: RefreshIndicator(
            onRefresh: () async {
              _refreshController.forward().then((_) {
                _refreshController.reset();
              });
              context
                  .read<FavoriteBloc>()
                  .add(LoadFavoritesEvent(userId: widget.userId));
            },
            color: const Color(0xFF0095F6),
            backgroundColor: isDark ? const Color(0xFF262626) : Colors.white,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(1.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final favorite = favorites[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200 + (index * 50)),
                          curve: Curves.easeOutCubic,
                          child: EnhancedFavoritePostItem(
                            favorite: favorite,
                            isDark: isDark,
                            onTap: () {
                              _handlePostTap(favorite);
                            },
                            onUnsave: () {
                              _handleUnsave(favorite);
                            },
                          ),
                        );
                      },
                      childCount: favorites.length,
                    ),
                  ),
                ),
                // Add some bottom padding
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePostTap(Favorite favorite) {
    // Navigate to post detail
    // Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen(post: favorite.post!)));
  }

  void _handleUnsave(Favorite favorite) {
    context.read<FavoriteBloc>().add(UnsavePostEvent(favoriteId: favorite.id));
  }

  void _showOptionsBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF262626) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF8E8E8E) : const Color(0xFFDBDBDB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _buildBottomSheetOption(
              context,
              isDark,
              Icons.folder_outlined,
              'Create Collection',
              () {
                Navigator.pop(context);
                // Handle create collection
              },
            ),
            _buildBottomSheetOption(
              context,
              isDark,
              Icons.sort,
              'Sort Posts',
              () {
                Navigator.pop(context);
                // Handle sort posts
              },
            ),
            _buildBottomSheetOption(
              context,
              isDark,
              Icons.select_all,
              'Select Posts',
              () {
                Navigator.pop(context);
                // Handle select posts
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context,
    bool isDark,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.black,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class EnhancedFavoritePostItem extends StatefulWidget {
  final Favorite favorite;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const EnhancedFavoritePostItem({
    Key? key,
    required this.favorite,
    required this.isDark,
    required this.onTap,
    required this.onUnsave,
  }) : super(key: key);

  @override
  State<EnhancedFavoritePostItem> createState() =>
      _EnhancedFavoritePostItemState();
}

class _EnhancedFavoritePostItemState extends State<EnhancedFavoritePostItem>
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
    final post = widget.favorite.post;

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
              widget.onTap();
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
                    // Post image with loading and error states
                    _buildPostImage(post?.mediaUrl ?? ''),

                    // Gradient overlay for better button visibility
                    _buildGradientOverlay(),

                    // Video indicator
                    if (post?.mediaType == 'video') _buildVideoIndicator(),

                    // Multiple images indicator
                    if (post != null && post.mediaUrls.length > 1)
                      _buildMultipleImagesIndicator(),

                    // Unsave button
                    _buildUnsaveButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostImage(String imageUrl) {
    return Image.network(
      imageUrl,
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

  Widget _buildGradientOverlay() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.8, -0.8),
            radius: 1.0,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoIndicator() {
    return Positioned(
      bottom: 8,
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
    );
  }

  Widget _buildMultipleImagesIndicator() {
    return Positioned(
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
    );
  }

  Widget _buildUnsaveButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () {
          _showUnsaveConfirmation();
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showUnsaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF262626) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove from Saved?',
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'This post will be removed from your saved posts.',
          style: TextStyle(
            color: widget.isDark
                ? const Color(0xFF8E8E8E)
                : const Color(0xFF8E8E8E),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onUnsave();
            },
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
