import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class GetPost implements UseCase<Post, GetPostParams> {
  final PostRepository repository;

  GetPost(this.repository);

  @override
  Future<Either<Failure, Post>> call(GetPostParams params) async {
    return await repository.getPost(params.postId);
  }
}

class GetPostParams extends Equatable {
  final String postId;

  const GetPostParams({required this.postId});

  @override
  List<Object> get props => [postId];
}

