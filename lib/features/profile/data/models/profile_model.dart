import 'package:instagram_clone/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.username,
    super.fullName,
    super.bio,
    super.profileImageUrl,
    super.followerCount,
    super.followingCount,
    super.postCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse int counts, defaulting to 0
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Handle nested counts which might come in lists from Supabase joins
    final followerData = json['followers'] as List?;
    final followingData = json['following'] as List?;
    final postData = json['posts'] as List?;

    final followerCount = (followerData != null && followerData.isNotEmpty) 
                          ? parseInt(followerData.first?['count']) 
                          : 0;
    final followingCount = (followingData != null && followingData.isNotEmpty) 
                           ? parseInt(followingData.first?['count']) 
                           : 0;
    final postCount = (postData != null && postData.isNotEmpty) 
                      ? parseInt(postData.first?['count']) 
                      : 0;

    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      followerCount: followerCount,
      followingCount: followingCount,
      postCount: postCount,
    );
  }

  Map<String, dynamic> toJson() {
    // Note: Counts are typically read-only and derived, not directly written back.
    // This toJson might be used if caching the model locally.
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      // We don't usually write counts back, but include if needed for local cache
      // 'follower_count': followerCount, 
      // 'following_count': followingCount,
      // 'post_count': postCount,
    };
  }

  // Optional: Method to convert Model to Entity (useful if they diverge significantly)
  // Profile toEntity() {
  //   return Profile(
  //     id: id,
  //     username: username,
  //     fullName: fullName,
  //     bio: bio,
  //     profileImageUrl: profileImageUrl,
  //     followerCount: followerCount,
  //     followingCount: followingCount,
  //     postCount: postCount,
  //   );
  // }
}

