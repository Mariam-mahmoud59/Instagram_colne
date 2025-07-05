import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:instagram_clone/features/chat/presentation/screens/chats_list_screen.dart';
import 'package:instagram_clone/features/explore/presentation/screens/explore_screen.dart';
import 'package:instagram_clone/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:instagram_clone/features/notifications/presentation/screens/notification_screen.dart';
import 'package:instagram_clone/features/post/presentation/screens/create_post_screen.dart';
import 'package:instagram_clone/features/post/presentation/screens/video_explore_tab.dart'; // New video explore tab
import 'package:instagram_clone/features/profile/presentation/screens/profile_screen.dart';
import 'package:instagram_clone/features/settings/presentation/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // If user is unauthenticated, navigate to login screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                ExploreScreen(),
                ExploreScreen(),
                CreatePostScreen(),
                VideoExploreTab(),
                NotificationScreen(),
                FavoritesScreen(userId: user.id),
                ChatsListScreen(currentUser: user),
                ProfileScreen(userId: user.id),
                SettingsScreen(userId: 'user.id',),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_collection_outlined),
                  label: 'Reels', // Video Explore
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              type: BottomNavigationBarType
                  .fixed, // Ensures all items are visible
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            ),
          );
        }
        // Show a loading indicator or splash screen while authentication state is being determined
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
