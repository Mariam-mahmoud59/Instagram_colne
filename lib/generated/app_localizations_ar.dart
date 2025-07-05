// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'استنساخ انستغرام';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signupButton => 'إنشاء حساب';

  @override
  String get emailHint => 'البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get usernameHint => 'اسم المستخدم';

  @override
  String get fullNameHint => 'الاسم الكامل';

  @override
  String get bioHint => 'السيرة الذاتية';

  @override
  String postsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منشور',
      many: '$count منشور',
      few: '$count منشورات',
      two: 'منشوران',
      one: 'منشور واحد',
      zero: '0 منشورات',
    );
    return '$_temp0';
  }

  @override
  String followersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متابع',
      many: '$count متابع',
      few: '$count متابعين',
      two: 'متابعان',
      one: 'متابع واحد',
      zero: '0 متابع',
    );
    return '$_temp0';
  }

  @override
  String followingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متابع',
      many: '$count متابع',
      few: '$count متابعين',
      two: 'متابعان',
      one: 'متابع واحد',
      zero: '0 متابع',
    );
    return '$_temp0';
  }

  @override
  String get editProfileButton => 'تعديل الملف الشخصي';

  @override
  String get followButton => 'متابعة';

  @override
  String get followingButton => 'يتابع';

  @override
  String get noPostsYet => 'لا توجد منشورات بعد.';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين.';

  @override
  String get noPostsToExplore => 'لا توجد منشورات للاستكشاف بعد.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما!';

  @override
  String get serverErrorOccurred => 'حدث خطأ في الخادم';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get requestedDataNotFound => 'البيانات المطلوبة غير موجودة';

  @override
  String get authenticationError => 'خطأ في المصادقة';

  @override
  String get invalidData => 'بيانات غير صالحة';

  @override
  String get databaseError => 'خطأ في قاعدة البيانات';

  @override
  String get cacheError => 'خطأ في التخزين المؤقت';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String viewAllComments(Object count) {
    return 'عرض كل $count التعليقات';
  }

  @override
  String likesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إعجاب',
      many: '$count إعجاب',
      few: '$count إعجابات',
      two: 'إعجابان',
      one: 'إعجاب واحد',
      zero: '0 إعجاب',
    );
    return '$_temp0';
  }

  @override
  String get searchUsersHint => 'البحث عن مستخدمين...';

  @override
  String get exploreTitle => 'استكشاف';

  @override
  String get feedTitle => 'انستغرام';

  @override
  String get postTitle => 'منشور';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get notificationsEnabled => 'الإشعارات مفعلة';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String get confirmLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get messages => 'الرسائل';

  @override
  String get noMessages => 'لا توجد رسائل';

  @override
  String get typeMessage => 'اكتب رسالة';
}
