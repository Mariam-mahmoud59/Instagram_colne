// lib/features/post/presentation/screens/post_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/presentation/bloc/post_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPostDetail(postId: widget.postId));
  }

  void GetPostDetail() {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostDetailLoaded) {
          final post = state.post;
          return Scaffold(
            appBar: AppBar(title: Text('Post Detail')),
            body: Center(child: Text('Post ID: \\${post.id}')),
          );
        } else if (state is PostDetailFailure) {
          return Scaffold(
            appBar: AppBar(title: Text('Post Detail')),
            body: Center(child: Text(state.message)),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Post Detail')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
