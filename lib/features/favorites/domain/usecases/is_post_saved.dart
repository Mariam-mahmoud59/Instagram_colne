import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/favorites/domain/repositories/favorites_repository.dart';

class IsPostSaved implements UseCase<bool, IsPostSavedParams> {
  final FavoriteRepository repository;

  IsPostSaved(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsPostSavedParams params) async {
    return await repository.isPostSaved(params.userId, params.postId);
  }
}

class IsPostSavedParams extends NoParams {
  final String userId;
  final String postId;

  IsPostSavedParams({
    required this.userId,
    required this.postId,
  });

  @override
  List<Object> get props => [userId, postId];
}
