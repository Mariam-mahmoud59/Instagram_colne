// lib/features/profile/presentation/widgets/profile_stats.dart

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onPostsTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const ProfileStats({
    Key? key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.onPostsTap,
    this.onFollowersTap,
    this.onFollowingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(context, 'Posts', postsCount, onPostsTap),
        _buildStatColumn(context, 'Followers', followersCount, onFollowersTap),
        _buildStatColumn(context, 'Following', followingCount, onFollowingTap),
      ],
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, int count, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
