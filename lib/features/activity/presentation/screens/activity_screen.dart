import 'package:flutter/material.dart';
import 'package:instagram_clone/features/activity/data/activity_repository.dart';
import 'package:instagram_clone/features/activity/domain/entities/activity.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFFAFAFA),
        appBar: _buildModernAppBar(context, isDark),
        body: TabBarView(
          children: [
            _ActivityTab(following: true, isDark: isDark),
            _ActivityTab(following: false, isDark: isDark),
          ],
        ),
        bottomNavigationBar: _buildModernBottomNav(isDark),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        'Activity',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: -0.5,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF262626) : const Color(0xFFDBDBDB),
                width: 0.5,
              ),
            ),
          ),
          child: TabBar(
            indicatorColor: const Color(0xFF0095F6),
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: isDark ? Colors.white : Colors.black,
            unselectedLabelColor: isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: 'Following'),
              Tab(text: 'You'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF000000) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFDBDBDB),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.home_outlined, isDark),
              _buildNavIcon(Icons.search_outlined, isDark),
              _buildNavIcon(Icons.add_box_outlined, isDark),
              _buildNavIcon(Icons.favorite_outline, isDark, isActive: true),
              _buildNavIcon(Icons.account_circle_outlined, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isDark, {bool isActive = false}) {
    return Icon(
      icon,
      size: 26,
      color: isActive 
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E)),
    );
  }
}

class _ActivityTab extends StatefulWidget {
  final bool following;
  final bool isDark;
  
  const _ActivityTab({required this.following, required this.isDark});

  @override
  State<_ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<_ActivityTab> with TickerProviderStateMixin {
  late Future<List<Activity>> _futureActivities;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _futureActivities = ActivityRepository().fetchActivities(following: widget.following);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Activity>>(
      future: _futureActivities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        if (snapshot.hasError) {
          return _buildErrorState();
        }
        final activities = snapshot.data ?? [];
        return _buildActivityList(activities);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: widget.isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load activities',
            style: TextStyle(
              color: widget.isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _futureActivities = ActivityRepository().fetchActivities(following: widget.following);
              });
            },
            child: const Text(
              'Try again',
              style: TextStyle(
                color: Color(0xFF0095F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(List<Activity> activities) {
    // Group activities by section
    final sections = <String, List<Activity>>{};
    for (var activity in activities) {
      sections.putIfAbsent(activity.section, () => []).add(activity);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              if (!widget.following) ...[
                const SizedBox(height: 8),
                _buildSectionHeader('Follow Requests'),
                const SizedBox(height: 12),
              ],
              for (var section in sections.keys) ...[
                if (section != 'Follow Requests') ...[
                  const SizedBox(height: 24),
                  _buildSectionHeader(section),
                  const SizedBox(height: 12),
                ],
                ...sections[section]!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final activity = entry.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 100 + (index * 50)),
                    curve: Curves.easeOutCubic,
                    child: _buildActivityItem(activity),
                  );
                }).toList(),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: widget.isDark ? Colors.white : Colors.black,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(activity),
          const SizedBox(width: 12),
          Expanded(child: _buildActivityContent(activity)),
          if (activity.thumbnail != null) _buildThumbnail(activity.thumbnail!),
          if (activity.button != null) _buildActionButton(activity.button!),
        ],
      ),
    );
  }

  Widget _buildAvatar(Activity activity) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF0095F6),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(activity.avatar),
      ),
    );
  }

  Widget _buildActivityContent(Activity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: activity.username,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              TextSpan(
                text: ' ${activity.action}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (activity.reply) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Reply',
              style: TextStyle(
                color: widget.isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          activity.time,
          style: TextStyle(
            color: widget.isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(String thumbnail) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF),
              width: 0.5,
            ),
          ),
          child: Image.network(
            thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: widget.isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
                child: Icon(
                  Icons.image_outlined,
                  color: widget.isDark ? const Color(0xFF8E8E8E) : const Color(0xFF8E8E8E),
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String buttonText) {
    final isFollowButton = buttonText == 'Follow';
    
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Handle button action
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isFollowButton 
                ? const Color(0xFF0095F6)
                : (widget.isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFollowButton 
                  ? const Color(0xFF0095F6)
                  : (widget.isDark ? const Color(0xFF363636) : const Color(0xFFDBDBDB)),
                width: 1,
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: isFollowButton 
                  ? Colors.white
                  : (widget.isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

