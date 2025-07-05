// lib/features/feed/data/models/feed_item_model.dart

import '../../domain/entities/feed_item.dart'; // Assuming FeedItem entity is defined
import '../../../auth/data/models/user_model.dart'; // Assuming UserModel is defined
import '../../../auth/domain/entities/user.dart';

/// Represents a feed item data model, used for data transfer objects.
/// Extends the [FeedItem] entity from the domain layer.
class FeedItemModel extends FeedItem {
  const FeedItemModel({
    required String id,
    required String userId,
    required String mediaUrl,
    required String mediaType,
    String? caption,
    required DateTime createdAt,
    required int likesCount,
    required int commentsCount,
    required UserModel user, // Use UserModel for the user details
  }) : super(
          id: id,
          userId: userId,
          mediaUrl: mediaUrl,
          mediaType: mediaType,
          caption: caption,
          createdAt: createdAt,
          likesCount: likesCount,
          commentsCount: commentsCount,
          user: user,
        );

  /// Factory constructor to create a [FeedItemModel] from a JSON map (e.g., from Supabase).
  factory FeedItemModel.fromJson(Map<String, dynamic> json) {
    return FeedItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaUrl: json['media_url'] as String,
      mediaType: json['media_type'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      likesCount: (json['likes'] as List?)?.length ??
          0, // Count likes from joined table
      commentsCount: (json['comments'] as List?)?.length ??
          0, // Count comments from joined table
      user: UserModel.fromJson(json['profiles'] as Map<String,
          dynamic>), // Assuming 'profiles' is the joined user data
    );
  }

  /// Converts this [FeedItemModel] instance to a JSON map (e.g., for sending to Supabase).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
      // likesCount and commentsCount are derived, not directly stored
      // user is handled by its own toJson if needed for updates
    };
  }

  /// Creates a copy of this [FeedItemModel] with updated values.
  FeedItemModel copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    String? mediaType,
    String? caption,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    User? user,
  }) {
    return FeedItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      user: (user ?? this.user) as UserModel,
    );
  }
}
