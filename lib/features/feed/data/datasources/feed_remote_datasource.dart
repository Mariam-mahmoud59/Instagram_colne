// lib/features/feed/data/datasources/feed_remote_datasource.dart

import '../../domain/entities/feed_item.dart'; // Assuming FeedItem entity is defined

/// Abstract class defining the contract for remote data operations related to the feed.
abstract class FeedRemoteDataSource {
  /// Retrieves a list of feed items from the remote source.
  ///
  /// Throws a [ServerException] or [SupabaseException] on failure.
  Future<List<FeedItem>> getFeed({int page = 0, int limit = 10});

  /// Refreshes the feed data from the remote source.
  ///
  /// Throws a [ServerException] or [SupabaseException] on failure.
  Future<List<FeedItem>> refreshFeed();
}
