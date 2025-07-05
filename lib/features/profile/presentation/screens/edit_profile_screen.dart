import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile.dart';
import 'package:instagram_clone/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile currentProfile;

  const EditProfileScreen({required this.currentProfile, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _bioController;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentProfile.username);
    _fullNameController = TextEditingController(text: widget.currentProfile.fullName);
    _bioController = TextEditingController(text: widget.currentProfile.bio);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            EditProfile(
              userId: widget.currentProfile.id,
              username: _usernameController.text.trim(),
              fullName: _fullNameController.text.trim(),
              bio: _bioController.text.trim(),
              profileImage: _selectedImage, // Pass the selected file
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                // Optionally show success message and pop
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
                // Pop after successful update
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                // Show loading indicator instead of save button
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return IconButton(
                icon: const Icon(Icons.check),
                onPressed: _saveProfile,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) // Show selected image preview
                          : (widget.currentProfile.profileImageUrl != null
                              ? CachedNetworkImageProvider(widget.currentProfile.profileImageUrl!)
                              : null) as ImageProvider?,
                      child: (_selectedImage == null && widget.currentProfile.profileImageUrl == null)
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Text('Change Profile Photo'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  // Add more specific username validation if needed (e.g., characters, length)
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Name'),
                // No validation needed for optional field, or add length limits etc.
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                // No validation needed for optional field, or add length limits etc.
              ),
            ],
          ),
        ),
      ),
    );
  }
}

