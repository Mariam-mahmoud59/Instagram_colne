import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.user1Id,
    required super.user2Id,
    required super.lastMessageTime,
    required super.hasUnreadMessages,
    super.otherUser,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, {User? otherUser}) {
    return ChatModel(
      id: json['id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      hasUnreadMessages: json['has_unread_messages'] ?? false,
      otherUser: otherUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'last_message_time': lastMessageTime.toIso8601String(),
      'has_unread_messages': hasUnreadMessages,
    };
  }
}
