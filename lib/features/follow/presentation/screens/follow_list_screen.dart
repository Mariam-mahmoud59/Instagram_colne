import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/follow/presentation/bloc/follow_bloc.dart';
import 'package:instagram_clone/features/profile/presentation/screens/profile_screen.dart'; // To navigate to user profiles
import 'package:instagram_clone/features/follow/presentation/widgets/follow_button.dart'; // Reusable follow button

enum FollowListType { followers, following }

class FollowListScreen extends StatefulWidget {
  final String userId;
  final FollowListType initialListType;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.initialListType,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialListType == FollowListType.followers ? 0 : 1,
    );
    // Load initial list based on the tab
    _loadInitialData();
  }

  void _loadInitialData() {
    if (_tabController.index == 0) {
      context.read<FollowBloc>().add(LoadFollowersEvent(userId: widget.userId));
    } else {
      context.read<FollowBloc>().add(LoadFollowingEvent(userId: widget.userId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming FollowBloc is provided higher up
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'), // Or username
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
          onTap: (index) {
            // Load data when tab changes
            if (index == 0) {
              context
                  .read<FollowBloc>()
                  .add(LoadFollowersEvent(userId: widget.userId));
            } else {
              context
                  .read<FollowBloc>()
                  .add(LoadFollowingEvent(userId: widget.userId));
            }
          },
        ),
      ),
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, state) {
          if (state is FollowListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FollowersLoaded && _tabController.index == 0) {
            return _buildUserList(state.followers);
          } else if (state is FollowingLoaded && _tabController.index == 1) {
            return _buildUserList(state.following);
          } else if (state is FollowListLoadFailure) {
            return Center(child: Text('Error loading list: ${state.message}'));
          } else if (state is FollowInitial && _tabController.index == 0) {
            // Handle case where initial load hasn't happened for followers tab
            context
                .read<FollowBloc>()
                .add(LoadFollowersEvent(userId: widget.userId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is FollowInitial && _tabController.index == 1) {
            // Handle case where initial load hasn't happened for following tab
            context
                .read<FollowBloc>()
                .add(LoadFollowingEvent(userId: widget.userId));
            return const Center(child: CircularProgressIndicator());
          } else if (_tabController.index == 0 && state is! FollowersLoaded) {
            // If on followers tab but state is not FollowersLoaded (e.g., after follow/unfollow)
            // Trigger reload or show previous state if available
            context
                .read<FollowBloc>()
                .add(LoadFollowersEvent(userId: widget.userId));
            return const Center(
                child: Text('Reloading followers...')); // Or show stale data
          } else if (_tabController.index == 1 && state is! FollowingLoaded) {
            // If on following tab but state is not FollowingLoaded
            context
                .read<FollowBloc>()
                .add(LoadFollowingEvent(userId: widget.userId));
            return const Center(
                child: Text('Reloading following...')); // Or show stale data
          }
          // Default empty state or handle other states
          return const Center(child: Text('No users found.'));
        },
      ),
    );
  }

  Widget _buildUserList(List<User> users) {
    if (users.isEmpty) {
      return Center(
          child: Text(_tabController.index == 0
              ? 'No followers yet.'
              : 'Not following anyone yet.'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
            child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.username ?? 'Unknown User'),
          // subtitle: Text(user.fullName ?? ''), // Add if available
          trailing: FollowButton(
              targetUserId: user.id), // Show follow/unfollow button
          onTap: () {
            // Navigate to the user's profile screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userId: user.id), // Pass user ID
              ),
            );
          },
        );
      },
    );
  }
}
