import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? name;
  final String? profilePictureUrl;
  final String? bio;
  final int? followersCount;
  final int? followingCount;
  final int? postsCount;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.name,
    this.profilePictureUrl,
    this.bio,
    this.followersCount,
    this.followingCount,
    this.postsCount,
  });

  // Alias for compatibility
  String? get profileImageUrl => profilePictureUrl;

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        name,
        profilePictureUrl,
        bio,
        followersCount,
        followingCount,
        postsCount,
      ];
}
