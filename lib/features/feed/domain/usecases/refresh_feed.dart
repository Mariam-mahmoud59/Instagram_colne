// lib/features/feed/domain/usecases/refresh_feed.dart

import 'package:dartz/dartz.dart'; // For Either (Left for Failure, Right for Success)
import '../../../../core/error/failures.dart'; // Assuming Failure definitions are here
import '../../../../core/usecase/usecase.dart'; // Assuming UseCase base class is here
import '../entities/feed_item.dart'; // Assuming FeedItem entity is defined
import '../repositories/feed_repository.dart'; // Assuming FeedRepository is defined

/// Use case for refreshing the user's feed.
/// This use case orchestrates the retrieval of the latest feed items.
class RefreshFeed implements UseCase<List<FeedItem>, NoParams> {
  final FeedRepository repository;

  RefreshFeed(this.repository);

  @override
  Future<Either<Failure, List<FeedItem>>> call(NoParams params) async {
    return await repository.refreshFeed();
  }
}
