import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

abstract class SettingsRemoteDataSource {
  /// Get user settings
  Future<Settings> getSettings(String userId);

  /// Update theme mode
  Future<void> updateThemeMode(String userId, ThemeMode themeMode);

  /// Update language
  Future<void> updateLanguage(String userId, String language);

  /// Update notifications enabled status
  Future<void> updateNotificationsEnabled(String userId, bool enabled);
}
