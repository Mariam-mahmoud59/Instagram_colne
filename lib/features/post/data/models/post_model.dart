import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    super.user,
    required super.type,
    required super.mediaUrls,
    super.description,
    super.caption,
    required super.createdAt,
    super.likeCount,
    super.commentCount,
    super.likesCount,
    super.commentsCount,
    super.isLikedByCurrentUser,
    super.mediaUrl,
    super.mediaType,
  });

  factory PostModel.fromJson(Map<String, dynamic> json,
      {required String userId}) {
    // Helper to safely parse int counts, defaulting to 0
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Handle nested counts and author data
    final likeData = json['likes'] as List?;
    final commentData = json['comments'] as List?;
    final authorData = json['author'] as Map<String, dynamic>?;
    final likedByUserList = json['liked_by_user'] as List?;

    final likeCount = (likeData != null && likeData.isNotEmpty)
        ? parseInt(likeData.first?['count'])
        : 0;
    final commentCount = (commentData != null && commentData.isNotEmpty)
        ? parseInt(commentData.first?['count'])
        : 0;
    final isLiked = (likedByUserList != null && likedByUserList.isNotEmpty)
        ? (likedByUserList.first?['count'] ?? 0) > 0
        : false;

    // Create author User entity
    final user = authorData != null
        ? UserModel(
            id: json['author_id'] as String,
            email: authorData['email'] as String? ?? '',
            username: authorData['username'] as String?,
            profilePictureUrl: authorData['profile_image_url'] as String?,
          )
        : null;

    // Parse media URLs
    List<String> mediaUrls = [];
    if (json['media_urls'] is List) {
      mediaUrls = List<String>.from(json['media_urls']);
    } else if (json['media_urls'] is String) {
      mediaUrls = [json['media_urls'] as String];
    }

    return PostModel(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      user: user,
      type: PostType.values.firstWhere((e) => e.name == json['type'],
          orElse: () => PostType.image),
      mediaUrls: mediaUrls,
      description: json['description'] as String?,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      likeCount: likeCount,
      commentCount: commentCount,
      likesCount: likeCount,
      commentsCount: commentCount,
      isLikedByCurrentUser: isLiked,
      mediaUrl: mediaUrls.isNotEmpty ? mediaUrls.first : null,
      mediaType: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'type': type.name,
      'media_urls': mediaUrls,
      'description': description,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
