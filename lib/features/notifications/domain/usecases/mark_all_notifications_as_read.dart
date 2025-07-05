import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class MarkAllNotificationsAsRead
    implements UseCase<void, MarkAllNotificationsAsReadParams> {
  final NotificationRepository repository;

  MarkAllNotificationsAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(
      MarkAllNotificationsAsReadParams params) async {
    return await repository.markAllAsRead(params.userId);
  }
}

class MarkAllNotificationsAsReadParams extends NoParams {
  final String userId;

  MarkAllNotificationsAsReadParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
