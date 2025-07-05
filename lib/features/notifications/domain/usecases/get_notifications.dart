import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications
    implements UseCase<List<Notification>, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(
      GetNotificationsParams params) async {
    return await repository.getNotifications(params.userId);
  }
}

class GetNotificationsParams extends NoParams {
  final String userId;

  GetNotificationsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
