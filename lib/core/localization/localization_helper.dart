import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/core/localization/localization_provider.dart';

class LocalizationHelper {
  // Helper method to update app language
  static void changeLanguage(BuildContext context, String languageCode) {
    final localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);
    localizationProvider.setLocale(Locale(languageCode));
  }

  // Helper method to get current language code
  static String getCurrentLanguageCode(BuildContext context) {
    final localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);
    return localizationProvider.locale.languageCode;
  }

  // Helper method to check if current language is RTL
  static bool isRtl(BuildContext context) {
    final locale =
        Provider.of<LocalizationProvider>(context, listen: false).locale;
    return locale.languageCode == 'ar' ||
        locale.languageCode == 'he' ||
        locale.languageCode == 'fa';
  }

  // Helper method to get text direction based on current language
  static TextDirection getTextDirection(BuildContext context) {
    return isRtl(context) ? TextDirection.rtl : TextDirection.ltr;
  }
}
