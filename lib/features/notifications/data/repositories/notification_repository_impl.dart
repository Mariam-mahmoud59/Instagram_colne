import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/notifications/domain/repositories/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  Future<Either<Failure, T>> _handleOperation<T>(
      Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(message: 'Database Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Notification>> createNotification({
    required String userId,
    String? actorId,
    required NotificationType type,
    String? resourceId,
    required String message,
  }) async {
    return await _handleOperation<Notification>(
        () => remoteDataSource.createNotification(
              userId: userId,
              actorId: actorId,
              type: type,
              resourceId: resourceId,
              message: message,
            ));
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
      String notificationId) async {
    return await _handleOperation<void>(
        () => remoteDataSource.deleteNotification(notificationId));
  }

  @override
  Future<Either<Failure, List<Notification>>> getNotifications(
      String userId) async {
    return await _handleOperation<List<Notification>>(
        () => remoteDataSource.getNotifications(userId));
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    return await _handleOperation<void>(
        () => remoteDataSource.markAllAsRead(userId));
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    return await _handleOperation<void>(
        () => remoteDataSource.markAsRead(notificationId));
  }

  @override
  Future<Either<Failure, Stream<Notification>>> subscribeToNotifications(
      String userId) async {
    return await _handleOperation<Stream<Notification>>(
        () => remoteDataSource.subscribeToNotifications(userId));
  }
}
