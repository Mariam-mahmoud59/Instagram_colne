import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/follow_user.dart';
import '../../domain/usecases/unfollow_user.dart';
import '../../domain/usecases/check_follow_status.dart';
import '../../domain/usecases/get_followers.dart';
import '../../domain/usecases/get_following.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowUser followUser;
  final UnfollowUser unfollowUser;
  final CheckFollowStatus checkFollowStatus;
  final GetFollowers getFollowers;
  final GetFollowing getFollowing;

  FollowBloc({
    required this.followUser,
    required this.unfollowUser,
    required this.checkFollowStatus,
    required this.getFollowers,
    required this.getFollowing,
  }) : super(FollowInitial()) {
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<CheckFollowStatusEvent>(_onCheckFollowStatus);
    on<LoadFollowersEvent>(_onLoadFollowers);
    on<LoadFollowingEvent>(_onLoadFollowing);
  }

  Future<void> _onFollowUser(
      FollowUserEvent event, Emitter<FollowState> emit) async {
    try {
      await followUser(
          followerId: event.currentUserId, followingId: event.targetUserId);
      emit(FollowSuccess(event.targetUserId));
    } catch (e) {
      emit(FollowOperationFailure(event.targetUserId, e.toString()));
    }
  }

  Future<void> _onUnfollowUser(
      UnfollowUserEvent event, Emitter<FollowState> emit) async {
    try {
      await unfollowUser(
          followerId: event.currentUserId, followingId: event.targetUserId);
      emit(UnfollowSuccess(event.targetUserId));
    } catch (e) {
      emit(FollowOperationFailure(event.targetUserId, e.toString()));
    }
  }

  Future<void> _onCheckFollowStatus(
      CheckFollowStatusEvent event, Emitter<FollowState> emit) async {
    emit(FollowStatusLoading(event.targetUserId));
    try {
      final isFollowing = await checkFollowStatus(
          currentUserId: event.currentUserId, targetUserId: event.targetUserId);
      emit(FollowStatusChecked(event.targetUserId, isFollowing));
    } catch (e) {
      emit(FollowStatusCheckFailure(event.targetUserId, e.toString()));
    }
  }

  Future<void> _onLoadFollowers(
      LoadFollowersEvent event, Emitter<FollowState> emit) async {
    emit(FollowListLoading());
    try {
      final followers = await getFollowers(event.userId);
      emit(FollowersLoaded(followers));
    } catch (e) {
      emit(FollowListLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadFollowing(
      LoadFollowingEvent event, Emitter<FollowState> emit) async {
    emit(FollowListLoading());
    try {
      final following = await getFollowing(event.userId);
      emit(FollowingLoaded(following));
    } catch (e) {
      emit(FollowListLoadFailure(e.toString()));
    }
  }
}
