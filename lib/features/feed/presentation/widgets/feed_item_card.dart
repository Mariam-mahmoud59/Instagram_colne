// lib/features/feed/presentation/widgets/feed_item_card.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/common_widgets/user_avatar.dart'; // Assuming UserAvatar is defined
import 'package:instagram_clone/features/post/presentation/widgets/post_actions.dart'; // Assuming PostActions is defined
import 'package:instagram_clone/features/post/presentation/widgets/video_player_widget.dart'; // Assuming VideoPlayerWidget is defined
import '../../domain/entities/feed_item.dart'; // Assuming FeedItem entity is defined
import 'package:timeago/timeago.dart' as timeago;

class FeedItemCard extends StatelessWidget {
  final FeedItem feedItem;
  final Function(String postId) onPostTap;
  final Function(String postId, bool isLiked, int likesCount) onLikeToggle;
  // Add more callbacks for comments, share, save

  const FeedItemCard({
    Key? key,
    required this.feedItem,
    required this.onPostTap,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info and Options
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                UserAvatar(
                  imageUrl: feedItem.user.profilePictureUrl,
                  radius: 18,
                  onTap: () {
                    // Navigate to user profile
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(userId: feedItem.user.id)));
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feedItem.user.username ??
                        feedItem.user.email ??
                        'Unknown User',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show post options (report, unfollow, etc.)
                  },
                ),
              ],
            ),
          ),

          // Media Content (Image or Video)
          GestureDetector(
            onDoubleTap: () {
              // Implement like on double tap
              onLikeToggle(feedItem.id, true,
                  feedItem.likesCount + 1); // Assuming it's not liked yet
            },
            onTap: () => onPostTap(feedItem.id),
            child: AspectRatio(
              aspectRatio: 1.0, // Square aspect ratio for posts
              child: feedItem.mediaType == 'video'
                  ? VideoPlayerWidget(videoUrl: feedItem.mediaUrl)
                  : Image.network(
                      feedItem.mediaUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.broken_image, size: 50)),
                    ),
            ),
          ),

          // Actions (Like, Comment, Share, Save)
          PostActions(
            postId: feedItem.id,
            userId: feedItem.user.id,
            post: feedItem.toPost(),
            isLiked: false, // You'll need to pass actual like status
            likesCount: feedItem.likesCount,
            onLikeToggle: onLikeToggle,
            onComment: () {
              // Navigate to comments screen
            },
            onShare: () {
              // Implement share functionality
            },
          ),

          // Likes Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '${feedItem.likesCount} likes',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),

          // Caption
          if (feedItem.caption != null && feedItem.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '${feedItem.user.username ?? 'Unknown User'} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: feedItem.caption ?? ''),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),

          // View all comments (placeholder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to comments screen
              },
              child: Text(
                'View all ${feedItem.commentsCount} comments',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Time Ago
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              timeago.format(feedItem.createdAt),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
