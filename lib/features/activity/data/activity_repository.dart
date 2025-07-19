import 'package:instagram_clone/features/activity/domain/entities/activity.dart';

class ActivityRepository {
  Future<List<Activity>> fetchActivities({required bool following}) async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Activity(
        avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
        username: 'karenne',
        action: 'liked your photo.',
        time: '1h',
        thumbnail:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        section: 'New',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
        username: 'kiero_d, zackjohn and 26 others',
        action: 'liked your photo.',
        time: '3h',
        thumbnail:
            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
        section: 'Today',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
        username: 'craig_love',
        action: 'mentioned you in a comment: @jacob_w exactly..',
        time: '2d',
        reply: true,
        section: 'This Week',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
        username: 'martini_rond',
        action: 'started following you.',
        time: '3d',
        button: 'Message',
        section: 'This Week',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
        username: 'maxjacobson',
        action: 'started following you.',
        time: '3d',
        button: 'Message',
        section: 'This Week',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/women/6.jpg',
        username: 'mis_potter',
        action: 'started following you.',
        time: '3d',
        button: 'Follow',
        section: 'This Week',
      ),
      Activity(
        avatar: 'https://randomuser.me/api/portraits/men/7.jpg',
        username: 'dr_humphrey',
        action: 'started following you.',
        time: '3w',
        section: 'This Month',
      ),
    ];
  }
}
