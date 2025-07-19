import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:instagram_clone/features/profile/presentation/screens/edit_profile_screen.dart'; // To be created
import 'package:instagram_clone/features/settings/presentation/screens/settings_screen.dart';
import 'package:instagram_clone/features/common_widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For network images

class ProfileScreen extends StatefulWidget {
  final String userId; // ID of the profile to display

  const ProfileScreen({required this.userId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load the profile when the screen initializes
    context.read<ProfileBloc>().add(LoadProfile(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    // Get the current authenticated user's ID to check if this is their own profile
    final currentAuthUserId = (context.read<AuthBloc>().state is Authenticated)
        ? (context.read<AuthBloc>().state as Authenticated).user.id
        : null;
    final isOwnProfile = currentAuthUserId == widget.userId;

    return Scaffold(
      appBar: CustomAppBar(
        title: (context.read<ProfileBloc>().state is ProfileLoaded)
            ? (context.read<ProfileBloc>().state as ProfileLoaded)
                .profile
                .username
            : 'Profile',
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final currentState = context.read<ProfileBloc>().state;
                if (currentState is ProfileLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                          currentProfile: currentState.profile),
                    ),
                  ).then((_) {
                    context
                        .read<ProfileBloc>()
                        .add(LoadProfile(userId: widget.userId));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile data not loaded yet.')),
                  );
                }
              },
            ),
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(userId: widget.userId),
                  ),
                );
              },
            ),
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
        ],
        showDefaultActions: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProfileBloc>()
                    .add(LoadProfile(userId: widget.userId));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profile.profileImageUrl != null
                              ? CachedNetworkImageProvider(
                                  profile.profileImageUrl!)
                              : null,
                          child: profile.profileImageUrl == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn('Posts', profile.postCount),
                              _buildStatColumn(
                                  'Followers', profile.followerCount),
                              _buildStatColumn(
                                  'Following', profile.followingCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (profile.fullName != null &&
                            profile.fullName!.isNotEmpty)
                          Text(profile.fullName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        if (profile.bio != null && profile.bio!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(profile.bio!),
                          ),
                        
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isOwnProfile
                                ? () {
                                    final currentState =
                                        context.read<ProfileBloc>().state;
                                    if (currentState is ProfileLoaded) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditProfileScreen(
                                              currentProfile:
                                                  currentState.profile),
                                        ),
                                      ).then((_) {
                                        context.read<ProfileBloc>().add(
                                            LoadProfile(userId: widget.userId));
                                      });
                                    }
                                  }
                                : () {
                                    // زر متابعة (Follow)
                                  },
                            child:
                                Text(isOwnProfile ? 'Edit Profile' : 'Follow'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        if (!isOwnProfile) const SizedBox(width: 8),
                        if (!isOwnProfile)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Message'),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // تبويبات (شبكة، فيديو، إلخ)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.grid_on, size: 28),
                        Icon(Icons.video_collection_outlined, size: 28),
                        Icon(Icons.person_pin_outlined, size: 28),
                      ],
                    ),
                  ),
                  // شبكة الصور
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 12, // عدل حسب عدد المنشورات الحقيقي
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.image)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
                child: Text('Failed to load profile: ${state.message}'));
          } else {
            return const Center(child: Text('Loading profile...'));
          }
        },
      ),
    );
  }

  Column _buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
