import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/story/domain/entities/story.dart';
import 'package:instagram_clone/features/story/domain/repositories/story_repository.dart';

class GetStories implements UseCase<List<Story>, GetStoriesParams> {
  final StoryRepository repository;

  GetStories(this.repository);

  @override
  Future<Either<Failure, List<Story>>> call(GetStoriesParams params) async {
    return await repository.getStories(params.currentUserId);
  }
}

class GetStoriesParams extends Equatable {
  final String currentUserId;

  const GetStoriesParams({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}
