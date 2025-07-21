// lib/core/constants/supabase_constants.dart

class SupabaseConstants {
  // Supabase Project URL
  // IMPORTANT: Replace with your actual Supabase Project URL
  static const String supabaseUrl = 'https://zcoucxuepybjcrwqpojx.supabase.co'; 
 

  // Supabase Anon Key
  // IMPORTANT: Replace with your actual Supabase Anon Key
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpjb3VjeHVlcHliamNyd3Fwb2p4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzA5NDExNCwiZXhwIjoyMDY4NjcwMTE0fQ.FIpNYPGf0UElua7tQxGqlDbpBG0tRjLmY5gT_CZvHfQ'; 
  // Example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzgwMDc2NzcsImV4cCI6MTk5MzU4MzY3N30.YOUR_ANON_KEY_HERE'

  // Supabase Table Names (examples - adjust based on your database schema )
  static const String usersTable = 'users';
  static const String postsTable = 'posts';
  static const String commentsTable = 'comments';
  static const String likesTable = 'likes';
  static const String followersTable = 'followers';
  static const String notificationsTable = 'notifications';
  static const String chatsTable = 'chats';
  static const String messagesTable = 'messages';
  static const String storiesTable = 'stories';
  static const String savedPostsTable = 'saved_posts';

  // Supabase Storage Buckets (examples - adjust based on your storage setup)
  static const String profilePicturesBucket = 'profile_pictures';
  static const String postImagesBucket = 'post_images';
  static const String postVideosBucket = 'post_videos';
  static const String storyMediaBucket = 'story_media';
}
