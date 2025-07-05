import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationAsRead
    implements UseCase<void, MarkNotificationAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(
      MarkNotificationAsReadParams params) async {
    return await repository.markAsRead(params.notificationId);
  }
}

class MarkNotificationAsReadParams extends NoParams {
  final String notificationId;

  MarkNotificationAsReadParams({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}
