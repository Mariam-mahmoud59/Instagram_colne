part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatEvent {
  final String userId;

  const LoadChatsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class GetOrCreateChatEvent extends ChatEvent {
  final String currentUserId;
  final String otherUserId;

  const GetOrCreateChatEvent({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object?> get props => [currentUserId, otherUserId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  @override
  List<Object?> get props => [chatId, senderId, receiverId, content];
}

class MarkMessagesAsReadEvent extends ChatEvent {
  final String chatId;
  final String userId;

  const MarkMessagesAsReadEvent({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object?> get props => [chatId, userId];
}

class SubscribeToMessagesEvent extends ChatEvent {
  final String chatId;

  const SubscribeToMessagesEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class SubscribeToChatsEvent extends ChatEvent {
  final String userId;

  const SubscribeToChatsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NewMessageReceivedEvent extends ChatEvent {
  final Message message;

  const NewMessageReceivedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatsUpdatedEvent extends ChatEvent {
  final List<Chat> chats;

  const ChatsUpdatedEvent({required this.chats});

  @override
  List<Object?> get props => [chats];
}
