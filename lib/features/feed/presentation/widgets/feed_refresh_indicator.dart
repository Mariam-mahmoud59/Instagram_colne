// lib/features/feed/presentation/widgets/feed_refresh_indicator.dart

import 'package:flutter/material.dart';

class FeedRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const FeedRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).primaryColor, // Color of the refresh indicator
      backgroundColor: Theme.of(context).colorScheme.surface, // Background color of the indicator
      child: child,
    );
  }
}
