import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  /// Get all chats for a user
  Future<Either<Failure, List<Chat>>> getChats(String userId);
  
  /// Get a specific chat by id
  Future<Either<Failure, Chat>> getChatById(String chatId);
  
  /// Get or create a chat between two users
  Future<Either<Failure, Chat>> getOrCreateChat(String currentUserId, String otherUserId);
  
  /// Get messages for a specific chat
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  
  /// Send a message
  Future<Either<Failure, Message>> sendMessage(String chatId, String senderId, String receiverId, String content);
  
  /// Mark messages as read
  Future<Either<Failure, bool>> markMessagesAsRead(String chatId, String userId);
  
  /// Subscribe to new messages in a chat
  Stream<Either<Failure, Message>> subscribeToMessages(String chatId);
  
  /// Subscribe to chat updates (new chats, unread messages)
  Stream<Either<Failure, List<Chat>>> subscribeToChats(String userId);
}
