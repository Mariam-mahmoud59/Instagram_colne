import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class DeleteNotification implements UseCase<void, DeleteNotificationParams> {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteNotificationParams params) async {
    return await repository.deleteNotification(params.notificationId);
  }
}

class DeleteNotificationParams extends NoParams {
  final String notificationId;

  DeleteNotificationParams({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}
