import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorites_repository.dart';

class SavePost implements UseCase<Favorite, SavePostParams> {
  final FavoriteRepository repository;

  SavePost(this.repository);

  @override
  Future<Either<Failure, Favorite>> call(SavePostParams params) async {
    return await repository.savePost(params.userId, params.postId);
  }
}

class SavePostParams extends NoParams {
  final String userId;
  final String postId;

  SavePostParams({
    required this.userId,
    required this.postId,
  });

  @override
  List<Object> get props => [userId, postId];
}
