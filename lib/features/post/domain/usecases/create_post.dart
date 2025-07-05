import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class CreatePost implements UseCase<Post, CreatePostParams> {
  final PostRepository repository;

  CreatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) async {
    return await repository.createPost(
      authorId: params.authorId,
      type: params.type,
      mediaFiles: params.mediaFiles,
      description: params.description,
    );
  }
}

class CreatePostParams extends Equatable {
  final String authorId;
  final PostType type;
  final List<File> mediaFiles; // List of images or single video file
  final String? description;

  const CreatePostParams({
    required this.authorId,
    required this.type,
    required this.mediaFiles,
    this.description,
  });

  @override
  List<Object?> get props => [authorId, type, mediaFiles, description];
}

