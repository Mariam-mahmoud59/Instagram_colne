part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final String userId;

  const GetNotificationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsAsReadEvent extends NotificationEvent {
  final String userId;

  const MarkAllNotificationsAsReadEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class CreateNotificationEvent extends NotificationEvent {
  final String userId;
  final String? actorId;
  final NotificationType type;
  final String? resourceId;
  final String message;

  const CreateNotificationEvent({
    required this.userId,
    this.actorId,
    required this.type,
    this.resourceId,
    required this.message,
  });

  @override
  List<Object?> get props => [userId, actorId, type, resourceId, message];
}

class SubscribeToNotificationsEvent extends NotificationEvent {
  final String userId;

  const SubscribeToNotificationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NotificationReceivedEvent extends NotificationEvent {
  final Notification notification;

  const NotificationReceivedEvent({required this.notification});

  @override
  List<Object?> get props => [notification];
}
