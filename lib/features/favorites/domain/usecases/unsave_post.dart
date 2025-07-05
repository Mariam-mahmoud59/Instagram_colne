import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';

class UnsavePost implements UseCase<void, UnsavePostParams> {
  final FavoriteRepository repository;

  UnsavePost(this.repository);

  @override
  Future<Either<Failure, void>> call(UnsavePostParams params) async {
    return await repository.unsavePost(params.favoriteId);
  }
}

class UnsavePostParams extends NoParams {
  final String favoriteId;

  UnsavePostParams({required this.favoriteId});

  @override
  List<Object> get props => [favoriteId];
}
