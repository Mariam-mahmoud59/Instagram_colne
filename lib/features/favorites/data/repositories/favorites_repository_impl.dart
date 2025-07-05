import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites(String userId) async {
    try {
      final favorites = await remoteDataSource.getFavorites(userId);
      return Right(favorites);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPostSaved(String userId, String postId) async {
    try {
      final isSaved = await remoteDataSource.isPostSaved(userId, postId);
      return Right(isSaved);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Favorite>> savePost(String userId, String postId) async {
    try {
      final favorite = await remoteDataSource.savePost(userId, postId);
      return Right(favorite);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsavePost(String favoriteId) async {
    try {
      await remoteDataSource.unsavePost(favoriteId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
