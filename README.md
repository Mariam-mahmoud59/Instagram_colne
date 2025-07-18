# Instagram Clone App

## Project Description

This is a Flutter-based Instagram clone application, built with a focus on clean architecture principles and powered by Supabase as the backend. The app aims to replicate core Instagram functionalities, providing a robust and scalable foundation for social media applications.

## Features

-   **User Authentication:** Sign up, log in, and manage user sessions.
-   **User Profiles:** View and manage user profiles, including avatar, bio, and posts.
-   **Feed:** Display a personalized feed of posts from followed users.
-   **Post Management:** Create, view, like, comment on, and save posts.
-   **Stories:** Create and view ephemeral stories (images/videos).
-   **Direct Messaging (Chat):** Real-time chat functionality between users.
-   **Notifications:** Receive and manage various types of notifications (likes, comments, follows).
-   **Explore:** Discover new posts and users.
-   **Follow/Unfollow:** Manage social connections.
-   **Settings:** Customize app settings like theme mode and language.
-   **Internationalization (i18n):** Support for multiple languages (English and Arabic).
-   **Theming:** Light and Dark mode support.

## Technologies Used

-   **Flutter:** UI Toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
-   **Supabase:** Open-source Firebase alternative providing a PostgreSQL database, Authentication, instant APIs, and Storage.
-   **BLoC (Business Logic Component):** State management pattern for separating business logic from UI.
-   **GetIt:** Simple Service Locator for Dart and Flutter.
-   **Equatable:** For value equality in Dart.
-   **Dartz:** Functional programming in Dart (for error handling).
-   **Image Picker:** For picking images and videos from the device gallery.
-   **Video Player:** For playing videos within the app.
-   **Cached Network Image:** For caching network images.
-   **Intl:** For internationalization and localization.

## Setup

Follow these steps to get the project up and running on your local machine.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
-   [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) installed.
-   [VS Code](https://code.visualstudio.com/) or any preferred IDE with Flutter and Dart plugins.
-   A Supabase account and project configured (see [Supabase Setup](#supabase-setup)).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/instagram_clone.git
    cd instagram_clone
    ```

2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Supabase:**
    Update your Supabase URL and Anon Key in `lib/core/constants/supabase_constants.dart`.
    ```dart
    // lib/core/constants/supabase_constants.dart

    class SupabaseConstants {
      static const String supabaseUrl = 'YOUR_SUPABASE_URL';
      static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
    }
    ```

## Running the App

To run the application on an emulator or a physical device:

```bash
flutter run
```

## Project Structure

The project follows a Clean Architecture approach, organized by features. Each feature (e.g., `auth`, `post`, `chat`) has its own dedicated directory containing sub-layers:

```
lib/
├── core/                  # Core functionalities, common utilities, constants, error handling
│   ├── constants/
│   ├── error/
│   ├── di/                # Dependency Injection setup
│   ├── localization/      # Internationalization setup
│   └── theme/             # App theming
├── features/              # Main application features
│   ├── auth/              # User authentication (login, signup, profile management)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   ├── di/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   ├── chat/              # Direct messaging
│   ├── explore/           # Discover posts and users
│   ├── favorites/         # Saved posts
│   ├── feed/              # Main user feed
│   ├── follow/            # Follow/unfollow logic
│   ├── notifications/     # In-app notifications
│   ├── post/              # Post creation and display
│   ├── profile/           # User profiles
│   ├── settings/          # App settings
│   └── story/             # Ephemeral stories
├── app.dart               # Main app widget
└── main.dart              # Entry point of the application
```

## Supabase Setup

This project relies on Supabase for its backend services. You need to set up your Supabase project with the necessary tables, Row Level Security (RLS) policies, and Storage buckets.

### Database Schema

Use the following SQL code to create the required tables and RLS policies in your Supabase project's SQL Editor. **Be cautious: running this will overwrite existing tables if they have the same names.**

```sql
-- Drop tables if they exist to allow for clean re-creation
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS chats CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS saved_posts CASCADE;
DROP TABLE IF EXISTS likes CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS followers CASCADE;
DROP TABLE IF EXISTS stories CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Create a table for public profiles
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique,
  full_name text,
  avatar_url text,
  website text,
  bio text,
  created_at timestamp with time zone default now()
);

alter table profiles enable row level security;

create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

create policy "Users can insert their own profile." on profiles
  for insert with check (auth.uid() = id);

create policy "Users can update own profile." on profiles
  for update using (auth.uid() = id);

-- Create a table for posts
create table posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  media_url text not null,
  media_type text not null, -- 'image' or 'video'
  caption text,
  location text,
  likes_count integer default 0,
  comments_count integer default 0,
  created_at timestamp with time zone default now()
);

alter table posts enable row level security;

create policy "Posts are viewable by everyone." on posts
  for select using (true);

create policy "Users can insert their own posts." on posts
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own posts." on posts
  for update using (auth.uid() = user_id);

create policy "Users can delete their own posts." on posts
  for delete using (auth.uid() = user_id);

-- Create a table for likes
create table likes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  post_id uuid references posts on delete cascade,
  created_at timestamp with time zone default now(),
  unique (user_id, post_id) -- Ensure a user can only like a post once
);

alter table likes enable row level security;

create policy "Likes are viewable by everyone." on likes
  for select using (true);

create policy "Users can insert their own likes." on likes
  for insert with check (auth.uid() = user_id);

create policy "Users can delete their own likes." on likes
  for delete using (auth.uid() = user_id);

-- Create a table for comments
create table comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  post_id uuid references posts on delete cascade,
  content text not null,
  created_at timestamp with time zone default now()
);

