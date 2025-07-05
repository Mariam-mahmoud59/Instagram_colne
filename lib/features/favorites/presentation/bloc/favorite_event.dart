part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  final String userId;

  const LoadFavoritesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SavePostEvent extends FavoriteEvent {
  final String userId;
  final String postId;

  const SavePostEvent({
    required this.userId,
    required this.postId,
  });

  @override
  List<Object?> get props => [userId, postId];
}

class UnsavePostEvent extends FavoriteEvent {
  final String favoriteId;

  const UnsavePostEvent({required this.favoriteId});

  @override
  List<Object?> get props => [favoriteId];
}

class CheckPostSavedEvent extends FavoriteEvent {
  final String userId;
  final String postId;

  const CheckPostSavedEvent({
    required this.userId,
    required this.postId,
  });

  @override
  List<Object?> get props => [userId, postId];
}
