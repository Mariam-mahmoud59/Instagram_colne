import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// For NoParams if needed
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/usecases/create_post.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_feed_posts.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_user_posts.dart';
import 'package:instagram_clone/features/post/domain/usecases/like_post.dart';
import 'package:instagram_clone/features/post/domain/usecases/unlike_post.dart';
import 'package:collection/collection.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_post.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_video_explore_posts.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePost createPost;
  final GetFeedPosts getFeedPosts;
  final GetUserPosts getUserPosts;
  final LikePost likePost;
  final UnlikePost unlikePost;
  final GetPost getPost;
  final GetVideoExplorePosts getVideoExplorePosts;

  PostBloc({
    required this.createPost,
    required this.getFeedPosts,
    required this.getUserPosts,
    required this.likePost,
    required this.unlikePost,
    required this.getPost,
    required this.getVideoExplorePosts,
  }) : super(PostInitial()) {
    on<CreateNewPost>(_onCreateNewPost);
    on<LoadFeedPosts>(_onLoadFeedPosts);
    on<LoadUserPosts>(_onLoadUserPosts);
    on<LikePostEvent>(_onLikePost);
    on<UnlikePostEvent>(_onUnlikePost);
    on<LoadPostDetail>(_onLoadPostDetail);
    on<LoadVideoExplorePosts>(_onLoadVideoExplorePosts);
  }

  Future<void> _onCreateNewPost(
      CreateNewPost event, Emitter<PostState> emit) async {
    emit(PostUploading());
    final result = await createPost(CreatePostParams(
      authorId: event.authorId,
      type: event.type,
      mediaFiles: event.mediaFiles,
      description: event.description,
    ));
    result.fold(
      (failure) =>
          emit(PostOperationFailure(failure.toString())), // Use failure.message
      (post) =>
          emit(PostUploadSuccess(post)), // Emit success state with the new post
    );
    // Consider reloading feed or user posts after successful creation?
  }

  Future<void> _onLoadFeedPosts(
      LoadFeedPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());
    final result = await getFeedPosts(
        GetFeedPostsParams(currentUserId: event.currentUserId));
    result.fold(
      (failure) =>
          emit(PostsLoadFailure(failure.toString())), // Use failure.message
      (posts) => emit(PostsLoaded(posts)),
    );
  }

  Future<void> _onLoadUserPosts(
      LoadUserPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());
    final result = await getUserPosts(GetUserPostsParams(userId: event.userId));
    result.fold(
      (failure) =>
          emit(PostsLoadFailure(failure.toString())), // Use failure.message
      (posts) => emit(PostsLoaded(posts)), // Reuse PostsLoaded state
    );
  }

  Future<void> _onLikePost(LikePostEvent event, Emitter<PostState> emit) async {
    // Optimistic UI update: Update state immediately, then call use case
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return Post(
            id: post.id,
            authorId: post.authorId,
            user: post.user,
            type: post.type,
            mediaUrls: post.mediaUrls,
            description: post.description,
            caption: post.caption,
            createdAt: post.createdAt,
            likeCount: post.likeCount + 1,
            commentCount: post.commentCount,
            likesCount: post.likesCount + 1,
            commentsCount: post.commentsCount,
            isLikedByCurrentUser: true,
            mediaUrl: post.mediaUrl,
            mediaType: post.mediaType,
          );
        }
        return post;
      }).toList();
      emit(PostsLoaded(updatedPosts));
    }

    final result = await likePost(
        LikePostParams(postId: event.postId, userId: event.userId));
    result.fold(
      (failure) {
        print('Failed to like post: ${failure.toString()}');
      },
      (_) => print('Post liked successfully'),
    );
  }

  Future<void> _onUnlikePost(
      UnlikePostEvent event, Emitter<PostState> emit) async {
    // Optimistic UI update
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return Post(
            id: post.id,
            authorId: post.authorId,
            user: post.user,
            type: post.type,
            mediaUrls: post.mediaUrls,
            description: post.description,
            caption: post.caption,
            createdAt: post.createdAt,
            likeCount: post.likeCount - 1,
            commentCount: post.commentCount,
            likesCount: post.likesCount - 1,
            commentsCount: post.commentsCount,
            isLikedByCurrentUser: false,
            mediaUrl: post.mediaUrl,
            mediaType: post.mediaType,
          );
        }
        return post;
      }).toList();
      emit(PostsLoaded(updatedPosts));
    }

    final result = await unlikePost(
        UnlikePostParams(postId: event.postId, userId: event.userId));
    result.fold(
      (failure) {
        print('Failed to unlike post: ${failure.toString()}');
      },
      (_) => print('Post unliked successfully'),
    );
  }

  Future<void> _onLoadPostDetail(
      LoadPostDetail event, Emitter<PostState> emit) async {
    // ابحث عن المنشور في الحالة الحالية إذا كان موجودًا
    if (state is PostsLoaded) {
      final posts = (state as PostsLoaded).posts;
      final post = posts.firstWhereOrNull((p) => p.id == event.postId);
      if (post != null) {
        emit(PostDetailLoaded(post));
        return;
      }
    }
    // إذا لم يكن موجودًا، يمكنك استدعاء usecase منفصل إذا توفر، أو أظهر رسالة خطأ
    emit(PostDetailFailure('Post not found.'));
  }

  Future<void> _onLoadVideoExplorePosts(
      LoadVideoExplorePosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());
    final result = await getVideoExplorePosts(GetVideoExplorePostsParams(
        limit: event.limit, page: event.offset ~/ event.limit));
    result.fold(
      (failure) => emit(PostsLoadFailure(failure.toString())),
      (posts) => emit(VideoExplorePostsLoaded(posts)),
    );
  }
}
