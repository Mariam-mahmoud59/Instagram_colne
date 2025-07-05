import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class GetUserPosts implements UseCase<List<Post>, GetUserPostsParams> {
  final PostRepository repository;

  GetUserPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetUserPostsParams params) async {
    return await repository.getUserPosts(params.userId);
  }
}

class GetUserPostsParams extends Equatable {
  final String userId;

  const GetUserPostsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}

