import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart';
import 'package:instagram_clone/features/post/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/features/post/presentation/screens/video_explore_screen.dart';

class VideoExploreTab extends StatelessWidget {
  const VideoExploreTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostBloc>(),
      child: const VideoExploreScreen(),
    );
  }
}
