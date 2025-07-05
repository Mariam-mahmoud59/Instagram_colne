import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class UnlikePost implements UseCase<void, UnlikePostParams> {
  final PostRepository repository;

  UnlikePost(this.repository);

  @override
  Future<Either<Failure, void>> call(UnlikePostParams params) async {
    return await repository.unlikePost(params.postId, params.userId);
  }
}

class UnlikePostParams extends Equatable {
  final String postId;
  final String userId; // ID of the user unliking the post

  const UnlikePostParams({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

