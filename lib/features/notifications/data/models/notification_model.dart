import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.userId,
    super.actorId,
    required super.type,
    super.resourceId,
    required super.message,
    super.isRead = false,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      actorId: json['actor_id'],
      type: _mapStringToNotificationType(json['type']),
      resourceId: json['resource_id'],
      message: json['message'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'actor_id': actorId,
      'type': type.toString().split('.').last,
      'resource_id': resourceId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static NotificationType _mapStringToNotificationType(String type) {
    switch (type) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'mention':
        return NotificationType.mention;
      case 'taggedInPost':
        return NotificationType.taggedInPost;
      case 'taggedInComment':
        return NotificationType.taggedInComment;
      case 'newFollowerPost':
        return NotificationType.newFollowerPost;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }
}
