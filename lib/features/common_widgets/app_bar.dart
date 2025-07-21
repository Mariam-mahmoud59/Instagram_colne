// lib/features/common_widgets/app_bar.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/explore/presentation/screens/search_screen.dart';
import 'package:instagram_clone/features/post/presentation/screens/create_post_screen.dart';
import 'package:instagram_clone/features/chat/presentation/screens/chats_list_screen.dart'; // Corrected import for ChatsListScreen
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart'; // Added import for AuthBloc
import 'package:flutter_bloc/flutter_bloc.dart'; // Added import for BlocProvider
import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // Added import for User entity
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart'; // Added import for ChatBloc
import 'package:instagram_clone/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:instagram_clone/features/explore/presentation/screens/explore_screen.dart';
import 'package:instagram_clone/features/notifications/presentation/screens/notifications_screen.dart'; // Added import for NotificationsScreen

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final bool showDefaultActions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMessagesTap; // New callback for messages icon

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.showDefaultActions = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.onMessagesTap, // Add to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultActions = [
      //
      // _buildAppBarIcon(
      //   icon: Icons.add_box_outlined,
      //   onTap: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (_) => const CreatePostScreen(),
      //       ),
      //     );
      //   },
      // ),
      // const SizedBox(width: 8),

      // Activity/Notifications Icon
      _buildAppBarIcon(
        icon: Icons.favorite_border,
        onTap: () {
          final authState = BlocProvider.of<AuthBloc>(context).state;
          if (authState is Authenticated) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FavoritesScreen(userId: authState.user.id),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You must be logged in to view favorites.')),
            );
          }
        },
      ),

      const SizedBox(width: 8),

      // Messages Icon
      _buildAppBarIcon(
        icon: Icons.send_outlined,
        onTap: onMessagesTap ?? () {}, // Use the callback if provided
        rotation: 0.3, // Instagram's signature rotation
      ),

      const SizedBox(width: 8),

      // Explore/Search Icon
      _buildAppBarIcon(
        icon: Icons.search,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
      ),
      const SizedBox(width: 8),

      // Notifications Icon
      _buildAppBarIcon(
        icon: Icons.notifications_none,
        onTap: () {
          final authState = BlocProvider.of<AuthBloc>(context).state;
          if (authState is Authenticated) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NotificationsScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('You must be logged in to view notifications.')),
            );
          }
        },
      ),
      const SizedBox(width: 8),
    ];

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDBDBDB),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Leading widget or back button
              if (showBackButton || leading != null)
                leading ??
                    _buildAppBarIcon(
                      icon: Icons.arrow_back,
                      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                    ),

              if (showBackButton || leading != null) const SizedBox(width: 16),

              // Title
              if (!centerTitle)
                Expanded(
                  child: Text(
                    title ?? 'Instagram',
                    style: const TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF262626),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

              if (centerTitle) ...[
                const Spacer(),
                Text(
                  title ?? 'Instagram',
                  style: const TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF262626),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
              ],

              // Actions
              if (showDefaultActions)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions != null
                      ? [...actions!, ...defaultActions]
                      : defaultActions,
                )
              else if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onTap,
    double? rotation,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: rotation != null
            ? Transform.rotate(
                angle: rotation,
                child: Icon(
                  icon,
                  size: 26,
                  color: const Color(0xFF262626),
                ),
              )
            : Icon(
                icon,
                size: 26,
                color: const Color(0xFF262626),
              ),
      ),
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    'New likes on your post',
                    'Your post has received 15 new likes',
                    Icons.favorite,
                    Colors.red,
                  ),
                  _buildNotificationItem(
                    'New follower',
                    'john_doe started following you',
                    Icons.person_add,
                    Colors.blue,
                  ),
                  _buildNotificationItem(
                    'Comment on your post',
                    'sarah_smith commented on your photo',
                    Icons.comment,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessagesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildMessageItem(
                    'John Doe',
                    'Hey! How are you doing?',
                    '2m',
                    true,
                  ),
                  _buildMessageItem(
                    'Sarah Smith',
                    'Thanks for the follow!',
                    '1h',
                    false,
                  ),
                  _buildMessageItem(
                    'Mike Johnson',
                    'Great photo! 📸',
                    '3h',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    String name,
    String message,
    String time,
    bool isUnread,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile picture placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFDBDBDB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF8E8E8E),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isUnread ? FontWeight.w600 : FontWeight.w400,
                        color: const Color(0xFF262626),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnread
                        ? const Color(0xFF262626)
                        : const Color(0xFF8E8E8E),
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          if (isUnread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF0095F6),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// Instagram-style Search AppBar
class InstagramSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onBackPressed;

  const InstagramSearchAppBar({
    Key? key,
    this.searchController,
    this.onSearchChanged,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDBDBDB),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 26,
                    color: Color(0xFF262626),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Color(0xFF8E8E8E),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF8E8E8E),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
