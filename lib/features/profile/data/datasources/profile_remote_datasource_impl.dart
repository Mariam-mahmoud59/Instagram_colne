import 'dart:io';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:instagram_clone/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String profilesTable = 'profiles'; // Define table name
  static const String profileImagesBucket =
      'profile-images'; // Define storage bucket name

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from(profilesTable)
          .select('''
            id, 
            username, 
            full_name, 
            bio, 
            profile_image_url,
            followers:follows!follower_id(count),
            following:follows!following_id(count),
            posts(count)
          ''') // Fetch counts using relationships
          .eq('id', userId)
          .single();
      final followerCount =
          (response['followers'] as List?)?.first?['count'] ?? 0;
      final followingCount =
          (response['following'] as List?)?.first?['count'] ?? 0;
      final postCount = (response['posts'] as List?)?.first?['count'] ?? 0;

      return ProfileModel(
        id: response['id'] as String,
        username: response['username'] as String,
        fullName: response['full_name'] as String?,
        bio: response['bio'] as String?,
        profileImageUrl: response['profile_image_url'] as String?,
        followerCount: followerCount,
        followingCount: followingCount,
        postCount: postCount,
      );
    } on PostgrestException catch (e) {
      // Handle specific Supabase errors (e.g., profile not found)
      if (e.code == 'PGRST116') {
        // Resource Not Found
        throw ServerException(message: 'Profile not found for user $userId');
      }
      print('Supabase error getting profile: ${e.message}');
      throw ServerException(message: 'Failed to get profile: ${e.message}');
    } catch (e) {
      print('Unexpected error getting profile: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while fetching the profile.');
    }
  }

  @override
  Future<String?> uploadProfileImage(File image, String userId) async {
    try {
      final fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
      await supabaseClient.storage
          .from(profileImagesBucket)
          .upload(
            fileName,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Get the public URL
      final publicUrlResponse = supabaseClient.storage
          .from(profileImagesBucket)
          .getPublicUrl(fileName);

      return publicUrlResponse;
    } on StorageException catch (e) {
      print('Supabase storage error uploading profile image: ${e.message}');
      throw ServerException(
          message: 'Failed to upload profile image: ${e.message}');
    } catch (e) {
      print('Unexpected error uploading profile image: ${e.toString()}');
      throw ServerException(
          message:
              'An unexpected error occurred while uploading the profile image.');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? bio,
    File? profileImage,
  }) async {
    try {
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await uploadProfileImage(profileImage, userId);
        if (imageUrl == null) {
          throw ServerException(message: 'Failed to get uploaded image URL.');
        }
      }

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (fullName != null) updates['full_name'] = fullName;
      if (bio != null) updates['bio'] = bio;
      if (imageUrl != null) updates['profile_image_url'] = imageUrl;

      if (updates.isEmpty) {
        // If no actual data to update (only userId provided), just fetch current profile
        return await getProfile(userId);
      }

      // Update the profile table
      await supabaseClient.from(profilesTable).update(updates).eq('id', userId);

      // Fetch the updated profile to return it
      return await getProfile(userId);
    } on PostgrestException catch (e) {
      print('Supabase error updating profile: ${e.message}');
      throw ServerException(message: 'Failed to update profile: ${e.message}');
    } on ServerException catch (e) {
      // Catch exception from uploadProfileImage
      throw ServerException(message: e.message);
    } catch (e) {
      print('Unexpected error updating profile: ${e.toString()}');
      throw ServerException(
          message: 'An unexpected error occurred while updating the profile.');
    }
  }
}
