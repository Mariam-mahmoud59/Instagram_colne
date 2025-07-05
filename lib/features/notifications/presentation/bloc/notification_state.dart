part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;
  
  const NotificationsLoaded({required this.notifications});
  
  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  
  const NotificationError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class NotificationActionSuccess extends NotificationState {
  final String message;
  
  const NotificationActionSuccess({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class NotificationCreated extends NotificationState {
  final Notification notification;
  
  const NotificationCreated({required this.notification});
  
  @override
  List<Object?> get props => [notification];
}

class NotificationSubscribed extends NotificationState {
  final Stream<Notification> notificationStream;
  
  const NotificationSubscribed({required this.notificationStream});
  
  @override
  List<Object?> get props => [notificationStream];
}
