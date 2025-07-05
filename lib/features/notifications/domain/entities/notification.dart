import 'package:equatable/equatable.dart';

enum NotificationType {
  like,
  comment,
  follow,
  mention,
  taggedInPost,
  taggedInComment,
  newFollowerPost,
  system
}

class Notification extends Equatable {
  final String id;
  final String userId; // User who receives the notification
  final String?
      actorId; // User who triggered the notification (null for system notifications)
  final NotificationType type;
  final String? resourceId; // ID of the related resource (post, comment, etc.)
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? timestamp; // Added timestamp field
  final String? senderUsername; // Added sender username
  final String? senderProfilePictureUrl; // Added sender profile picture
  final String? relatedContentUrl; // Added related content URL

  const Notification({
    required this.id,
    required this.userId,
    this.actorId,
    required this.type,
    this.resourceId,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.timestamp,
    this.senderUsername,
    this.senderProfilePictureUrl,
    this.relatedContentUrl,
  });

  // Alias for compatibility
  DateTime? get timestampForDisplay => timestamp ?? createdAt;

  Notification copyWith({
    String? id,
    String? userId,
    String? actorId,
    NotificationType? type,
    String? resourceId,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    DateTime? timestamp,
    String? senderUsername,
    String? senderProfilePictureUrl,
    String? relatedContentUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      actorId: actorId ?? this.actorId,
      type: type ?? this.type,
      resourceId: resourceId ?? this.resourceId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      timestamp: timestamp ?? this.timestamp,
      senderUsername: senderUsername ?? this.senderUsername,
      senderProfilePictureUrl:
          senderProfilePictureUrl ?? this.senderProfilePictureUrl,
      relatedContentUrl: relatedContentUrl ?? this.relatedContentUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        actorId,
        type,
        resourceId,
        message,
        isRead,
        createdAt,
        timestamp,
        senderUsername,
        senderProfilePictureUrl,
        relatedContentUrl,
      ];
}
