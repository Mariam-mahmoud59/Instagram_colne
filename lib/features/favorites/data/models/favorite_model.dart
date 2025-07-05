import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required String id,
    required String userId,
    required String postId,
    required DateTime createdAt,
    Post? post,
  }) : super(
          id: id,
          userId: userId,
          postId: postId,
          createdAt: createdAt,
          post: post,
        );

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      postId: json['post_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      post: json['post'] != null
          ? PostModel.fromJson(json['post'], userId: json['user_id'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
