// lib/features/common_widgets/user_avatar.dart

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 20.0, // Default radius
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2), // Light background
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Icon(
                Icons.person,
                size: radius * 1.2, // Icon size relative to radius
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }
}
