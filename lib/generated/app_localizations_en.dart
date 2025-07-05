// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Instagram Clone';

  @override
  String get loginButton => 'Log In';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get usernameHint => 'Username';

  @override
  String get fullNameHint => 'Full Name';

  @override
  String get bioHint => 'Bio';

  @override
  String postsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Posts',
      one: '1 Post',
      zero: '0 Posts',
    );
    return '$_temp0';
  }

  @override
  String followersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Followers',
      one: '1 Follower',
      zero: '0 Followers',
    );
    return '$_temp0';
  }

  @override
  String followingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Following',
      one: '1 Following',
      zero: '0 Following',
    );
    return '$_temp0';
  }

  @override
  String get editProfileButton => 'Edit Profile';

  @override
  String get followButton => 'Follow';

  @override
  String get followingButton => 'Following';

  @override
  String get noPostsYet => 'No posts yet.';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get noPostsToExplore => 'No posts to explore yet.';

  @override
  String get somethingWentWrong => 'Something went wrong!';

  @override
  String get serverErrorOccurred => 'Server error occurred';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get requestedDataNotFound => 'Requested data not found';

  @override
  String get authenticationError => 'Authentication error';

  @override
  String get invalidData => 'Invalid data';

  @override
  String get databaseError => 'Database error';

  @override
  String get cacheError => 'Cache error';

  @override
  String get unexpectedError => 'Unexpected error occurred';

  @override
  String viewAllComments(Object count) {
    return 'View all $count comments';
  }

  @override
  String likesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count likes',
      one: '1 like',
      zero: '0 likes',
    );
    return '$_temp0';
  }

  @override
  String get searchUsersHint => 'Search users...';

  @override
  String get exploreTitle => 'Explore';

  @override
  String get feedTitle => 'Instagram';

  @override
  String get postTitle => 'Post';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get notificationsEnabled => 'Notifications Enabled';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get messages => 'Messages';

  @override
  String get noMessages => 'No messages';

  @override
  String get typeMessage => 'Type a message';
}
