import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/create_notification.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/delete_notification.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/get_notifications.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/mark_all_notifications_as_read.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:instagram_clone/features/notifications/domain/usecases/subscribe_to_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;
  final DeleteNotification deleteNotification;
  final CreateNotification createNotification;
  final SubscribeToNotifications subscribeToNotifications;
  
  StreamSubscription<Notification>? _notificationSubscription;

  NotificationBloc({
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.markAllNotificationsAsRead,
    required this.deleteNotification,
    required this.createNotification,
    required this.subscribeToNotifications,
  }) : super(NotificationInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllNotificationsAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<CreateNotificationEvent>(_onCreateNotification);
    on<SubscribeToNotificationsEvent>(_onSubscribeToNotifications);
    on<NotificationReceivedEvent>(_onNotificationReceived);
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getNotifications(GetNotificationsParams(userId: event.userId));
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationsLoaded(notifications: notifications)),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await markNotificationAsRead(
      MarkNotificationAsReadParams(notificationId: event.notificationId),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) => emit(const NotificationActionSuccess(message: 'Notification marked as read')),
    );
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await markAllNotificationsAsRead(
      MarkAllNotificationsAsReadParams(userId: event.userId),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) => emit(const NotificationActionSuccess(message: 'All notifications marked as read')),
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await deleteNotification(
      DeleteNotificationParams(notificationId: event.notificationId),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) => emit(const NotificationActionSuccess(message: 'Notification deleted')),
    );
  }

  Future<void> _onCreateNotification(
    CreateNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await createNotification(
      CreateNotificationParams(
        userId: event.userId,
        actorId: event.actorId,
        type: event.type,
        resourceId: event.resourceId,
        message: event.message,
      ),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notification) => emit(NotificationCreated(notification: notification)),
    );
  }

  Future<void> _onSubscribeToNotifications(
    SubscribeToNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await subscribeToNotifications(
      SubscribeToNotificationsParams(userId: event.userId),
    );
    
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notificationStream) {
        // Cancel any existing subscription
        _notificationSubscription?.cancel();
        
        // Subscribe to the new stream
        _notificationSubscription = notificationStream.listen(
          (notification) => add(NotificationReceivedEvent(notification: notification)),
        );
        
        emit(NotificationSubscribed(notificationStream: notificationStream));
      },
    );
  }

  void _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) {
    // When a new notification is received, we can update the UI or show a toast
    emit(NotificationCreated(notification: event.notification));
    
    // Then reload the notifications list
    if (event.notification.userId.isNotEmpty) {
      add(GetNotificationsEvent(userId: event.notification.userId));
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