alter table comments enable row level security;

create policy "Comments are viewable by everyone." on comments
  for select using (true);

create policy "Users can insert their own comments." on comments
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own comments." on comments
  for update using (auth.uid() = user_id);

create policy "Users can delete their own comments." on comments
  for delete using (auth.uid() = user_id);

-- Create a table for followers/following relationships
create table followers (
  id uuid primary key default gen_random_uuid(),
  follower_id uuid references profiles on delete cascade,
  following_id uuid references profiles on delete cascade,
  created_at timestamp with time zone default now(),
  unique (follower_id, following_id) -- Ensure a user can only follow another user once
);

alter table followers enable row level security;

create policy "Followers are viewable by everyone." on followers
  for select using (true);

create policy "Users can insert their own follow relationships." on followers
  for insert with check (auth.uid() = follower_id);

create policy "Users can delete their own follow relationships." on followers
  for delete using (auth.uid() = follower_id);

-- Create a table for stories
create table stories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  media_url text not null,
  media_type text not null, -- 'image' or 'video'
  expires_at timestamp with time zone not null, -- Stories typically expire after 24 hours
  created_at timestamp with time zone default now()
);

alter table stories enable row level security;

create policy "Stories are viewable by everyone." on stories
  for select using (true);

create policy "Users can insert their own stories." on stories
  for insert with check (auth.uid() = user_id);

create policy "Users can delete their own stories." on stories
  for delete using (auth.uid() = user_id);

-- Create a table for chat conversations
create table chats (
  id uuid primary key default gen_random_uuid(),
  participant1_id uuid references profiles on delete cascade,
  participant2_id uuid references profiles on delete cascade,
  created_at timestamp with time zone default now(),
  unique (participant1_id, participant2_id) -- Ensure only one chat between two users
);

alter table chats enable row level security;

create policy "Chat participants can view their chats." on chats
  for select using (auth.uid() = participant1_id or auth.uid() = participant2_id);

create policy "Users can create chats with other users." on chats
  for insert with check (auth.uid() = participant1_id or auth.uid() = participant2_id);

create policy "Chat participants can delete their chats." on chats
  for delete using (auth.uid() = participant1_id or auth.uid() = participant2_id);

-- Create a table for messages within chats
create table messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid references chats on delete cascade,
  sender_id uuid references profiles on delete cascade,
  content text not null,
  created_at timestamp with time zone default now()
);

alter table messages enable row level security;

create policy "Chat participants can view messages." on messages
  for select using (auth.uid() = (select participant1_id from chats where id = chat_id) or auth.uid() = (select participant2_id from chats where id = chat_id));

create policy "Chat participants can send messages." on messages
  for insert with check (auth.uid() = sender_id and (auth.uid() = (select participant1_id from chats where id = chat_id) or auth.uid() = (select participant2_id from chats where id = chat_id)));

create policy "Chat participants can delete their messages." on messages
  for delete using (auth.uid() = sender_id and (auth.uid() = (select participant1_id from chats where id = chat_id) or auth.uid() = (select participant2_id from chats where id = chat_id)));

-- Create a table for notifications
create table notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid references profiles on delete cascade,
  sender_id uuid references profiles on delete set null, -- Can be null if system notification
  type text not null, -- e.g., 'like', 'comment', 'follow'
  related_post_id uuid references posts on delete set null,
  related_comment_id uuid references comments on delete set null,
  is_read boolean default false,
  created_at timestamp with time zone default now()
);

alter table notifications enable row level security;

create policy "Notifications are viewable by recipient." on notifications
  for select using (auth.uid() = recipient_id);

create policy "Users can insert notifications (e.g., when liking/commenting)." on notifications
  for insert with check (true); -- More complex RLS might be needed here to restrict who can create notifications

create policy "Recipient can update their notifications (e.g., mark as read)." on notifications
  for update using (auth.uid() = recipient_id);

create policy "Recipient can delete their notifications." on notifications
  for delete using (auth.uid() = recipient_id);

-- Create a table for saved posts (favorites)
create table saved_posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  post_id uuid references posts on delete cascade,
  created_at timestamp with time zone default now(),
  unique (user_id, post_id) -- Ensure a user can only save a post once
);

alter table saved_posts enable row level security;

create policy "Saved posts are viewable by owner." on saved_posts
  for select using (auth.uid() = user_id);

create policy "Users can insert their own saved posts." on saved_posts
  for insert with check (auth.uid() = user_id);

create policy "Users can delete their own saved posts." on saved_posts
  for delete using (auth.uid() = user_id);

-- Optional: Add functions/triggers for denormalization (e.g., updating likes_count on posts table)
-- This is an advanced topic and can be added later if performance becomes an issue.

-- Example trigger for likes_count
-- CREATE OR REPLACE FUNCTION increment_likes_count() RETURNS TRIGGER AS $$
-- BEGIN
--   UPDATE posts
--   SET likes_count = likes_count + 1
--   WHERE id = NEW.post_id;
--   RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER increment_likes_trigger
--   AFTER INSERT ON likes
--   FOR EACH ROW EXECUTE FUNCTION increment_likes_count();

-- CREATE OR REPLACE FUNCTION decrement_likes_count() RETURNS TRIGGER AS $$
-- BEGIN
--   UPDATE posts
--   SET likes_count = likes_count - 1
--   WHERE id = OLD.post_id;
--   RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER decrement_likes_trigger
--   AFTER DELETE ON likes
--   FOR EACH ROW EXECUTE FUNCTION decrement_likes_count();

-- Similarly for comments_count
```

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
