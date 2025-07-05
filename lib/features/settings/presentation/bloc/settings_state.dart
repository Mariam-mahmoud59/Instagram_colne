part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ThemeModeUpdated extends SettingsState {
  final Settings settings;

  const ThemeModeUpdated({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class LanguageUpdated extends SettingsState {
  final Settings settings;

  const LanguageUpdated({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class NotificationsEnabledUpdated extends SettingsState {
  final Settings settings;

  const NotificationsEnabledUpdated({required this.settings});

  @override
  List<Object?> get props => [settings];
}
