import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:instagram_clone/features/profile/domain/entities/profile.dart';
import 'package:instagram_clone/features/profile/domain/usecases/get_profile.dart';
import 'package:instagram_clone/features/profile/domain/usecases/update_profile.dart';
import 'dart:io';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<EditProfile>(_onEditProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getProfile(GetProfileParams(userId: event.userId));
    result.fold(
      (failure) => emit(ProfileError(
          failure.toString())), // Use failure.message or specific mapping
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onEditProfile(
      EditProfile event, Emitter<ProfileState> emit) async {
    // Optionally emit a ProfileUpdating state
    emit(ProfileLoading()); // Or ProfileUpdating()
    final result = await updateProfile(UpdateProfileParams(
      userId: event.userId,
      username: event.username,
      fullName: event.fullName,
      bio: event.bio,
      profileImage: event.profileImage,
    ));
    result.fold(
      (failure) => emit(ProfileError(
          failure.toString())), // Use failure.message or specific mapping
      (updatedProfile) => emit(ProfileLoaded(
          updatedProfile)), // Emit loaded state with updated profile
    );
  }
}
