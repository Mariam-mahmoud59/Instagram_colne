import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => di.sl<PostBloc>(),
      child: const _CreatePostScreenContent(),
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
  final PageController _pageController = PageController();

  List<XFile> _selectedMedia = [];
  PostType _postType = PostType.image;
  VideoPlayerController? _videoController;
  bool _isUploading = false;
  int _currentMediaIndex = 0;

  @override
  void dispose() {
    _descriptionController.dispose();
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    if (isVideo) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedMedia = [video];
          _postType = PostType.video;
          _currentMediaIndex = 0;
          _initializeVideoPlayer(video.path);
        });
      }
    } else {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedMedia = images;
          _postType = PostType.image;
          _currentMediaIndex = 0;
          _videoController?.dispose();
          _videoController = null;
        });
      }
    }
  }

  void _initializeVideoPlayer(String path) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        _videoController?.play();
        _videoController?.setLooping(true);
      });
  }

  void _uploadPost() {
    if (_selectedMedia.isEmpty) {
      _showSnackBar('Please select an image or video first.', isError: true);
      return;
    }

    final currentUserState = context.read<AuthBloc>().state;
    if (currentUserState is Authenticated) {
      final userId = currentUserState.user.id;
      context.read<PostBloc>().add(CreateNewPost(
            authorId: userId,
            type: _postType,
            mediaFiles:
                _selectedMedia.map((xfile) => File(xfile.path)).toList(),
            description: _descriptionController.text.trim(),
          ));
    }
  }

  void _resetState() {
    setState(() {
      _selectedMedia.clear();
      _descriptionController.clear();
      _videoController?.dispose();
      _videoController = null;
      _isUploading = false;
      _currentMediaIndex = 0;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostUploading) {
          setState(() => _isUploading = true);
        } else if (state is PostUploadSuccess) {
          _showSnackBar('Post created successfully!');
          _resetState();
          Navigator.of(context).pop(); // العودة للشاشة السابقة بعد النجاح
        } else if (state is PostOperationFailure) {
          _showSnackBar('Failed to create post: ${state.message}',
              isError: true);
          setState(() => _isUploading = false);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 24),
        onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'New post',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: TextButton(
            onPressed:
                _isUploading || _selectedMedia.isEmpty ? null : _uploadPost,
            style: TextButton.styleFrom(
              backgroundColor: _isUploading || _selectedMedia.isEmpty
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              _isUploading ? 'Sharing...' : 'Share',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isUploading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              'Sharing your post...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildCaptionSection(),
        const Divider(height: 1, color: Color(0xFFDBDBDB)),
        Expanded(
          child: _buildMediaPreview(),
        ),
        if (_selectedMedia.isNotEmpty) _buildMediaIndicator(),
        const Divider(height: 1, color: Color(0xFFDBDBDB)),
        _buildMediaSelectionButtons(),
      ],
    );
  }

  Widget _buildCaptionSection() {
    final currentUserState = context.read<AuthBloc>().state;
    String? profileImageUrl;
    String username = 'User';

    if (currentUserState is Authenticated) {
      // تأكد من وجود هذه الحقول في UserEntity
      // profileImageUrl = currentUserState.user.profilePictureUrl;
      // username = currentUserState.user.username ?? 'User';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl) as ImageProvider
                    : null,
            child: profileImageUrl == null || profileImageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (_selectedMedia.isNotEmpty)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: _postType == PostType.image
                    ? Image.file(
                        File(_selectedMedia[0].path),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.black,
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedMedia.isEmpty) {
      return GestureDetector(
        onTap: () => _showMediaSelectionDialog(),
        child: Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Tap to select photos or videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You can select multiple photos',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_postType == PostType.video &&
        _videoController?.value.isInitialized == true) {
      return Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Video',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_postType == PostType.image) {
      return PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentMediaIndex = index;
          });
        },
        itemCount: _selectedMedia.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(_selectedMedia[index].path),
            fit: BoxFit.contain,
          );
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildMediaIndicator() {
    if (_selectedMedia.length <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _selectedMedia.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  index == _currentMediaIndex ? Colors.blue : Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFDBDBDB), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _pickMedia(isVideo: false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickMedia(isVideo: true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Photos from Gallery'),
              subtitle: const Text('Select one or multiple photos'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.blue),
              title: const Text('Video from Gallery'),
              subtitle: const Text('Select a video file'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(isVideo: true);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
