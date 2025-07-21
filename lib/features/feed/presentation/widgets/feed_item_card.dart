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
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instagram AppBar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Text('Instagram',
                    style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 32,
                        color: Colors.white)),
                const Spacer(),
                Icon(Icons.favorite_border, color: Colors.white),
                const SizedBox(width: 16),
                Icon(Icons.send, color: Colors.white),
                const SizedBox(width: 8),
                Icon(Icons.add_circle_outline, color: Colors.white),
              ],
            ),
          ),
          // Stories Bar
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage(feedItem.user.profilePictureUrl ?? ''),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Story',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
          // Post Header
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage(feedItem.user.profilePictureUrl ?? ''),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(feedItem.user.username ?? '',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
          // Media Content
          AspectRatio(
            aspectRatio: 1.0,
            child: feedItem.mediaType == 'video'
                ? Container(color: Colors.black)
                : Image.network(feedItem.mediaUrl, fit: BoxFit.cover),
          ),
          // Sponsored CTA Bar
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                    child: Text('CTA copy here',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
          // Likes and Caption
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text('100 Likes',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                      text: 'Username ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Lorem ipsum dolor sit amet, consectetur'),
                ],
              ),
            ),
          ),
          // Icon Row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, color: Colors.white),
                const SizedBox(width: 16),
                Icon(Icons.send, color: Colors.white),
                const Spacer(),
                Icon(Icons.bookmark_border, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
