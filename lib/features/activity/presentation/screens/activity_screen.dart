import 'package:flutter/material.dart';
import 'package:instagram_clone/features/activity/data/activity_repository.dart';
import 'package:instagram_clone/features/activity/domain/entities/activity.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final borderColor = isDark ? Colors.white12 : Colors.black12;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          title: Text('Activity', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: textColor,
            unselectedLabelColor: subTextColor,
            tabs: const [
              Tab(text: 'Following'),
              Tab(text: 'You'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActivityTab(following: true, textColor: textColor, subTextColor: subTextColor, borderColor: borderColor),
            _ActivityTab(following: false, textColor: textColor, subTextColor: subTextColor, borderColor: borderColor),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}

class _ActivityTab extends StatefulWidget {
  final bool following;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  const _ActivityTab({required this.following, required this.textColor, required this.subTextColor, required this.borderColor});

  @override
  State<_ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<_ActivityTab> {
  late Future<List<Activity>> _futureActivities;

  @override
  void initState() {
    super.initState();
    _futureActivities = ActivityRepository().fetchActivities(following: widget.following);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Activity>>(
      future: _futureActivities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading activities'));
        }
        final activities = snapshot.data ?? [];
        // Group activities by section
        final sections = <String, List<Activity>>{};
        for (var activity in activities) {
          sections.putIfAbsent(activity.section, () => []).add(activity);
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const SizedBox(height: 8),
            Text('Follow Requests', style: TextStyle(fontWeight: FontWeight.bold, color: widget.textColor)),
            for (var section in sections.keys) ...[
              const SizedBox(height: 16),
              Text(section, style: TextStyle(fontWeight: FontWeight.bold, color: widget.textColor)),
              for (var activity in sections[section]!) _activityItem(activity, widget.textColor),
            ],
          ],
        );
      },
    );
  }

  Widget _activityItem(Activity activity, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(activity.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: activity.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' '),
                      TextSpan(text: activity.action),
                    ],
                    style: TextStyle(color: textColor),
                  ),
                ),
                if (activity.reply)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text('Reply', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ),
                Text(activity.time, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (activity.thumbnail != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(activity.thumbnail!, width: 44, height: 44, fit: BoxFit.cover),
              ),
            ),
          if (activity.button != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activity.button == 'Follow' ? Colors.blue : Colors.grey[300],
                  foregroundColor: activity.button == 'Follow' ? Colors.white : Colors.black,
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: Text(activity.button!),
              ),
            ),
        ],
      ),
    );
  }
}