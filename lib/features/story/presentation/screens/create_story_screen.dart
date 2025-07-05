// lib/features/story/presentation/screens/create_story_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/story/presentation/bloc/story_bloc.dart';
import 'package:instagram_clone/features/common_widgets/loading_indicator.dart';
import 'package:instagram_clone/features/common_widgets/error_widget.dart';
import 'dart:io';
import 'package:instagram_clone/features/story/domain/entities/story.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = image;
    });
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _pickedFile = video;
    });
  }

  void _uploadStory() {
    if (_pickedFile != null) {
      context.read<StoryBloc>().add(CreateNewStoryItem(
            userId: 'currentUserId', // TODO: Replace with actual userId
            mediaFile: File(_pickedFile!.path),
            mediaType: StoryMediaType.image, // TODO: Detect type from file
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Story'),
        actions: [
          if (_pickedFile != null)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _uploadStory,
            ),
        ],
      ),
      body: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Story uploaded successfully!')),
            );
            Navigator.of(context).pop(); // Go back after successful upload
          } else if (state is StoryOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to upload story: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is StoryUploadInProgress) {
            return const LoadingIndicator();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_pickedFile == null)
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Image for Story'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _pickVideo,
                          child: const Text('Pick Video for Story'),
                        ),
                      ],
                    )
                  else
                    // Display selected image/video thumbnail (simplified)
                    Text('File selected: ${_pickedFile!.name}'),
                  const SizedBox(height: 20),
                  if (state is StoryOperationFailure)
                    CustomErrorWidget(
                        message: state.message, onRetry: () => _uploadStory()),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
