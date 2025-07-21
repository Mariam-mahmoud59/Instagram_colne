import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/widgets/post_grid_item.dart'; // Assuming this widget exists
import 'package:instagram_clone/features/profile/presentation/screens/profile_screen.dart'; // To navigate to user profiles

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load initial explore posts
    context.read<ExploreBloc>().add(const LoadExplorePostsEvent());

    // Clear search when focus is lost and text is empty (optional)
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
        context.read<ExploreBloc>().add(ClearSearchEvent());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        // Potentially add other actions if needed
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state is ExploreLoading || (state is ExploreInitial && _searchController.text.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExplorePostsLoaded && _searchController.text.isEmpty) {
            return _buildExploreGrid(state.posts);
          } else if (state is ExploreSearchLoading && _searchController.text.isNotEmpty) {
            // Show loading indicator while searching
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExploreSearchResultsLoaded && _searchController.text.isNotEmpty) {
            return _buildUserSearchList(state.users);
          } else if (state is ExploreError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (_searchController.text.isNotEmpty && state is! ExploreSearchResultsLoaded) {
             // If searching but results not loaded yet (e.g., initial search state)
             return const Center(child: CircularProgressIndicator());
          } else if (_searchController.text.isEmpty && state is! ExplorePostsLoaded) {
             // If not searching but posts not loaded (e.g., after clearing search)
             context.read<ExploreBloc>().add(const LoadExplorePostsEvent()); // Trigger reload
             return const Center(child: CircularProgressIndicator());
          }
          // Default fallback
          return const Center(child: Text('Explore content or search for users.'));
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: const Icon(Icons.search),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200], // Adjust color as needed
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<ExploreBloc>().add(ClearSearchEvent());
                  _searchFocusNode.unfocus(); // Unfocus after clearing
                },
              )
            : null,
      ),
      onChanged: (query) {
        context.read<ExploreBloc>().add(SearchQueryChangedEvent(query: query));
      },
      onTap: () {
        // Ensure the state reflects search mode if tapped
        if (_searchController.text.isNotEmpty) {
           context.read<ExploreBloc>().add(SearchQueryChangedEvent(query: _searchController.text));
        }
      },
    );
  }

  Widget _buildExploreGrid(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('No posts to explore yet.'));
    }
    // Use a GridView to display posts
    return RefreshIndicator(
      onRefresh: () async {
         context.read<ExploreBloc>().add(const LoadExplorePostsEvent(isRefresh: true));
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Standard Instagram grid
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          // Use a dedicated widget for the grid item
          return PostGridItem(post: post);
        },
      ),
    );
  }

  Widget _buildUserSearchList(List<User> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.username ?? 'Unknown User'),
          // subtitle: Text(user.fullName ?? ''), // Add if available
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