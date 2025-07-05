import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
// import 'package:instagram_clone/core/network/network_info.dart'; // Optional
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:instagram_clone/features/explore/domain/repositories/explore_repository.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase; // For Supabase exceptions

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional

  ExploreRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  Future<Either<Failure, T>> _handleOperation<T>(
      Future<T> Function() operation) async {
    // Optional: Check network connectivity
    // if (!await networkInfo.isConnected) {
    //   return Left(NetworkFailure());
    // }
    try {
      final result = await operation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(message: 'Database Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getExplorePosts(
      {int limit = 21, int offset = 0}) async {
    return await _handleOperation<List<Post>>(
        () => remoteDataSource.getExplorePosts(limit: limit, offset: offset));
  }

  @override
  Future<Either<Failure, List<User>>> searchUsers(String query) async {
    return await _handleOperation<List<User>>(
        () => remoteDataSource.searchUsers(query));
  }
}
