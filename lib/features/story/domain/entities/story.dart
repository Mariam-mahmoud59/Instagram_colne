import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart'; // For author info

enum StoryMediaType { image, video }

class StoryItem extends Equatable {
  final String id;
  final String mediaUrl;
  final StoryMediaType mediaType;
  final DateTime createdAt;
  // Add other fields if needed, e.g., duration for video, interactive elements

  const StoryItem({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, mediaUrl, mediaType, createdAt];
}

// Represents a collection of stories from a single user
class Story extends Equatable {
  final String id;
  final String userId;
  final User? author; // Optional: Include author details
  final List<StoryItem> items;
  final DateTime lastUpdatedAt; // To know when the latest story was added
  final String? username;
  final String? userProfilePictureUrl;
  final String? userProfileImageUrl;
  final bool isViewed;
  final DateTime? timestamp;
  final String? mediaUrl;
  final String? mediaType;

  // Add other fields if needed, e.g., duration for video, interactive elements

  const Story({
    required this.id,
    required this.userId,
    this.author,
    required this.items,
    required this.lastUpdatedAt,
    this.username,
    this.userProfilePictureUrl,
    this.userProfileImageUrl,
    this.isViewed = false,
    this.timestamp,
    this.mediaUrl,
    this.mediaType,
  });

  // Alias for compatibility
  String? get profileImageUrl => userProfileImageUrl ?? userProfilePictureUrl;

  // Helper to check if all stories are viewed (needs view tracking logic)
  // bool get allViewed => ...

  @override
  List<Object?> get props => [
        id,
        userId,
        author,
        items,
        lastUpdatedAt,
        username,
        userProfilePictureUrl,
        userProfileImageUrl,
        isViewed,
        timestamp,
        mediaUrl,
        mediaType,
      ];
}
