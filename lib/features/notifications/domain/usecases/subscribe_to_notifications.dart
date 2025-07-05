import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class SubscribeToNotifications
    implements UseCase<Stream<Notification>, SubscribeToNotificationsParams> {
  final NotificationRepository repository;

  SubscribeToNotifications(this.repository);

  @override
  Future<Either<Failure, Stream<Notification>>> call(
      SubscribeToNotificationsParams params) async {
    return await repository.subscribeToNotifications(params.userId);
  }
}

class SubscribeToNotificationsParams extends NoParams {
  final String userId;

  SubscribeToNotificationsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
