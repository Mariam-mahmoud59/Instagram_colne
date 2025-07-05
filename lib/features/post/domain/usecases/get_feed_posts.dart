import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class GetFeedPosts implements UseCase<List<Post>, GetFeedPostsParams> {
  final PostRepository repository;

  GetFeedPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetFeedPostsParams params) async {
    // You might add pagination parameters here later
    return await repository.getFeedPosts(params.currentUserId);
  }
}

class GetFeedPostsParams extends Equatable {
  final String currentUserId; // Needed to determine if posts are liked by the current user

  const GetFeedPostsParams({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

