part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class GetSettingsEvent extends SettingsEvent {
  final String userId;

  const GetSettingsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateThemeModeEvent extends SettingsEvent {
  final String userId;
  final dynamic themeMode; // Use dynamic to avoid import issues, actual type handled in bloc

  const UpdateThemeModeEvent({
    required this.userId,
    required this.themeMode,
  });

  @override
  List<Object?> get props => [userId, themeMode];
}

class UpdateLanguageEvent extends SettingsEvent {
  final String userId;
  final String language;

  const UpdateLanguageEvent({required this.userId, required this.language});

  @override
  List<Object?> get props => [userId, language];
}

class UpdateNotificationsEnabledEvent extends SettingsEvent {
  final String userId;
  final bool enabled;

  const UpdateNotificationsEnabledEvent({required this.userId, required this.enabled});

  @override
  List<Object?> get props => [userId, enabled];
}
