// lib/features/story/presentation/widgets/story_progress_indicator.dart

import 'package:flutter/material.dart';

class StoryProgressIndicator extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  const StoryProgressIndicator({
    Key? key,
    required this.progress,
    this.backgroundColor = Colors.white54,
    this.progressColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
    );
  }
}
