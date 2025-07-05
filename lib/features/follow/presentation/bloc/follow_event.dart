part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

// Event to follow a user
class FollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const FollowUserEvent({required this.currentUserId, required this.targetUserId});

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

// Event to unfollow a user
class UnfollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const UnfollowUserEvent({required this.currentUserId, required this.targetUserId});

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

// Event to load the list of followers for a user
class LoadFollowersEvent extends FollowEvent {
  final String userId;

  const LoadFollowersEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Event to load the list of users someone is following
class LoadFollowingEvent extends FollowEvent {
  final String userId;

  const LoadFollowingEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Event to check if the current user follows a target user
class CheckFollowStatusEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const CheckFollowStatusEvent({required this.currentUserId, required this.targetUserId});

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

