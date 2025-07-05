import 'package:instagram_clone/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:instagram_clone/features/settings/data/models/settings_model.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final SupabaseClient supabaseClient;

  SettingsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<SettingsModel> getSettings(String userId) async {
    try {
      final response = await supabaseClient
          .from('settings')
          .select()
          .eq('user_id', userId)
          .single();

      return SettingsModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No settings found, create default settings
        return _createDefaultSettings(userId);
      }
      throw ServerException(message: 'Failed to get settings: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to get settings: $e');
    }
  }

  @override
  Future<SettingsModel> updateLanguage(String userId, String language) async {
    try {
      final response = await supabaseClient
          .from('settings')
          .update({
            'language': language,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return SettingsModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No settings found, create default settings with the specified language
        return _createDefaultSettings(userId, language: language);
      }
      throw ServerException(message: 'Failed to update language: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to update language: $e');
    }
  }

  @override
  Future<SettingsModel> updateNotificationsEnabled(
      String userId, bool enabled) async {
    try {
      final response = await supabaseClient
          .from('settings')
          .update({
            'notifications_enabled': enabled,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return SettingsModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No settings found, create default settings with the specified notifications enabled status
        return _createDefaultSettings(userId, notificationsEnabled: enabled);
      }
      throw ServerException(
          message: 'Failed to update notifications status: $e');
    } catch (e) {
      throw ServerException(
          message: 'Failed to update notifications status: $e');
    }
  }

  @override
  Future<SettingsModel> updateThemeMode(
      String userId, ThemeMode themeMode) async {
    try {
      final response = await supabaseClient
          .from('settings')
          .update({
            'theme_mode': themeMode.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return SettingsModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No settings found, create default settings with the specified theme mode
        return _createDefaultSettings(userId, themeMode: themeMode);
      }
      throw ServerException(message: 'Failed to update theme mode: $e');
    } catch (e) {
      throw ServerException(message: 'Failed to update theme mode: $e');
    }
  }

  Future<SettingsModel> _createDefaultSettings(
    String userId, {
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
  }) async {
    try {
      final settingsData = {
        'user_id': userId,
        'theme_mode': themeMode?.name ?? ThemeMode.system.name,
        'language': language ?? 'en',
        'notifications_enabled': notificationsEnabled ?? true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('settings')
          .insert(settingsData)
          .select()
          .single();

      return SettingsModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Failed to create default settings: $e');
    }
  }
}
