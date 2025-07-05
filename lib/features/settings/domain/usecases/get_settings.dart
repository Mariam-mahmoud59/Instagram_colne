import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<Settings, GetSettingsParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(GetSettingsParams params) async {
    return await repository.getSettings(params.userId);
  }
}

class GetSettingsParams extends NoParams {
  final String userId;

  GetSettingsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
