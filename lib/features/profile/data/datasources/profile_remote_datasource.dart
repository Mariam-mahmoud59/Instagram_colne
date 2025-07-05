import 'dart:io';
import 'package:instagram_clone/features/profile/data/models/profile_model.dart'; // To be created

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<ProfileModel> updateProfile({
    required String userId,
    String? username,
    String? fullName,
    String? bio,
    File? profileImage,
  });
  Future<String?> uploadProfileImage(File image, String userId);
}

