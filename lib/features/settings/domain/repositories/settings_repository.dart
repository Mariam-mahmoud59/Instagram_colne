import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  /// Get user settings
  Future<Either<Failure, Settings>> getSettings(String userId);
  
  /// Update theme mode
  Future<Either<Failure, Settings>> updateThemeMode(String userId, ThemeMode themeMode);
  
  /// Update language
  Future<Either<Failure, Settings>> updateLanguage(String userId, String language);
  
  /// Update notifications enabled status
  Future<Either<Failure, Settings>> updateNotificationsEnabled(String userId, bool enabled);
}
