import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';

class UpdateLanguage implements UseCase<Settings, UpdateLanguageParams> {
  final SettingsRepository repository;

  UpdateLanguage(this.repository);

  @override
  Future<Either<Failure, Settings>> call(UpdateLanguageParams params) async {
    return await repository.updateLanguage(params.userId, params.language);
  }
}

class UpdateLanguageParams extends NoParams {
  final String userId;
  final String language;

  UpdateLanguageParams({
    required this.userId,
    required this.language,
  });

  @override
  List<Object> get props => [userId, language];
}
