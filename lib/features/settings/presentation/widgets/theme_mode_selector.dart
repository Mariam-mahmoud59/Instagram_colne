import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:instagram_clone/generated/app_localizations.dart';
import '../../domain/entities/settings.dart';

class ThemeModeSelector extends StatelessWidget {
  final String userId;

  const ThemeModeSelector({Key? key, required this.userId}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsBloc>().state;
    if (state is SettingsLoaded) {
      final l10n = AppLocalizations.of(context)!;
      return ListTile(
        title: Text(l10n.darkMode),
        trailing: DropdownButton<ThemeMode>(
          value: state.settings.flutterThemeMode,
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              context.read<SettingsBloc>().add(UpdateThemeModeEvent(
                    userId: userId,
                    themeMode: _toAppThemeMode(newValue),
                  ));
            }
          },
          items: <ThemeMode>[ThemeMode.system, ThemeMode.light, ThemeMode.dark]
              .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
            String text;
            switch (value) {
              case ThemeMode.system:
                text = 'System';
                break;
              case ThemeMode.light:
                text = 'Light';
                break;
              case ThemeMode.dark:
                text = 'Dark';
                break;
            }
            return DropdownMenuItem<ThemeMode>(
              value: value,
              child: Text(text),
            );
          }).toList(),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
