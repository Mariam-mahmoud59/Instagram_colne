// lib/features/feed/presentation/widgets/feed_stories_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/story/domain/entities/story.dart';
import 'package:instagram_clone/features/story/presentation/widgets/story_circles_widget.dart';
import 'package:instagram_clone/features/story/presentation/screens/story_view_screen.dart';
import 'package:instagram_clone/features/story/presentation/screens/create_story_screen.dart';
import 'package:instagram_clone/features/story/presentation/bloc/story_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;

class FeedStoriesBar extends StatelessWidget {
  final List<Story> stories = [
    Story(
      id: '1',
      userId: 'user1',
      username: 'Your Story',
      userProfileImageUrl:
          'https://via.placeholder.com/150/FF0000/FFFFFF?text=You',
      mediaUrl: 'https://example.com/story1.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
      isViewed: false,
    ),
    Story(
      id: '2',
      userId: 'user2',
      username: 'friend_one',
      userProfileImageUrl:
          'https://via.placeholder.com/150/0000FF/FFFFFF?text=F1',
      mediaUrl: 'https://example.com/story2.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
      isViewed: false,
    ),
    Story(
      id: '3',
      userId: 'user3',
      username: 'friend_two',
      userProfileImageUrl:
          'https://via.placeholder.com/150/00FF00/FFFFFF?text=F2',
      mediaUrl: 'https://example.com/story3.jpg',
      mediaType: 'video',
      items: [],
      lastUpdatedAt: DateTime.now(),
      isViewed: true,
    ),
    Story(
      id: '4',
      userId: 'user4',
      username: 'friend_three',
      userProfileImageUrl:
          'https://via.placeholder.com/150/FFFF00/000000?text=F3',
      mediaUrl: 'https://example.com/story4.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
      isViewed: false,
    ),
    Story(
      id: '5',
      userId: 'user5',
      username: 'friend_four',
      userProfileImageUrl:
          'https://via.placeholder.com/150/FF00FF/FFFFFF?text=F4',
      mediaUrl: 'https://example.com/story5.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
      isViewed: true,
    ),
  ];

  FeedStoriesBar({Key? key}) : super(key: key);

  void _openCreateStoryScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryBlocProvider(
          child: const CreateStoryScreen(),
        ),
      ),
    );
    // TODO: Reload stories from backend after upload
  }

  @override
  Widget build(BuildContext context) {
    return StoryCirclesWidget(
      stories: stories,
      onAddStoryTap: () => _openCreateStoryScreen(context),
      onStoryCircleTap: (userId) {
        final userStories = stories.where((s) => s.userId == userId).toList();
        if (userStories.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => StoryViewScreen(stories: userStories),
            ),
          );
        }
      },
    );
  }
}

class StoryBlocProvider extends StatelessWidget {
  final Widget child;
  const StoryBlocProvider({required this.child, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryBloc>(
      create: (_) => di.sl<StoryBloc>(),
      child: child,
    );
  }
}
