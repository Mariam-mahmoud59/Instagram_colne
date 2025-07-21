import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/generated/app_localizations.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:instagram_clone/features/chat/presentation/screens/chat_detail_screen.dart';

class ChatsListScreen extends StatefulWidget {
  final User currentUser;

  const ChatsListScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadChats();
    _subscribeToChats();
  }

  void _loadChats() {
    context.read<ChatBloc>().add(LoadChatsEvent(userId: widget.currentUser.id));
  }

  void _subscribeToChats() {
    context
        .read<ChatBloc>()
        .add(SubscribeToChatsEvent(userId: widget.currentUser.id));
  }

  @override
  Widget build(BuildContext context) {
    print('Building ChatsListScreen');
    final l10n = AppLocalizations.of(context);
    print('AppLocalizations: $l10n');
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.messages ?? 'Messages'),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          print('ChatBloc state: $state');
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsLoaded) {
            return _buildChatsList(state.chats, l10n);
          } else {
            return _buildChatsList([], l10n);
          }
        },
      ),
    );
  }

  Widget _buildChatsList(List<Chat> chats, AppLocalizations? l10n) {
    print('Building chat list with count: ${chats.length}');
    if (chats.isEmpty) {
      return Center(
        child: Text(l10n?.noMessages ?? 'No messages'),
      );
    }
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        print('chat: $chat');
        final otherUser = chat.otherUser;
        print('otherUser for chat ${chat.id}: $otherUser');
        if (chat.id == null) {
          return ListTile(
            leading: const Icon(Icons.error, color: Colors.red),
            title: const Text('Invalid chat'),
            subtitle: const Text('Chat ID is missing'),
          );
        }
        if (otherUser == null) {
          return ListTile(
            leading: const Icon(Icons.error, color: Colors.red),
            title: const Text('Unknown user'),
            subtitle: const Text('User data is missing'),
          );
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: otherUser.profileImageUrl != null
                ? NetworkImage(otherUser.profileImageUrl!)
                : null,
            child: otherUser.profileImageUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(otherUser.username ?? 'Unknown User'),
          subtitle: Text(
            chat.hasUnreadMessages ? 'New messages' : 'No new messages',
            style: TextStyle(
              fontWeight:
                  chat.hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: chat.hasUnreadMessages
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            print('Tapped chat: ${chat.id}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  chat: chat,
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
