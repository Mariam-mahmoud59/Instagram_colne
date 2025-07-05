import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/usecases/get_chats.dart';
import 'package:instagram_clone/features/chat/domain/usecases/get_messages.dart';
import 'package:instagram_clone/features/chat/domain/usecases/send_message.dart';
import 'package:instagram_clone/features/chat/domain/usecases/subscribe_to_chats.dart';
import 'package:instagram_clone/features/chat/domain/usecases/subscribe_to_messages.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChats getChats;
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final SubscribeToChats subscribeToChats;
  final SubscribeToMessages subscribeToMessages;

  ChatBloc({
    required this.getChats,
    required this.getMessages,
    required this.sendMessage,
    required this.subscribeToChats,
    required this.subscribeToMessages,
  }) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SubscribeToChatsEvent>(_onSubscribeToChats);
    on<SubscribeToMessagesEvent>(_onSubscribeToMessages);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<ChatsUpdatedEvent>(_onChatsUpdated);
  }

  Future<void> _onLoadChats(
      LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final result = await getChats(GetChatsParams(userId: event.userId));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (chats) => emit(ChatsLoaded(chats: chats)),
    );
  }

  Future<void> _onLoadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(MessagesLoading());
    final result = await getMessages(GetMessagesParams(chatId: event.chatId));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (messages) =>
          emit(MessagesLoaded(messages: messages, chatId: event.chatId)),
    );
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await sendMessage(SendMessageParams(
      chatId: event.chatId,
      senderId: event.senderId,
      receiverId: event.receiverId,
      content: event.content,
    ));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (message) => emit(MessageSent(message: message)),
    );
  }

  Future<void> _onSubscribeToChats(
      SubscribeToChatsEvent event, Emitter<ChatState> emit) async {
    final result =
        await subscribeToChats(SubscribeToChatsParams(userId: event.userId));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (stream) {
        // Handle stream subscription
        stream.listen((chatResult) {
          chatResult.fold(
            (failure) => emit(ChatError(message: failure.message)),
            (chats) => add(ChatsUpdatedEvent(chats: chats)),
          );
        });
      },
    );
  }

  Future<void> _onSubscribeToMessages(
      SubscribeToMessagesEvent event, Emitter<ChatState> emit) async {
    final result = await subscribeToMessages(
        SubscribeToMessagesParams(chatId: event.chatId));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (stream) {
        // Handle stream subscription
        stream.listen((messageResult) {
          messageResult.fold(
            (failure) => emit(ChatError(message: failure.message)),
            (message) => add(NewMessageReceivedEvent(message: message)),
          );
        });
      },
    );
  }

  void _onNewMessageReceived(
      NewMessageReceivedEvent event, Emitter<ChatState> emit) {
    // Get current messages from state if available
    List<Message> currentMessages = [];
    if (state is MessagesLoaded) {
      currentMessages = (state as MessagesLoaded).messages;
    }
    currentMessages.add(event.message);

    emit(NewMessageReceived(
      message: event.message,
      allMessages: currentMessages,
      chatId: event.message.chatId,
    ));
  }

  void _onChatsUpdated(ChatsUpdatedEvent event, Emitter<ChatState> emit) {
    emit(ChatsLoaded(chats: event.chats));
  }
}
