// lib/features/profile/presentation/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/common_widgets/user_avatar.dart'; // Assuming UserAvatar is defined
import 'package:instagram_clone/features/profile/domain/entities/profile.dart'; // Assuming Profile entity is defined

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onEditProfile; // Callback for edit profile button
  final VoidCallback? onFollowToggle; // Callback for follow/unfollow button
  final bool isCurrentUser; // To determine if it's the current user's profile
  final bool isFollowing; // To determine if current user is following this profile

  const ProfileHeader({
    Key? key,
    required this.profile,
    this.onEditProfile,
    this.onFollowToggle,
    this.isCurrentUser = false,
    this.isFollowing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                imageUrl: profile.profilePictureUrl,
                radius: 40,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.username,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (profile.fullName != null && profile.fullName!.isNotEmpty)
                      Text(
                        profile.fullName!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (profile.bio != null && profile.bio!.isNotEmpty)
            Text(
              profile.bio!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 16),
          // Action buttons (Edit Profile or Follow/Unfollow)
          SizedBox(
            width: double.infinity,
            child: isCurrentUser
                ? OutlinedButton(
                    onPressed: onEditProfile,
                    child: const Text('Edit Profile'),
                  )
                : ElevatedButton(
                    onPressed: onFollowToggle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
                      foregroundColor: isFollowing ? Colors.black : Colors.white,
                    ),
                    child: Text(isFollowing ? 'Following' : 'Follow'),
                  ),
          ),
        ],
      ),
    );
  }
}
