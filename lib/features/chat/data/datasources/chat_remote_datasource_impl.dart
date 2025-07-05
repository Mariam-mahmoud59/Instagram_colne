import 'dart:async';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'
    as app_user;
import 'package:instagram_clone/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:instagram_clone/features/chat/data/models/chat_model.dart';
import 'package:instagram_clone/features/chat/data/models/message_model.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  final AuthRemoteDataSource authRemoteDataSource;

  ChatRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.authRemoteDataSource,
  });

  @override
  Future<Chat> getChatById(String chatId) async {
    try {
      final response =
          await supabaseClient.from('chats').select().eq('id', chatId).single();

      return ChatModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to get chat: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to get chat: $e');
    }
  }

  @override
  Future<List<Chat>> getChats(String userId) async {
    try {
      final response = await supabaseClient
          .from('chats')
          .select()
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('last_message_time', ascending: false);

      final List<Chat> chats = [];

      for (final chatJson in response) {
        // Determine the other user's ID
        // final otherUserId = chatJson['user1_id'] == userId
        //     ? chatJson['user2_id']
        //     : chatJson['user1_id'];

        // Get the other user's profile
        app_user.User? otherUser;
        try {
          otherUser = await authRemoteDataSource.getCurrentUser();
        } catch (e) {
          // If we can't get the other user, we'll just use null
          print('Failed to get other user: $e');
        }

        chats.add(ChatModel.fromJson(chatJson, otherUser: otherUser));
      }

      return chats;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to get chats: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to get chats: $e');
    }
  }

  @override
  Future<Chat> getOrCreateChat(String currentUserId, String otherUserId) async {
    try {
      // Check if a chat already exists between these users
      final existingChats = await supabaseClient.from('chats').select().or(
          'and(user1_id.eq.$currentUserId,user2_id.eq.$otherUserId),and(user1_id.eq.$otherUserId,user2_id.eq.$currentUserId)');

      if (existingChats.isNotEmpty) {
        // Chat already exists, get the other user and return the chat
        app_user.User? otherUser;
        try {
          otherUser = await authRemoteDataSource.getCurrentUser();
        } catch (e) {
          print('Failed to get other user: $e');
        }

        return ChatModel.fromJson(existingChats[0], otherUser: otherUser);
      }

      // No chat exists, create a new one
      final newChat = {
        'user1_id': currentUserId,
        'user2_id': otherUserId,
        'last_message_time': DateTime.now().toIso8601String(),
        'has_unread_messages': false,
      };

      final response =
          await supabaseClient.from('chats').insert(newChat).select().single();

      // Get the other user
      app_user.User? otherUser;
      try {
        otherUser = await authRemoteDataSource.getCurrentUser();
      } catch (e) {
        print('Failed to get other user: $e');
      }

      return ChatModel.fromJson(response, otherUser: otherUser);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to get or create chat: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to get or create chat: $e');
    }
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    try {
      final response = await supabaseClient
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('timestamp', ascending: true);

      return response
          .map<MessageModel>((json) => MessageModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to get messages: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to get messages: $e');
    }
  }

  @override
  Future<bool> markMessagesAsRead(String chatId, String userId) async {
    try {
      // Mark all messages where the user is the receiver as read
      await supabaseClient
          .from('messages')
          .update({'is_read': true})
          .eq('chat_id', chatId)
          .eq('receiver_id', userId)
          .eq('is_read', false);

      // Update the chat's unread status
      await supabaseClient
          .from('chats')
          .update({'has_unread_messages': false})
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .eq('id', chatId);

      return true;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to mark messages as read: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to mark messages as read: $e');
    }
  }

  @override
  Future<Message> sendMessage(
      String chatId, String senderId, String receiverId, String content) async {
    try {
      final newMessage = {
        'chat_id': chatId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
        'is_read': false,
      };

      final response = await supabaseClient
          .from('messages')
          .insert(newMessage)
          .select()
          .single();

      // Update the chat's last message time and unread status
      await supabaseClient.from('chats').update({
        'last_message_time': DateTime.now().toIso8601String(),
        'has_unread_messages': true,
      }).eq('id', chatId);

      return MessageModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to send message: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to send message: $e');
    }
  }

  @override
  Stream<List<Chat>> subscribeToChats(String userId) {
    final controller = StreamController<List<Chat>>();

    // Initial fetch of chats
    getChats(userId).then((chats) {
      controller.add(chats);
    }).catchError((error) {
      controller.addError(error);
    });

    // Subscribe to realtime changes
    final subscription = supabaseClient
        .channel('public:chats')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chats',
          callback: (payload) async {
            // Refetch all chats when there's a change
            try {
              final chats = await getChats(userId);
              controller.add(chats);
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    // Clean up subscription when the stream is closed
    controller.onCancel = () {
      subscription.unsubscribe();
    };

    return controller.stream;
  }

  @override
  Stream<Message> subscribeToMessages(String chatId) {
    final controller = StreamController<Message>();

    // Subscribe to realtime changes
    final subscription = supabaseClient
        .channel('public:messages:$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            try {
              final message = MessageModel.fromJson(payload.newRecord);
              controller.add(message);
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    // Clean up subscription when the stream is closed
    controller.onCancel = () {
      subscription.unsubscribe();
    };

    return controller.stream;
  }
}
