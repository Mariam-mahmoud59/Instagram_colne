// lib/features/explore/presentation/widgets/explore_grid.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart'; // Assuming Post entity is defined

class ExploreGrid extends StatelessWidget {
  final List<Post> posts;
  final Function(String postId) onPostTap;

  const ExploreGrid({
    Key? key,
    required this.posts,
    required this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('No posts to explore yet.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        crossAxisSpacing: 2.0, // Spacing between columns
        mainAxisSpacing: 2.0, // Spacing between rows
        childAspectRatio: 1.0, // Square items
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () => onPostTap(post.id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder background color
              image: post.mediaUrls.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(post.mediaUrls.first),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: post.mediaUrls.isEmpty
                ? const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey))
                : null,
            // Optionally add an icon for video posts
            // if (post.mediaType == 'video')
            //   const Positioned(
            //     top: 5,
            //     right: 5,
            //     child: Icon(Icons.videocam, color: Colors.white, size: 20),
            //   ),
          ),
        );
      },
    );
  }
}
