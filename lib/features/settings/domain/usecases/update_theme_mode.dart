import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateThemeMode implements UseCase<void, UpdateThemeModeParams> {
  final SettingsRepository repository;

  UpdateThemeMode(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateThemeModeParams params) async {
    return await repository.updateThemeMode(params.userId, params.themeMode);
  }
}

class UpdateThemeModeParams extends NoParams {
  final String userId;
  final ThemeMode themeMode;

  UpdateThemeModeParams({
    required this.userId,
    required this.themeMode,
  });

  @override
  List<Object> get props => [userId, themeMode];
}
