import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class Favorite extends Equatable {
  final String id;
  final String userId;
  final String postId;
  final Post? post;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.postId,
    this.post,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, postId, post, createdAt];
}
