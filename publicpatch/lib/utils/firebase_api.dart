import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:publicpatch/main.dart';
import 'package:publicpatch/pages/report.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification}');
  debugPrint('Message notification title: ${message.notification?.title}');
}

class FirebaseApi {
  final _firebaseMessage = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'publicpatch',
    'Public Patch',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    debugPrint(message.data.toString());
    navigatorKey.currentState
        ?.pushNamed(ReportPage.route, arguments: message.data);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: 'launch_background',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('launch_background');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: (details) =>
            handleMessage(RemoteMessage.fromMap(jsonDecode(details.payload!))));
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!;
    await platform.createNotificationChannel(_androidChannel);
  }

  Future<void> initialize() async {
    await _firebaseMessage.requestPermission();
    final fcmToken = await _firebaseMessage.getToken();
    print('FCM Token: $fcmToken');
    initPushNotifications();
    initLocalNotifications();
  }
}
