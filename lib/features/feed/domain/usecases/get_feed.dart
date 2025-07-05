// lib/features/feed/domain/usecases/get_feed.dart

import 'package:dartz/dartz.dart'; // For Either (Left for Failure, Right for Success)
import 'package:equatable/equatable.dart'; // For comparing parameters
import '../../../../core/error/failures.dart'; // Assuming Failure definitions are here
import '../../../../core/usecase/usecase.dart'; // Assuming UseCase base class is here
import '../entities/feed_item.dart'; // Assuming FeedItem entity is defined
import '../repositories/feed_repository.dart'; // Assuming FeedRepository is defined

/// Use case for retrieving a paginated list of feed items.
/// This use case orchestrates the retrieval of feed items for a specific page.
class GetFeed implements UseCase<List<FeedItem>, GetFeedParams> {
  final FeedRepository repository;

  GetFeed(this.repository);

  @override
  Future<Either<Failure, List<FeedItem>>> call(GetFeedParams params) async {
    return await repository.getFeed(page: params.page, limit: params.limit);
  }
}

/// Parameters for the [GetFeed] use case.
class GetFeedParams extends Equatable {
  final int page;
  final int limit;

  const GetFeedParams({
    this.page = 0, // Default to first page
    this.limit = 10, // Default limit per page
  });

  @override
  List<Object?> get props => [page, limit];

  @override
  bool get stringify => true;
}
