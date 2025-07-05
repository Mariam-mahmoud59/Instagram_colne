// lib/features/notifications/presentation/widgets/notification_item.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/common_widgets/user_avatar.dart'; // Assuming UserAvatar is defined
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart'
    as app_notification; // Alias to avoid conflict with flutter.material.Notification
import 'package:timeago/timeago.dart' as timeago; // For formatting time

class NotificationItem extends StatelessWidget {
  final app_notification.Notification notification;
  final VoidCallback?
      onTap; // Optional callback when the notification is tapped
  final VoidCallback? onMarkAsRead; // Optional callback to mark as read

  const NotificationItem({
    Key? key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onMarkAsRead, // Example: long press to mark as read
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        color: notification.isRead
            ? Theme.of(context).cardColor
            : Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.05), // Highlight unread
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              imageUrl: notification.senderProfilePictureUrl,
              radius: 24,
              onTap: () {
                // Navigate to sender's profile
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(userId: notification.senderId)));
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: notification.senderUsername,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${notification.message} '),
                        TextSpan(
                          text: timeago
                              .format(notification.timestamp ?? DateTime.now()),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  // Optional: Display related content (e.g., post thumbnail for a like notification)
                  if (notification.relatedContentUrl != null &&
                      notification.relatedContentUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          notification.relatedContentUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Optional: Action button (e.g., Follow button for new follower notification)
            if (notification.type == 'follow' &&
                !notification.isRead) // Example condition
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement follow action
                    // context.read<FollowBloc>().add(FollowUserEvent(notification.senderId));
                    // Then mark notification as read
                    onMarkAsRead?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero, // Set this
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6), // and this
                  ),
                  child: const Text('Follow Back'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
