import 'package:instagram_clone/features/notifications/data/models/notification_model.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';

abstract class NotificationRemoteDataSource {
  /// Get all notifications for a user
  Future<List<NotificationModel>> getNotifications(String userId);

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId);

  /// Delete a notification
  Future<void> deleteNotification(String notificationId);

  /// Create a notification
  Future<NotificationModel> createNotification({
    required String userId,
    String? actorId,
    required NotificationType type,
    String? resourceId,
    required String message,
  });

  /// Subscribe to real-time notifications
  Future<Stream<NotificationModel>> subscribeToNotifications(String userId);
}
