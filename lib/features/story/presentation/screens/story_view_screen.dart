// lib/features/story/presentation/screens/story_view_screen.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/story/domain/entities/story.dart';
import 'package:instagram_clone/features/story/presentation/widgets/story_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryViewScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialStoryIndex;

  const StoryViewScreen({
    Key? key,
    required this.stories,
    this.initialStoryIndex = 0,
  }) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentStoryIndex;
  VideoPlayerController? _videoController;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialStoryIndex;
    _pageController = PageController(initialPage: _currentStoryIndex);
    _loadStory(index: _currentStoryIndex);
  }

  void _loadStory({int? index, bool isNewStory = false}) {
    final story = widget.stories[index ?? _currentStoryIndex];

    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }
    _animationController?.stop();
    _animationController?.dispose();

    if (story.mediaType == 'video') {
      _videoController = VideoPlayerController.networkUrl(
          Uri.parse(story.mediaUrl ?? ''))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
          _startProgressAnimation(duration: _videoController!.value.duration);
        });
    } else {
      _startProgressAnimation(
          duration: const Duration(seconds: 5)); // Default for images
    }

    // Mark story as viewed
    if (isNewStory) {
      // TODO: Add story viewed event when bloc is properly implemented
      // context.read<StoryBloc>().add(MarkStoryAsViewedEvent(storyId: story.id));
    }
  }

  void _startProgressAnimation({required Duration duration}) {
    _animationController = AnimationController(vsync: this, duration: duration)
      ..addListener(() {
        setState(() {});
      })
      ..forward().whenComplete(() {
        _nextStory();
      });
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.of(context).pop(); // All stories viewed
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _animationController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          if (details.globalPosition.dx <
              MediaQuery.of(context).size.width / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStoryIndex = index;
                });
                _loadStory(index: index, isNewStory: true);
              },
              itemBuilder: (context, index) {
                final currentStory = widget.stories[index];
                return Center(
                  child: currentStory.mediaType == 'video'
                      ? _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : const CircularProgressIndicator() // Video loading indicator
                      : CachedNetworkImage(
                          imageUrl: currentStory.mediaUrl ?? '',
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                );
              },
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: StoryProgressIndicator(
                progress: _animationController?.value ?? 0.0,
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        story.userProfileImageUrl ?? ''),
                  ),
                  const SizedBox(width: 8),
                  Text(story.username ?? 'Unknown',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('${story.timestamp?.hour ?? 0}h',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Positioned(
              top: 60,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
