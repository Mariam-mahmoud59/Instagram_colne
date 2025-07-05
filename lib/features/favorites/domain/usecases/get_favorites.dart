import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavorites implements UseCase<List<Favorite>, GetFavoritesParams> {
  final FavoriteRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<Favorite>>> call(
      GetFavoritesParams params) async {
    return await repository.getFavorites(params.userId);
  }
}

class GetFavoritesParams extends NoParams {
  final String userId;

  GetFavoritesParams({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}
