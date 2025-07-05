import 'package:instagram_clone/features/auth/data/models/user_model.dart'; // Assuming UserModel exists
import 'package:instagram_clone/features/story/domain/entities/story.dart';

// Model for individual story items
class StoryItemModel extends StoryItem {
  const StoryItemModel({
    required super.id,
    required super.mediaUrl,
    required super.mediaType,
    required super.createdAt,
  });

  factory StoryItemModel.fromJson(Map<String, dynamic> json) {
    return StoryItemModel(
      id: json['id'] as String,
      mediaUrl: json['media_url'] as String,
      mediaType: StoryMediaType.values.firstWhere(
        (e) => e.name == json['media_type'],
        orElse: () => StoryMediaType.image, // Default or throw error
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_url': mediaUrl,
      'media_type': mediaType.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Model for the collection of stories from a user
class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.userId,
    super.author,
    required List<StoryItemModel> super.items,
    required super.lastUpdatedAt,
    super.username,
    super.userProfilePictureUrl,
    super.userProfileImageUrl,
    super.isViewed = false,
    super.timestamp,
    super.mediaUrl,
    super.mediaType,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      author: json['author'] != null ? UserModel.fromJson(json['author']) : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => StoryItemModel.fromJson(item))
          .toList() ?? [],
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      username: json['username'] as String?,
      userProfilePictureUrl: json['user_profile_picture_url'] as String?,
      userProfileImageUrl: json['user_profile_image_url'] as String?,
      isViewed: json['is_viewed'] as bool? ?? false,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'author': author != null ? (author as UserModel).toJson() : null,
      'items': items.map((item) => (item as StoryItemModel).toJson()).toList(),
      'last_updated_at': lastUpdatedAt.toIso8601String(),
      'username': username,
      'user_profile_picture_url': userProfilePictureUrl,
      'user_profile_image_url': userProfileImageUrl,
      'is_viewed': isViewed,
      'timestamp': timestamp?.toIso8601String(),
      'media_url': mediaUrl,
      'media_type': mediaType,
    };
  }
}

