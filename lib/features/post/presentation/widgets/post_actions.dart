// lib/features/post/presentation/widgets/post_actions.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/favorites/presentation/widgets/save_post_button.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class PostActions extends StatelessWidget {
  final String postId;
  final String userId;
  final Post post;
  final bool isLiked;
  final int likesCount;
  final Function(String postId, bool isLiked, int likesCount) onLikeToggle;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostActions({
    Key? key,
    required this.postId,
    required this.userId,
    required this.post,
    required this.isLiked,
    required this.likesCount,
    required this.onLikeToggle,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          // Like Button
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
            ),
            onPressed: () => onLikeToggle(
                postId, !isLiked, isLiked ? likesCount - 1 : likesCount + 1),
          ),
          // Comment Button
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: onComment,
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: onShare,
          ),
          const Spacer(), // Pushes save button to the end
          // Save Button
          SavePostButton(
            userId: userId,
            postId: postId,
            post: post,
          ),
        ],
      ),
    );
  }
}
