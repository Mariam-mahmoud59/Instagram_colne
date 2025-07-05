import 'dart:io';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/story/data/datasources/story_remote_datasource.dart';
import 'package:instagram_clone/features/story/data/models/story_model.dart';
import 'package:instagram_clone/features/story/domain/entities/story.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String storiesTable = 'stories'; // Table for story items
  static const String profilesTable = 'profiles'; // For author info
  static const String followsTable = 'follows'; // To get followed users
  static const String storyMediaBucket = 'story-media'; // Storage bucket

  StoryRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> uploadStoryMedia(
      File file, String userId, StoryMediaType type) async {
    try {
      final fileExtension = p.extension(file.path).substring(1);
      final fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      await supabaseClient.storage.from(storyMediaBucket).upload(
            fileName,
            file,
            fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: false,
                contentType: type == StoryMediaType.image
                    ? 'image/$fileExtension'
                    : 'video/$fileExtension'),
          );

      final publicUrl =
          supabaseClient.storage.from(storyMediaBucket).getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      print('Supabase storage error uploading story media: ${e.message}');
      throw ServerException(
          message: 'Failed to upload story media: ${e.message}');
    } catch (e) {
      print('Unexpected error uploading story media: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred during story media upload.');
    }
  }

  @override
  Future<void> createStoryItem({
    required String userId,
    required File mediaFile,
    required StoryMediaType mediaType,
  }) async {
    try {
      // 1. Upload media
      final mediaUrl = await uploadStoryMedia(mediaFile, userId, mediaType);

      // 2. Insert story item record
      final storyData = {
        'user_id': userId,
        'media_url': mediaUrl,
        'media_type': mediaType.name, // Store enum name as string
        // 'expires_at' can be set by default in Supabase (e.g., now() + interval '24 hours')
      };

      await supabaseClient.from(storiesTable).insert(storyData);
    } on PostgrestException catch (e) {
      print('Supabase error creating story item: ${e.message}');
      throw ServerException(
          message: 'Failed to create story item: ${e.message}');
    } on ServerException catch (e) {
      // Catch exception from uploadStoryMedia
      throw ServerException(message: e.message);
    } catch (e) {
      print('Unexpected error creating story item: ${e.toString()}');
      throw ServerException(
          message:
              'An unexpected error occurred while creating the story item.');
    }
  }

  @override
  Future<List<StoryModel>> getStories(String currentUserId) async {
    try {
      // 1. Get IDs of users the current user follows
      final followingResponse = await supabaseClient
          .from(followsTable)
          .select('following_id')
          .eq('follower_id', currentUserId);

      final followingIds = (followingResponse as List)
          .map((row) => row['following_id'] as String)
          .toList();

      // Include the current user's own stories
      final userIdsToFetch = [...followingIds, currentUserId];

      if (userIdsToFetch.isEmpty) return [];

      // 2. Fetch recent (e.g., last 24 hours) story items for these users, along with author info
      // Assuming 'expires_at' column exists and is set correctly
      final twentyFourHoursAgo =
          DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();

      final response = await supabaseClient
          .from(storiesTable)
          .select('''
            id,
            user_id,
            media_url,
            media_type,
            created_at,
            author:profiles!user_id(username, profile_image_url)
          ''')
          .inFilter('user_id', userIdsToFetch)
          .gte('created_at',
              twentyFourHoursAgo) // Fetch stories from the last 24 hours
          .order('user_id') // Group by user implicitly by ordering
          .order('created_at',
              ascending: true); // Order items within each user's stories

      // 3. Group story items by user ID
      final Map<String, List<StoryItemModel>> userStoriesMap = {};
      final Map<String, UserModel> authorMap = {}; // Store author info

      for (var itemJson in (response as List)) {
        final item = StoryItemModel.fromJson(itemJson);
        final userId = itemJson['user_id'] as String;

        // Store author info if not already stored
        if (!authorMap.containsKey(userId) && itemJson['author'] != null) {
          final authorJson = itemJson['author'] as Map<String, dynamic>;
          // Assuming UserModel exists and can be created from this data
          authorMap[userId] = UserModel(
            id: userId,
            email: '', // Email might not be available here
            username: authorJson['username'] as String?,
            profilePictureUrl: authorJson['profile_image_url'] as String?,
          );
        }

        if (userStoriesMap.containsKey(userId)) {
          userStoriesMap[userId]!.add(item);
        } else {
          userStoriesMap[userId] = [item];
        }
      }

      // 4. Convert map to List<StoryModel>
      final List<StoryModel> stories = userStoriesMap.entries.map((entry) {
        final userId = entry.key;
        final items = entry.value;
        // Sort items just in case DB order wasn't perfect (should be though)
        items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        final lastUpdate = items.isNotEmpty
            ? items.last.createdAt
            : DateTime.now(); // Use last item's time

        return StoryModel(
          id: userId, // Use userId as id for now
          userId: userId,
          author: authorMap[userId], // Get stored author info
          items: items,
          lastUpdatedAt: lastUpdate,
        );
      }).toList();

      // Optional: Sort the final list of stories (e.g., put current user first, then by latest update)
      stories.sort((a, b) {
        if (a.userId == currentUserId) return -1;
        if (b.userId == currentUserId) return 1;
        return b.lastUpdatedAt
            .compareTo(a.lastUpdatedAt); // Show most recently updated first
      });

      return stories;
    } on PostgrestException catch (e) {
      print('Supabase error getting stories: ${e.message}');
      throw ServerException(message: 'Failed to get stories: ${e.message}');
    } catch (e) {
      print('Unexpected error getting stories: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while fetching stories.');
    }
  }
}
