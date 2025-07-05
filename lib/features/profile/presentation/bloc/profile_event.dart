part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class EditProfile extends ProfileEvent {
  final String userId;
  final String? username;
  final String? fullName;
  final String? bio;
  final File? profileImage;

  const EditProfile({
    required this.userId,
    this.username,
    this.fullName,
    this.bio,
    this.profileImage,
  });

  @override
  List<Object?> get props => [userId, username, fullName, bio, profileImage];
}

