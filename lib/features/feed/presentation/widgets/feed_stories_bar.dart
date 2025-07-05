// lib/features/feed/presentation/widgets/feed_stories_bar.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/common_widgets/user_avatar.dart'; // Assuming UserAvatar is defined
import 'package:instagram_clone/features/story/domain/entities/story.dart'; // Assuming Story entity is defined

class FeedStoriesBar extends StatelessWidget {
  // This list would typically come from a Bloc/Cubit that fetches stories
  final List<Story> stories = [
    // Example Story data (replace with actual data from your bloc)
    Story(
      id: '1',
      userId: 'user1',
      username: 'Your Story',
      userProfilePictureUrl:
          'https://via.placeholder.com/150/FF0000/FFFFFF?text=You', // Placeholder for current user
      mediaUrl: 'https://example.com/story1.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
    ),
    Story(
      id: '2',
      userId: 'user2',
      username: 'friend_one',
      userProfilePictureUrl:
          'https://via.placeholder.com/150/0000FF/FFFFFF?text=F1',
      mediaUrl: 'https://example.com/story2.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
    ),
    Story(
      id: '3',
      userId: 'user3',
      username: 'friend_two',
      userProfilePictureUrl:
          'https://via.placeholder.com/150/00FF00/FFFFFF?text=F2',
      mediaUrl: 'https://example.com/story3.jpg',
      mediaType: 'video',
      items: [],
      lastUpdatedAt: DateTime.now(),
    ),
    Story(
      id: '4',
      userId: 'user4',
      username: 'friend_three',
      userProfilePictureUrl:
          'https://via.placeholder.com/150/FFFF00/000000?text=F3',
      mediaUrl: 'https://example.com/story4.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
    ),
    Story(
      id: '5',
      userId: 'user5',
      username: 'friend_four',
      userProfilePictureUrl:
          'https://via.placeholder.com/150/FF00FF/FFFFFF?text=F4',
      mediaUrl: 'https://example.com/story5.jpg',
      mediaType: 'image',
      items: [],
      lastUpdatedAt: DateTime.now(),
    ),
  ];

  FeedStoriesBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Height for the stories bar
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to story view screen
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryViewScreen(storyId: story.id)));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Story ring (placeholder for unviewed stories)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(2.0), // Padding for the ring
                        child: UserAvatar(
                          imageUrl: story.userProfilePictureUrl ?? '',
                          radius:
                              30, // Slightly smaller than container for ring effect
                        ),
                      ),
                      if (index == 0) // "Your Story" with add icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 2),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  story.username ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
