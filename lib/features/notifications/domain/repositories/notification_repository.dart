import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  /// Get all notifications for a user
  Future<Either<Failure, List<Notification>>> getNotifications(String userId);
  
  /// Mark a notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);
  
  /// Mark all notifications as read for a user
  Future<Either<Failure, void>> markAllAsRead(String userId);
  
  /// Delete a notification
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  
  /// Create a notification
  Future<Either<Failure, Notification>> createNotification({
    required String userId,
    String? actorId,
    required NotificationType type,
    String? resourceId,
    required String message,
  });
  
  /// Subscribe to real-time notifications
  Future<Either<Failure, Stream<Notification>>> subscribeToNotifications(String userId);
}
