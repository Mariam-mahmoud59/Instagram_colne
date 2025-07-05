import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/explore/domain/repositories/explore_repository.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class GetExplorePosts implements UseCase<List<Post>, GetExplorePostsParams> {
  final ExploreRepository repository;

  GetExplorePosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetExplorePostsParams params) async {
    return await repository.getExplorePosts(limit: params.limit, offset: params.offset);
  }
}

class GetExplorePostsParams extends Equatable {
  final int limit;
  final int offset;

  const GetExplorePostsParams({this.limit = 21, this.offset = 0});

  @override
  List<Object> get props => [limit, offset];
}

