import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:publicpatch/components/CustomNotification.dart';
import 'package:publicpatch/models/NotificationModel.dart';
import 'package:publicpatch/pages/report.dart';
import 'package:publicpatch/service/notification_ServiceStorage.dart';
import 'package:publicpatch/service/user_secure.dart';

class NotificationsPage extends StatefulWidget {
  final void Function() onMarkAllRead;
  final int unreadCount;

  const NotificationsPage(
      {super.key, required this.unreadCount, required this.onMarkAllRead});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int userId = -1;
  NotificationStorage _storage = NotificationStorage(userId: '');
  List<NotificationModel> notifications = [];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    userId = await UserSecureStorage.getUserId();
    _storage = NotificationStorage(userId: userId.toString());
    await _storage.init();
    _loadNotifications();
    _setupNotificationListener();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _setupNotificationListener() {
    final box = Hive.box<NotificationModel>(_storage.boxName);
    _subscription = box.watch().listen((event) {
      // Reload notifications when the box changes
      _loadNotifications();
    });
  }

  void _loadNotifications() {
    setState(() {
      notifications = _storage.getAllNotifications();
    });
  }

  Future<void> _onTap(String reportId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(reportId: int.parse(reportId)),
      ),
    );
  }

  Future<void> _onDismissed(NotificationModel notification) async {
    await _storage.deleteNotification(notification);
    // No need to call _loadNotifications() here as the watch() listener will handle it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Notifications'),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF0D0E15),
      body: notifications.isEmpty
          ? const Center(
              child: Text('No notifications',
                  style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return CustomNotification(
                  title: notification.title,
                  subtitle: notification.body,
                  icon: Icons.notifications,
                  time: notification.timestamp,
                  reportId: notification.reportId,
                  onTap: _onTap,
                  onDismissed: () => _onDismissed(notification),
                );
              },
            ),
    );
  }
}
