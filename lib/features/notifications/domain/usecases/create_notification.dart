import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';

class CreateNotification
    implements UseCase<Notification, CreateNotificationParams> {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  @override
  Future<Either<Failure, Notification>> call(
      CreateNotificationParams params) async {
    return await repository.createNotification(
      userId: params.userId,
      actorId: params.actorId,
      type: params.type,
      resourceId: params.resourceId,
      message: params.message,
    );
  }
}

class CreateNotificationParams extends NoParams {
  final String userId;
  final String? actorId;
  final NotificationType type;
  final String? resourceId;
  final String message;

  CreateNotificationParams({
    required this.userId,
    this.actorId,
    required this.type,
    this.resourceId,
    required this.message,
  });

  @override
  List<Object> get props =>
      [userId, actorId ?? '', type, resourceId ?? '', message];
}
