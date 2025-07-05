// lib/features/feed/domain/repositories/feed_repository.dart

import 'package:dartz/dartz.dart'; // For Either (Left for Failure, Right for Success)
import '../../../../core/error/failures.dart'; // Assuming Failure definitions are here
import '../entities/feed_item.dart'; // Assuming FeedItem entity is defined

/// Abstract class defining the contract for the Feed Repository.
/// This interface is part of the Domain Layer and defines what the application needs
/// from the data layer, without knowing how the data is actually retrieved.
abstract class FeedRepository {
  /// Retrieves a list of feed items.
  ///
  /// Returns [Right] with a list of [FeedItem] on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, List<FeedItem>>> getFeed({int page = 0, int limit = 10});

  /// Refreshes the feed data.
  ///
  /// Returns [Right] with a list of [FeedItem] on success.
  /// Returns [Left] with a [Failure] on error.
  Future<Either<Failure, List<FeedItem>>> refreshFeed();
}
