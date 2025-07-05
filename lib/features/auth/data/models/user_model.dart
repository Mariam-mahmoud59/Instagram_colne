

import '../../domain/entities/user.dart';

/// Represents a user data model, used for data transfer objects.
/// Extends the [User] entity from the domain layer.
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    String? username,
    String? profilePictureUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) : super(
          id: id,
          email: email,
          username: username,
          profilePictureUrl: profilePictureUrl,
          bio: bio,
          followersCount: followersCount,
          followingCount: followingCount,
          postsCount: postsCount,
        );

  /// Factory constructor to create a [UserModel] from a JSON map (e.g., from Supabase).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      bio: json['bio'] as String?,
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      postsCount: json['posts_count'] as int?,
    );
  }

  /// Converts this [UserModel] instance to a JSON map (e.g., for sending to Supabase).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile_picture_url': profilePictureUrl,
      'bio': bio,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
    };
  }

  /// Creates a [UserModel] from a Supabase [User] object.
  /// This is useful when you get the user directly from `supabaseClient.auth.currentUser`.
  factory UserModel.fromSupabaseUser(
      {required String id, String? email, Map<String, dynamic>? userMetadata}) {
    return UserModel(
      id: id,
      email: email ?? '', // Email might be null in some cases, provide default
      username: userMetadata?['username'] as String?,
      profilePictureUrl: userMetadata?['profile_picture_url'] as String?,
      // Other fields might need to be fetched from a separate 'profiles' table
    );
  }

  /// Creates a copy of this [UserModel] with updated values.
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePictureUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
    );
  }
}
