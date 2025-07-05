import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class LikePost implements UseCase<void, LikePostParams> {
  final PostRepository repository;

  LikePost(this.repository);

  @override
  Future<Either<Failure, void>> call(LikePostParams params) async {
    return await repository.likePost(params.postId, params.userId);
  }
}

class LikePostParams extends Equatable {
  final String postId;
  final String userId; // ID of the user liking the post

  const LikePostParams({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

