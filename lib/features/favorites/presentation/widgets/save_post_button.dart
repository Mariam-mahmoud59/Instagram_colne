import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/di/injection_container.dart';
import 'package:instagram_clone/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

class SavePostButton extends StatefulWidget {
  final String userId;
  final String postId;
  final Post post;

  const SavePostButton({
    Key? key,
    required this.userId,
    required this.postId,
    required this.post,
  }) : super(key: key);

  @override
  State<SavePostButton> createState() => _SavePostButtonState();
}

class _SavePostButtonState extends State<SavePostButton> {
  late FavoriteBloc _favoriteBloc;
  bool _isSaved = false;
  String? _favoriteId;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = sl<FavoriteBloc>();
    _checkSavedStatus();
  }

  void _checkSavedStatus() {
    _favoriteBloc.add(CheckPostSavedEvent(
      userId: widget.userId,
      postId: widget.postId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteBloc, FavoriteState>(
      bloc: _favoriteBloc,
      listener: (context, state) {
        if (state is PostSavedStatusChecked) {
          setState(() {
            _isSaved = state.isSaved;
          });
        } else if (state is PostSaved) {
          setState(() {
            _isSaved = true;
            _favoriteId = state.favorite.id;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post saved')),
          );
        } else if (state is PostUnsaved) {
          setState(() {
            _isSaved = false;
            _favoriteId = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post removed from saved')),
          );
        } else if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            _isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: _isSaved ? Colors.black : null,
          ),
          onPressed: () {
            if (_isSaved && _favoriteId != null) {
              _favoriteBloc.add(UnsavePostEvent(favoriteId: _favoriteId!));
            } else {
              _favoriteBloc.add(SavePostEvent(
                userId: widget.userId,
                postId: widget.postId,
              ));
            }
          },
        );
      },
    );
  }
}
