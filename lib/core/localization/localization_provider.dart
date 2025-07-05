import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!_isLocaleSupported(locale)) return;
    
    _locale = locale;
    notifyListeners();
  }

  bool _isLocaleSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
}
