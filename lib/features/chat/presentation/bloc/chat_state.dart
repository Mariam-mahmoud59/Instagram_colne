part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  
  const ChatsLoaded({required this.chats});
  
  @override
  List<Object?> get props => [chats];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final String chatId;
  
  const MessagesLoaded({
    required this.messages,
    required this.chatId,
  });
  
  @override
  List<Object?> get props => [messages, chatId];
}

class ChatCreated extends ChatState {
  final Chat chat;
  
  const ChatCreated({required this.chat});
  
  @override
  List<Object?> get props => [chat];
}

class MessageSent extends ChatState {
  final Message message;
  
  const MessageSent({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class MessagesMarkedAsRead extends ChatState {
  final String chatId;
  
  const MessagesMarkedAsRead({required this.chatId});
  
  @override
  List<Object?> get props => [chatId];
}

class ChatError extends ChatState {
  final String message;
  
  const ChatError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class SubscribedToMessages extends ChatState {
  final String chatId;
  
  const SubscribedToMessages({required this.chatId});
  
  @override
  List<Object?> get props => [chatId];
}

class SubscribedToChats extends ChatState {
  final String userId;
  
  const SubscribedToChats({required this.userId});
  
  @override
  List<Object?> get props => [userId];
}

class NewMessageReceived extends ChatState {
  final Message message;
  final List<Message> allMessages;
  final String chatId;
  
  const NewMessageReceived({
    required this.message,
    required this.allMessages,
    required this.chatId,
  });
  
  @override
  List<Object?> get props => [message, allMessages, chatId];
}
