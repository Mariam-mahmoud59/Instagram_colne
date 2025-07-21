# Instagram Clone Flutter App

## Overview
A full-featured Instagram clone built with Flutter, Bloc, and Supabase (PostgreSQL backend). The app supports authentication, posts, comments, likes, follows, stories, notifications, chat, and more. The codebase is modular and scalable, following clean architecture principles.

---

## Features
- User authentication (sign up, login, logout)
- User profiles with bio and profile picture
- Create, edit, and delete posts (with images/videos)
- Like and comment on posts
- Follow/unfollow users
- Stories (upload, view, progress indicator)
- Real-time chat (DMs)
- Notifications (likes, comments, follows, etc.)
- Explore page (search, trending)
- Favorites (save posts)
- Settings (language, theme, notifications)
- Localization (English/Arabic)
- Error handling, loading indicators, and empty states

---

## Folder Structure
```
lib/
  main.dart
  app.dart
  core/
    constants/
      supabase_constants.dart
      app_constants.dart
      api_constants.dart
    di/
      injection_container.dart
    error/
      failures.dart
      exceptions.dart
    localization/
      localization_helper.dart
      directionality_wrapper.dart
      localization_provider.dart
      app_localization_setup.dart
    usecase/
      usecase.dart
  features/
    activity/
      data/
        activity_repository.dart
      domain/
        entities/
          activity.dart
      presentation/
        screens/
          activity_screen.dart
    arch/
      presentation.zip
    auth/
      data/
      domain/
      presentation/
    chat/
      data/
      domain/
      di/
      presentation/
    common_widgets/
      app_bar.dart
      main_navigation_screen.dart
      user_avatar.dart
      loading_indicator.dart
      error_widget.dart
      empty_state_widget.dart
    explore/
      data/
      domain/
      di/
      presentation/
    favorites/
      data/
      domain/
      di/
      presentation/
    feed/
      data/
      domain/
      di/
      presentation/
    follow/
      data/
      domain/
      presentation/
    notifications/
      data/
        datasources/
          notification_remote_datasource.dart
          notification_remote_datasource_impl.dart
        models/
          notification_model.dart
        repositories/
          notification_repository_impl.dart
      domain/
        entities/
          notification.dart
        repositories/
          notification_repository.dart
        usecases/
          mark_notification_as_read.dart
          delete_notification.dart
          subscribe_to_notifications.dart
          mark_all_notifications_as_read.dart
          get_notifications.dart
          create_notification.dart
      di/
        notification_injection.dart
      presentation/
        bloc/
          notification_event.dart
          notification_state.dart
          notification_bloc.dart
        screens/
          notifications_screen.dart
          notification_screen.dart
        widgets/
          notification_item.dart
    post/
      data/
      domain/
      di/
      presentation/
    profile/
      data/
      domain/
      di/
      presentation/
    settings/
      data/
      domain/
      di/
      presentation/
    story/
      data/
        datasources/
          story_remote_datasource.dart
          story_remote_datasource_impl.dart
        models/
          story_model.dart
        repositories/
          story_repository_impl.dart
      domain/
        entities/
          story.dart
        repositories/
          story_repository.dart
        usecases/
          get_stories.dart
          create_story.dart
          create_story_item.dart
      di/
        story_injection.dart
      presentation/
        bloc/
          story_bloc.dart
          story_event.dart
          story_state.dart
        screens/
          story_view_screen.dart
          create_story_screen.dart
        widgets/
          story_circles_widget.dart
          story_progress_indicator.dart
  generated/
    app_localizations.dart
    app_localizations_en.dart
    app_localizations_ar.dart
  l10n/
    app_en.arb
    app_ar.arb
```

---

## How to Run the Project
1. **Install Flutter** (latest stable): [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd instagram_clone
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Configure Supabase:**
   - Create a new project on Supabase (app.supabase.com)
   - Run the database schema and policies script (see Supabase Setup section)
   - Get your Project URL and anon key from Settings > API
   - Set them in `lib/core/constants/supabase_constants.dart`
5. **Run the app:**
   ```bash
   flutter run
   ```

---

## Supabase Setup
- Use the following schema and policies script in the SQL Editor:

```sql
-- (See the full script in previous responses)
```
- Enable Auth and Storage from the Supabase dashboard.
- Connect your app using the Project URL and anon key.

---

## Main Technologies
- **Flutter** (UI, navigation, state management)
- **Bloc** (business logic, state)
- **Supabase** (PostgreSQL, Auth, Storage, Realtime)
- **Dart** (language)
- **Localization** (arb, intl)

---

## Special Notes
- The codebase follows Clean Architecture (data/domain/presentation)
- Each feature is in its own folder for modularity
- Supports multiple languages (en/ar)
- Easily extensible and customizable
- All database tables and policies are compatible with the code
- You can add new features easily by creating a new folder in features

---

## Contact
For any questions or further development, contact the maintainer or open an Issue in the repository.
