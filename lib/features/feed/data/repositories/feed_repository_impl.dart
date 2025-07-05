// lib/features/feed/data/repositories/feed_repository_impl.dart

import 'package:dartz/dartz.dart'; // For Either (Left for Failure, Right for Success)
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/feed_item.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

/// Implementation of [FeedRepository] that uses a remote data source.
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FeedItem>>> getFeed({int page = 0, int limit = 10}) async {
    try {
      final result = await remoteDataSource.getFeed(page: page, limit: limit);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SupabaseException catch (e) {
      return Left(SupabaseFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> refreshFeed() async {
    try {
      final result = await remoteDataSource.refreshFeed();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SupabaseException catch (e) {
      return Left(SupabaseFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
