import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class GetVideoExplorePosts
    implements UseCase<List<Post>, GetVideoExplorePostsParams> {
  final PostRepository repository;

  GetVideoExplorePosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(
      GetVideoExplorePostsParams params) async {
    return await repository.getVideoExplorePosts(
        limit: params.limit, offset: params.page * params.limit);
  }
}

class GetVideoExplorePostsParams extends NoParams {
  final int page;
  final int limit;

  GetVideoExplorePostsParams({this.page = 0, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}
