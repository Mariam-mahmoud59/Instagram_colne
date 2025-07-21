import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:instagram_clone/features/notifications/presentation/widgets/notification_item.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : null;
    return BlocProvider<NotificationBloc>(
      create: (_) => di.sl<NotificationBloc>()
        ..add(GetNotificationsEvent(userId: userId ?? '')),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: userId == null
            ? const Center(child: Text('You must be logged in.'))
            : BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) {
                      return const Center(child: Text('No notifications yet.'));
                    }
                    return ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return NotificationItem(notification: notification);
                      },
                    );
                  } else if (state is NotificationError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No notifications yet.'));
                },
              ),
      ),
    );
  }
}
