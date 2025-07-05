import 'package:instagram_clone/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:instagram_clone/features/notifications/data/models/notification_model.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient supabaseClient;

  NotificationRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<NotificationModel> createNotification({
    required String userId,
    String? actorId,
    required NotificationType type,
    String? resourceId,
    required String message,
  }) async {
    try {
      final notificationData = {
        'user_id': userId,
        'actor_id': actorId,
        'type': type.toString().split('.').last,
        'resource_id': resourceId,
        'message': message,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('notifications')
          .insert(notificationData)
          .select()
          .single();

      return NotificationModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Failed to create notification: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await supabaseClient
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      throw ServerException(message: 'Failed to delete notification: $e');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await supabaseClient
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get notifications: $e');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true}).eq('user_id', userId);
    } catch (e) {
      throw ServerException(
          message: 'Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      throw ServerException(message: 'Failed to mark notification as read: $e');
    }
  }

  @override
  Future<Stream<NotificationModel>> subscribeToNotifications(
      String userId) async {
    try {
      final stream = supabaseClient
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .map((event) => event
              .map((notification) => NotificationModel.fromJson(notification))
              .toList());

      // Return the first notification from each list event
      return stream.map((notifications) => notifications.first);
    } catch (e) {
      throw ServerException(
          message: 'Failed to subscribe to notifications: $e');
    }
  }
}
