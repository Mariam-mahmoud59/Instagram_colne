import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id; // Corresponds to the auth user ID
  final String username;
  final String? fullName;
  final String? bio;
  final String? profileImageUrl;
  final String? profilePictureUrl;
  final int followerCount;
  final int followingCount;
  final int postCount;

  const Profile({
    required this.id,
    required this.username,
    this.fullName,
    this.bio,
    this.profileImageUrl,
    this.profilePictureUrl,
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
  });

  // Helper method to create an empty profile, useful for initial states
  factory Profile.empty() {
    return const Profile(
      id: '',
      username: '',
      fullName: null,
      bio: null,
      profileImageUrl: null,
      profilePictureUrl: null,
      followerCount: 0,
      followingCount: 0,
      postCount: 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        fullName,
        bio,
        profileImageUrl,
        profilePictureUrl,
        followerCount,
        followingCount,
        postCount,
      ];
}

