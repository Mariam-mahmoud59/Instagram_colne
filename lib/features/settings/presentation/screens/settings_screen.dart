import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  final String userId;

  const SettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppThemeMode _toAppThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppThemeMode.system;
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
    }
  }

  ThemeMode _toThemeMode(AppThemeMode appThemeMode) {
    switch (appThemeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(GetSettingsEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ThemeModeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Theme updated')),
            );
          } else if (state is LanguageUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Language updated')),
            );
          } else if (state is NotificationsEnabledUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings updated')),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading && state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded || 
                     state is ThemeModeUpdated || 
                     state is LanguageUpdated || 
                     state is NotificationsEnabledUpdated) {
            
            Settings settings;
            if (state is SettingsLoaded) {
              settings = state.settings;
            } else if (state is ThemeModeUpdated) {
              settings = state.settings;
            } else if (state is LanguageUpdated) {
              settings = state.settings;
            } else if (state is NotificationsEnabledUpdated) {
              settings = state.settings;
            } else {
              // This should never happen, but just in case
              return const Center(child: Text('Failed to load settings'));
            }
            
            return ListView(
              children: [
                // Theme Mode Section
                _buildSectionHeader('Appearance'),
                _buildThemeModeSelector(settings.themeMode),
                
                const Divider(),
                
                // Language Section
                _buildSectionHeader('Language'),
                _buildLanguageSelector(settings.language),
                
                const Divider(),
                
                // Notifications Section
                _buildSectionHeader('Notifications'),
                _buildNotificationsSwitch(settings.notificationsEnabled),
                
                const Divider(),
                
                // Account Section
                _buildSectionHeader('Account'),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Account Information'),
                  onTap: () {
                    // Navigate to account information screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Privacy and Security'),
                  onTap: () {
                    // Navigate to privacy and security screen
                  },
                ),
                
                const Divider(),
                
                // About Section
                _buildSectionHeader('About'),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About Instagram Clone'),
                  onTap: () {
                    // Show about dialog
                    showAboutDialog(
                      context: context,
                      applicationName: 'Instagram Clone',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2025 Instagram Clone',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help'),
                  onTap: () {
                    // Navigate to help screen
                  },
                ),
                
                const Divider(),
                
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Handle logout
                    },
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Failed to load settings'));
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(AppThemeMode currentThemeMode) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System Default'),
          value: ThemeMode.system,
          groupValue: _toThemeMode(currentThemeMode),
          onChanged: (ThemeMode? value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                    UpdateThemeModeEvent(
                      userId: widget.userId,
                      themeMode: _toAppThemeMode(value),
                    ),
                  );
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light Mode'),
          value: ThemeMode.light,
          groupValue: _toThemeMode(currentThemeMode),
          onChanged: (ThemeMode? value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                    UpdateThemeModeEvent(
                      userId: widget.userId,
                      themeMode: _toAppThemeMode(value),
                    ),
                  );
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Mode'),
          value: ThemeMode.dark,
          groupValue: _toThemeMode(currentThemeMode),
          onChanged: (ThemeMode? value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                    UpdateThemeModeEvent(
                      userId: widget.userId,
                      themeMode: _toAppThemeMode(value),
                    ),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(String currentLanguage) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: currentLanguage,
          onChanged: (String? value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                    UpdateLanguageEvent(
                      userId: widget.userId,
                      language: value,
                    ),
                  );
            }
          },
        ),
        RadioListTile<String>(
          title: const Text('العربية'),
          value: 'ar',
          groupValue: currentLanguage,
          onChanged: (String? value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                    UpdateLanguageEvent(
                      userId: widget.userId,
                      language: value,
                    ),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSwitch(bool notificationsEnabled) {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      value: notificationsEnabled,
      onChanged: (bool value) {
        context.read<SettingsBloc>().add(
              UpdateNotificationsEnabledEvent(
                userId: widget.userId,
                enabled: value,
              ),
            );
      },
    );
  }
}
