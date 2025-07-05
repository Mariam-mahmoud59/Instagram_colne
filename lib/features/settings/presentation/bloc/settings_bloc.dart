import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/domain/usecases/get_settings.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_language.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_notifications_enabled.dart';
import 'package:instagram_clone/features/settings/domain/usecases/update_theme_mode.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateThemeMode updateThemeMode;
  final UpdateLanguage updateLanguage;
  final UpdateNotificationsEnabled updateNotificationsEnabled;

  SettingsBloc({
    required this.getSettings,
    required this.updateThemeMode,
    required this.updateLanguage,
    required this.updateNotificationsEnabled,
  }) : super(SettingsInitial()) {
    on<GetSettingsEvent>(_onGetSettings);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateNotificationsEnabledEvent>(_onUpdateNotificationsEnabled);
  }

  Future<void> _onGetSettings(
    GetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await getSettings(GetSettingsParams(userId: event.userId));
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await updateThemeMode(
      UpdateThemeModeParams(userId: event.userId, themeMode: event.themeMode),
    );
    result.fold(
      (failure) {
        emit(SettingsError(message: failure.message));
      },
      (_) {
        // Reload settings after successful update
        add(GetSettingsEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await updateLanguage(
      UpdateLanguageParams(userId: event.userId, language: event.language),
    );
    result.fold(
      (failure) {
        emit(SettingsError(message: failure.message));
      },
      (_) {
        // Reload settings after successful update
        add(GetSettingsEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onUpdateNotificationsEnabled(
    UpdateNotificationsEnabledEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await updateNotificationsEnabled(
      UpdateNotificationsEnabledParams(
          userId: event.userId, enabled: event.enabled),
    );
    result.fold(
      (failure) {
        emit(SettingsError(message: failure.message));
      },
      (_) {
        // Reload settings after successful update
        add(GetSettingsEvent(userId: event.userId));
      },
    );
  }
}
