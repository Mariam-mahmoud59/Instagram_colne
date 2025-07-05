import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/favorites/domain/entities/favorite.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/get_favorites.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/is_post_saved.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/save_post.dart';
import 'package:instagram_clone/features/favorites/domain/usecases/unsave_post.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavorites getFavorites;
  final SavePost savePost;
  final UnsavePost unsavePost;
  final IsPostSaved isPostSaved;

  FavoriteBloc({
    required this.getFavorites,
    required this.savePost,
    required this.unsavePost,
    required this.isPostSaved,
  }) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<SavePostEvent>(_onSavePost);
    on<UnsavePostEvent>(_onUnsavePost);
    on<CheckPostSavedEvent>(_onCheckPostSaved);
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoritesLoading());
    final result = await getFavorites(GetFavoritesParams(userId: event.userId));
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> _onSavePost(
      SavePostEvent event, Emitter<FavoriteState> emit) async {
    final result = await savePost(SavePostParams(
      userId: event.userId,
      postId: event.postId,
    ));
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorite) => emit(PostSaved(favorite: favorite)),
    );
  }

  Future<void> _onUnsavePost(
      UnsavePostEvent event, Emitter<FavoriteState> emit) async {
    final result =
        await unsavePost(UnsavePostParams(favoriteId: event.favoriteId));
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (_) => emit(PostUnsaved(favoriteId: event.favoriteId)),
    );
  }

  Future<void> _onCheckPostSaved(
      CheckPostSavedEvent event, Emitter<FavoriteState> emit) async {
    final result = await isPostSaved(IsPostSavedParams(
      userId: event.userId,
      postId: event.postId,
    ));
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (isSaved) => emit(PostSavedStatusChecked(isSaved: isSaved)),
    );
  }
}
