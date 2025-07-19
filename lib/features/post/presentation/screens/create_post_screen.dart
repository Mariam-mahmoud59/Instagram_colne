import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart'; // For PostType
import 'package:instagram_clone/features/post/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;
import 'package:video_player/video_player.dart'; // For video preview
import 'package:instagram_clone/features/common_widgets/app_bar.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => di.sl<PostBloc>(),
      child: _CreatePostScreenContent(),
    );
  }
}

class _CreatePostScreenContent extends StatefulWidget {
  const _CreatePostScreenContent();

  @override
  State<_CreatePostScreenContent> createState() =>
      _CreatePostScreenContentState();
}

class _CreatePostScreenContentState extends State<_CreatePostScreenContent> {
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedMedia = [];
  PostType _postType = PostType.image; // Default to image
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    if (isVideo) {
      final XFile? video = await _picker.pickVideo(source: source);
      if (video != null) {
        setState(() {
          _selectedMedia = [video];
          _postType = PostType.video;
          _initializeVideoPlayer(video.path);
        });
      }
    } else {
      // Allow picking multiple images
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedMedia = images;
          _postType = PostType.image;
          _videoController
              ?.dispose(); // Dispose video controller if switching from video
          _videoController = null;
        });
      }
    }
  }

  void _initializeVideoPlayer(String path) {
    _videoController?.dispose(); // Dispose previous controller if any
    _videoController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {}); // Update UI when initialized
        _videoController?.play();
        _videoController?.setLooping(true);
      });
  }

  void _uploadPost() {
    final currentUserState = context.read<AuthBloc>().state;
    if (currentUserState is Authenticated && _selectedMedia.isNotEmpty) {
      final userId = currentUserState.user.id;
      context.read<PostBloc>().add(CreateNewPost(
            authorId: userId,
            type: _postType,
            mediaFiles:
                _selectedMedia.map((xfile) => File(xfile.path)).toList(),
            description: _descriptionController.text.trim(),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select media and ensure you are logged in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Media Preview Area
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: _buildMediaPreview(),
            ),
            const SizedBox(height: 16),
            // Media Selection Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery (Image)'),
                  onPressed: _isUploading
                      ? null
                      : () => _pickMedia(ImageSource.gallery, isVideo: false),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.videocam),
                  label: const Text('Gallery (Video)'),
                  onPressed: _isUploading
                      ? null
                      : () => _pickMedia(ImageSource.gallery, isVideo: true),
                ),
                // Add Camera buttons if needed
              ],
            ),
            const SizedBox(height: 16),
            // Description TextField
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              enabled: !_isUploading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedMedia.isEmpty) {
      return const Center(child: Text('Select media to preview'));
    }

    if (_postType == PostType.video &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (_postType == PostType.video) {
      // Video initializing
      return const Center(child: CircularProgressIndicator());
    } else {
      // Image preview (handles multiple images)
      // For simplicity, showing the first image. Enhance this for multi-image carousel.
      return Image.file(
        File(_selectedMedia.first.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text('Error loading image')),
      );
      // TODO: Implement a PageView or similar for multiple images
    }
  }
}
