import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/bloc/post_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoExploreScreen extends StatefulWidget {
  const VideoExploreScreen({Key? key}) : super(key: key);

  @override
  State<VideoExploreScreen> createState() => _VideoExploreScreenState();
}

class _VideoExploreScreenState extends State<VideoExploreScreen> {
  String _formatDate(DateTime date) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month]} ${date.day}';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    // Load initial video posts
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      context.read<PostBloc>().add(const LoadVideoExplorePosts(limit: 5));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all video controllers
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeVideoController(int index, String videoUrl) {
    if (_videoControllers.containsKey(index)) return;

    final controller = VideoPlayerController.network(videoUrl);
    _videoControllers[index] = controller;

    controller.initialize().then((_) {
      // Start playing if this is the current visible video
      if (_currentPage == index) {
        controller.play();
        controller.setLooping(true);
      }
      // Force a rebuild to show the initialized video
      if (mounted) setState(() {});
    });
  }

  void _onPageChanged(int page) {
    // Pause the previous video
    if (_videoControllers.containsKey(_currentPage)) {
      _videoControllers[_currentPage]!.pause();
    }

    // Play the current video
    if (_videoControllers.containsKey(page)) {
      _videoControllers[page]!.play();
      _videoControllers[page]!.setLooping(true);
    }

    setState(() {
      _currentPage = page;
    });

    // Load more videos when approaching the end
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null && page >= _videoControllers.length - 2) {
      context.read<PostBloc>().add(
            LoadVideoExplorePosts(
              limit: 5,
              offset: _videoControllers.length,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is VideoExplorePostsLoaded) {
            // Initialize video controllers for new videos
            for (int i = 0; i < state.posts.length; i++) {
              if (state.posts[i].type == PostType.video &&
                  state.posts[i].mediaUrls.isNotEmpty) {
                _initializeVideoController(i, state.posts[i].mediaUrls.first);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is PostsLoading && _videoControllers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is PostsLoadFailure) {
            return Center(
              child: Text(
                'Failed to load videos: ${state.message}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          List<Post> posts = [];
          if (state is VideoExplorePostsLoaded) {
            posts = state.posts
                .where((post) => post.type == PostType.video)
                .toList();
          }

          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No videos available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Video Player
                      _videoControllers.containsKey(index) &&
                              _videoControllers[index]!.value.isInitialized
                          ? GestureDetector(
                              onTap: () {
                                if (_videoControllers[index]!.value.isPlaying) {
                                  _videoControllers[index]!.pause();
                                } else {
                                  _videoControllers[index]!.play();
                                }
                                setState(() {});
                              },
                              child: VideoPlayer(_videoControllers[index]!),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),

                      // Video Controls Overlay
                      if (_videoControllers.containsKey(index) &&
                          !_videoControllers[index]!.value.isPlaying)
                        Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),

                      // Video Info Overlay (top)
                      Positioned(
                        top: 40,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    post.description != null &&
                                            post.description!.isNotEmpty
                                        ? post.description!.split('\n').first
                                        : 'Video Title',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage:
                                      post.author?.profileImageUrl != null
                                          ? NetworkImage(
                                              post.author!.profileImageUrl!)
                                          : null,
                                  child: post.author?.profileImageUrl == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  post.author?.username ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  child: const Text('Follow'),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  post.createdAt != null
                                      ? _formatDate(post.createdAt!)
                                      : 'Sep 13',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Views and comments count (bottom left)
                      Positioned(
                        left: 16,
                        bottom: 60,
                        child: Row(
                          children: [
                            Text(
                              '${post.likeCount + 37256} views',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${post.commentCount} comments',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      // Up Next button (bottom right)
                      Positioned(
                        right: 16,
                        bottom: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.15),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: const Text('Up Next'),
                        ),
                      ),

                      // Video progress bar and duration (bottom)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 24,
                        child: _videoControllers.containsKey(index) &&
                                _videoControllers[index]!.value.isInitialized
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: _videoControllers[index]!
                                          .value
                                          .position
                                          .inSeconds
                                          .toDouble(),
                                      min: 0,
                                      max: _videoControllers[index]!
                                          .value
                                          .duration
                                          .inSeconds
                                          .toDouble(),
                                      onChanged: (value) {
                                        _videoControllers[index]!.seekTo(
                                            Duration(seconds: value.toInt()));
                                        setState(() {});
                                      },
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white24,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Text(
                                      _formatDuration(_videoControllers[index]!
                                              .value
                                              .position) +
                                          ' / ' +
                                          _formatDuration(
                                              _videoControllers[index]!
                                                  .value
                                                  .duration),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      // ...existing code...

                      // Action Buttons
                      Positioned(
                        right: 10,
                        bottom: 80,
                        child: Column(
                          children: [
                            // Like Button
                            IconButton(
                              icon: Icon(
                                post.isLikedByCurrentUser
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.isLikedByCurrentUser
                                    ? Colors.red
                                    : Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                final currentUser =
                                    Supabase.instance.client.auth.currentUser;
                                if (currentUser != null) {
                                  if (post.isLikedByCurrentUser) {
                                    context.read<PostBloc>().add(
                                          UnlikePostEvent(
                                            postId: post.id,
                                            userId: currentUser.id,
                                          ),
                                        );
                                  } else {
                                    context.read<PostBloc>().add(
                                          LikePostEvent(
                                            postId: post.id,
                                            userId: currentUser.id,
                                          ),
                                        );
                                  }
                                }
                              },
                            ),
                            Text(
                              '${post.likeCount}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),

                            // Comment Button
                            IconButton(
                              icon: const Icon(
                                Icons.comment,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                // Open comments
                              },
                            ),
                            Text(
                              '${post.commentCount}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),

                            // Share Button
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                // Share video
                              },
                            ),
                            const Text(
                              'Share',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Top Navigation Bar
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          // Navigate to create video post
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
