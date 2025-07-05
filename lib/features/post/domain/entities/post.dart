import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // For author info

enum PostType { image, video }

class Post extends Equatable {
  final String id;
  final String authorId;
  final User? user; // Changed from author to user to match code expectations
  final PostType type;
  final List<String>
      mediaUrls; // List of URLs for images or single URL for video
  final String? description;
  final String? caption; // Added caption field
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final int likesCount; // Added to match code expectations
  final int commentsCount; // Added to match code expectations
  final bool isLikedByCurrentUser; // Specific to the viewing user
  final String? mediaUrl; // Single media URL for convenience
  final String? mediaType; // Media type string

  // Add other fields as needed: location, tags, etc.

  const Post({
    required this.id,
    required this.authorId,
    this.user,
    required this.type,
    required this.mediaUrls,
    this.description,
    this.caption,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByCurrentUser = false,
    this.mediaUrl,
    this.mediaType,
  });

  // Alias for compatibility
  User? get author => user;

  @override
  List<Object?> get props => [
        id,
        authorId,
        user,
        type,
        mediaUrls,
        description,
        caption,
        createdAt,
        likeCount,
        commentCount,
        likesCount,
        commentsCount,
        isLikedByCurrentUser,
        mediaUrl,
        mediaType,
      ];
}
