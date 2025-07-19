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
  const _FavoritesScreenContent({Key? key, required this.userId})
      : super(key: key);

  @override
  State<_FavoritesScreenContent> createState() =>
      _FavoritesScreenContentState();
}

class _FavoritesScreenContentState extends State<_FavoritesScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavoritesEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoritesError && state is! FavoritesLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PostUnsaved) {
            context
                .read<FavoriteBloc>()
                .add(LoadFavoritesEvent(userId: widget.userId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post removed from saved')),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoritesError && state is! FavoritesLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(child: Text('No saved posts yet'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<FavoriteBloc>()
                    .add(LoadFavoritesEvent(userId: widget.userId));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return FavoritePostItem(
                    favorite: favorite,
                    onTap: () {
                      // Navigate to post detail
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen(post: favorite.post!)));
                    },
                    onUnsave: () {
                      context
                          .read<FavoriteBloc>()
                          .add(UnsavePostEvent(favoriteId: favorite.id));
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Failed to load saved posts'));
          }
        },
      ),
    );
  }
}

class FavoritePostItem extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const FavoritePostItem({
    Key? key,
    required this.favorite,
    required this.onTap,
    required this.onUnsave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = favorite.post;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Post image
          Image.network(
            post?.mediaUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),

          // Unsave button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onUnsave,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Video indicator
          if (post?.mediaType == 'video')
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
