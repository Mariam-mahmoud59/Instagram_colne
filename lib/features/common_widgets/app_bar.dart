// lib/features/common_widgets/app_bar.dart

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/explore/presentation/screens/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final bool showDefaultActions;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.showDefaultActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultActions = [
      IconButton(
        icon: const Icon(Icons.notifications_none),
        onPressed: () {
          // TODO: Implement notifications navigation
        },
      ),
      IconButton(
        icon: const Icon(Icons.send_outlined),
        onPressed: () {
          // TODO: Implement messages navigation
        },
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
      ),
    ];

    return AppBar(
      title: Text(
        title ?? 'Instagram',
        style: const TextStyle(
          fontFamily: 'Billabong',
          fontSize: 32,
          color: Colors.black,
        ),
      ),
      centerTitle: centerTitle,
      actions: showDefaultActions
          ? (actions != null
              ? [...actions!, ...defaultActions]
              : defaultActions)
          : actions,
      leading: leading,
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: Theme.of(context).appBarTheme.iconTheme,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
