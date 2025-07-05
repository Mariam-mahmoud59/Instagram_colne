import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';

class Chat extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;
  final User? otherUser; // The user that is not the current user
  final String? lastMessageContent; // Added for compatibility

  const Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessageTime,
    required this.hasUnreadMessages,
    this.otherUser,
    this.lastMessageContent,
  });

  // Alias for compatibility
  String? get otherParticipantProfilePictureUrl => otherUser?.profilePictureUrl;
  String? get otherParticipantName => otherUser?.username ?? otherUser?.name;

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        lastMessageTime,
        hasUnreadMessages,
        otherUser,
        lastMessageContent
      ];
}
