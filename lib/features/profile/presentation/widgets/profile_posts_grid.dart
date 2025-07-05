// lib/features/profile/presentation/widgets/profile_posts_grid.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart'; // Assuming Post entity is defined
import 'package:instagram_clone/features/post/presentation/screens/post_detail_screen.dart'; // To navigate to post details

class ProfilePostsGrid extends StatelessWidget {
  final List<Post> posts;
  final Function(String postId)? onPostTap;

  const ProfilePostsGrid({
    Key? key,
    required this.posts,
    this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('No posts yet.'),
      );
    }

    return GridView.builder(
      shrinkWrap: true, // Important for nested scroll views
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling for this grid
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
          onTap: () {
            if (onPostTap != null) {
              onPostTap!(post.id);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(postId: post.id),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder background color
              image: (post.mediaUrl?.isNotEmpty == true)
                  ? DecorationImage(
                      image: NetworkImage(post.mediaUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: post.mediaType == 'video'
                ? const Center(
                    child: Icon(Icons.videocam, color: Colors.white, size: 30))
                : null,
          ),
        );
      },
    );
  }
}
