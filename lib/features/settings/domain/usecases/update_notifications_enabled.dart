import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';

class UpdateNotificationsEnabled
    implements UseCase<Settings, UpdateNotificationsEnabledParams> {
  final SettingsRepository repository;

  UpdateNotificationsEnabled(this.repository);

  @override
  Future<Either<Failure, Settings>> call(
      UpdateNotificationsEnabledParams params) async {
    return await repository.updateNotificationsEnabled(
        params.userId, params.enabled);
  }
}

class UpdateNotificationsEnabledParams extends NoParams {
  final String userId;
  final bool enabled;

  UpdateNotificationsEnabledParams({
    required this.userId,
    required this.enabled,
  });

  @override
  List<Object> get props => [userId, enabled];
}
