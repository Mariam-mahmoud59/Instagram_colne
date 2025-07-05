import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final String id;
  final String userId;
  final AppThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;
  final DateTime updatedAt;

  const Settings({
    required this.id,
    required this.userId,
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.updatedAt,
  });

  // Convert AppThemeMode to Flutter's ThemeMode
  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  List<Object?> get props =>
      [id, userId, themeMode, language, notificationsEnabled, updatedAt];
}

enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeExtension on AppThemeMode {
  String get name {
    switch (this) {
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  static AppThemeMode fromString(String value) {
    switch (value) {
      case 'system':
        return AppThemeMode.system;
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }
}
