import 'package:instagram_clone/features/settings/domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.id,
    required super.userId,
    required super.themeMode,
    required super.language,
    required super.notificationsEnabled,
    required super.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'],
      userId: json['user_id'],
      themeMode: AppThemeModeExtension.fromString(json['theme_mode']),
      language: json['language'],
      notificationsEnabled: json['notifications_enabled'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme_mode': themeMode.name,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
