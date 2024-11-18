// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:publicpatch/components/CustomNotification.dart';

class NotificationsPage extends StatefulWidget {
  final void Function() onMarkAllRead;
  final int unreadCount;

  const NotificationsPage(
      {super.key, required this.unreadCount, required this.onMarkAllRead});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future _onDismissed() async {
    //ask for confirmation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: Icon(Icons.mark_chat_read),
              color: Colors.white,
              onPressed: widget.unreadCount > 0 ? widget.onMarkAllRead : null,
              disabledColor: const Color(0xFF1B1D29),
            ),
          ],
          backgroundColor: const Color(0XFF0D0E15),
          titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: const Color(0XFF0D0E15),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(134, 54, 60, 73),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            ListView.separated(
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (BuildContext context, int index) {
                return CustomNotification(
                  title: 'Notification Title',
                  subtitle: 'Notification Subtitle',
                  icon: Icons.notifications,
                  time: DateTime.now(),
                  onDismissed: _onDismissed,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Color(0xFF1B1D29),
                  thickness: 1,
                );
              },
              itemCount: 10,
            ),
          ],
        ));
  }
}
