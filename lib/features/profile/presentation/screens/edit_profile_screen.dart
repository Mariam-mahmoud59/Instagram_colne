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
    _usernameController =
        TextEditingController(text: widget.currentProfile.username);
    _fullNameController =
        TextEditingController(text: widget.currentProfile.fullName);
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
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final borderColor = isDark ? Colors.white12 : Colors.black12;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
                Text('Edit Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor)),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile updated successfully!')),
                      );
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    } else if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Update failed: {state.message}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const SizedBox(
                          width: 48,
                          height: 24,
                          child: Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 2)));
                    }
                    return TextButton(
                      onPressed: _saveProfile,
                      child: Text('Done',
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (widget.currentProfile.profileImageUrl != null
                                ? CachedNetworkImageProvider(
                                    widget.currentProfile.profileImageUrl!)
                                : null) as ImageProvider?,
                        child: (_selectedImage == null &&
                                widget.currentProfile.profileImageUrl == null)
                            ? const Icon(Icons.person, size: 44)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.camera_alt,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Change Profile Photo',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: borderColor),
            const SizedBox(height: 8),
            _buildField('Name', _fullNameController, textColor),
            const SizedBox(height: 8),
            _buildField('Username', _usernameController, textColor,
                validator: (value) {
              if (value == null || value.isEmpty)
                return 'Username cannot be empty';
              return null;
            }),
            const SizedBox(height: 8),
            _buildField(
                'Website',
                TextEditingController(
                    text: widget.currentProfile.website ?? ''),
                textColor,
                enabled: false),
            const SizedBox(height: 8),
            _buildField('Bio', _bioController, textColor, maxLines: 2),
            const SizedBox(height: 8),
            Divider(color: borderColor),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text('Switch to Professional Account',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),
            Text('Private Information',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            _buildField(
                'Email',
                TextEditingController(text: widget.currentProfile.email ?? ''),
                textColor,
                enabled: false),
            const SizedBox(height: 8),
            _buildField(
                'Phone',
                TextEditingController(text: widget.currentProfile.phone ?? ''),
                textColor,
                enabled: false),
            const SizedBox(height: 8),
            _buildField(
                'Gender',
                TextEditingController(text: widget.currentProfile.gender ?? ''),
                textColor,
                enabled: false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, Color textColor,
      {bool enabled = true,
      int maxLines = 1,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor.withOpacity(0.2))),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor.withOpacity(0.1))),
      ),
    );
  }
}
