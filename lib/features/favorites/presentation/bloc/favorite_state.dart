part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoritesLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<Favorite> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class PostSaved extends FavoriteState {
  final Favorite favorite;

  const PostSaved({required this.favorite});

  @override
  List<Object?> get props => [favorite];
}

class PostUnsaved extends FavoriteState {
  final String favoriteId;

  const PostUnsaved({required this.favoriteId});

  @override
  List<Object?> get props => [favoriteId];
}

class PostSavedStatusChecked extends FavoriteState {
  final bool isSaved;

  const PostSavedStatusChecked({required this.isSaved});

  @override
  List<Object?> get props => [isSaved];
}

class FavoritesError extends FavoriteState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
