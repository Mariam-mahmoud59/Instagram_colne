import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  /// Get all chats for a user
  Future<List<Chat>> getChats(String userId);

  /// Get a specific chat by id
  Future<Chat> getChatById(String chatId);

  /// Get or create a chat between two users
  Future<Chat> getOrCreateChat(String currentUserId, String otherUserId);

  /// Get messages for a specific chat
  Future<List<Message>> getMessages(String chatId);

  /// Send a message
  Future<Message> sendMessage(
      String chatId, String senderId, String receiverId, String content);

  /// Mark messages as read
  Future<bool> markMessagesAsRead(String chatId, String userId);

  /// Subscribe to new messages in a chat
  Stream<Message> subscribeToMessages(String chatId);

  /// Subscribe to chat updates (new chats, unread messages)
  Stream<List<Chat>> subscribeToChats(String userId);
}
