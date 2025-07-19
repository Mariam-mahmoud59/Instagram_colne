// lib/features/feed/data/datasources/feed_remote_datasource_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/feed_item.dart';
import '../models/feed_item_model.dart'; // Assuming FeedItemModel is defined
import 'feed_remote_datasource.dart';

/// Implementation of [FeedRemoteDataSource] that interacts with Supabase.
class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final SupabaseClient supabaseClient;

  FeedRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<FeedItem>> getFeed({int page = 0, int limit = 10}) async {
    try {
      final int offset = page * limit;
      final response = await supabaseClient
          .from('posts') // Assuming 'posts' table contains feed items
          .select('''
            *,
            profiles(username, profile_image_url as profile_picture_url),
            likes(id),
            comments(id)
          ''') // Select post details, profile info, and count likes/comments
          .order('created_at', ascending: false) // Order by newest first
          .range(offset, offset + limit - 1)
          .limit(limit);

      final List<FeedItem> feedItems = (response as List)
          .map((json) => FeedItemModel.fromJson(json))
          .toList();

      return feedItems;
    } on PostgrestException catch (e) {
      throw SupabaseException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<FeedItem>> refreshFeed() async {
    // For refresh, we typically fetch the latest items,
    // often the first page or a slightly larger set to catch new content.
    // This example reuses getFeed for simplicity, fetching the first page.
    return await getFeed(page: 0, limit: 20); // Fetch more items on refresh
  }
}
