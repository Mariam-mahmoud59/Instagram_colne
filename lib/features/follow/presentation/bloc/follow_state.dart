part of 'follow_bloc.dart';

abstract class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

// Initial state
class FollowInitial extends FollowState {}

// State when checking follow status
class FollowStatusLoading extends FollowState {
  final String targetUserId;
  const FollowStatusLoading(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

// State after checking follow status
class FollowStatusChecked extends FollowState {
  final String targetUserId;
  final bool isFollowing;

  const FollowStatusChecked(this.targetUserId, this.isFollowing);

  @override
  List<Object> get props => [targetUserId, isFollowing];
}

// State when follow/unfollow operation is successful
class FollowSuccess extends FollowState {
  final String targetUserId;
  const FollowSuccess(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

class UnfollowSuccess extends FollowState {
  final String targetUserId;
  const UnfollowSuccess(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

// State when follow/unfollow/check operation fails
class FollowOperationFailure extends FollowState {
  final String targetUserId;
  final String _message;

  const FollowOperationFailure(this.targetUserId, this._message);

  String get message => _message;

  @override
  List<Object> get props => [targetUserId, _message];
}

class FollowStatusCheckFailure extends FollowState {
  final String targetUserId;
  final String _message;

  const FollowStatusCheckFailure(this.targetUserId, this._message);

  String get message => _message;

  @override
  List<Object> get props => [targetUserId, _message];
}

// State when loading follower/following lists
class FollowListLoading extends FollowState {}

// State when followers list is loaded
class FollowersLoaded extends FollowState {
  final List<User> followers;

  const FollowersLoaded(this.followers);

  @override
  List<Object> get props => [followers];
}

// State when following list is loaded
class FollowingLoaded extends FollowState {
  final List<User> following;

  const FollowingLoaded(this.following);

  @override
  List<Object> get props => [following];
}

// State when loading follower/following lists fails
class FollowListLoadFailure extends FollowState {
  final String message;

  const FollowListLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
