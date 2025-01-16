import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:publicpatch/main.dart';
import 'package:publicpatch/models/GetTokenModel.dart';
import 'package:publicpatch/models/NotificationModel.dart';
import 'package:publicpatch/models/SaveToken.dart';
import 'package:publicpatch/pages/report.dart';
import 'package:publicpatch/service/fcmToken_Service.dart';
import 'package:publicpatch/service/notification_ServiceStorage.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
  handleMessageBackground(message);
}

@pragma('vm:entry-point')
void handleMessageBackground(RemoteMessage message) {
  debugPrint('Handling background message tap: ${message.data}');
  // Note: Navigation should be handled when app is brought to foreground
}

class FirebaseApi {
  final NotificationStorage _storage;
  FirebaseApi({required String userId})
      : _storage = NotificationStorage(userId: userId);
  final _firebaseMessage = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'publicpatch',
    'Public Patch',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializeHive() async {
    await _storage.init();
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) {
      debugPrint('Message is null');
      return;
    }
    if (message.data['stored'] != 'true') {
      debugPrint('Handling message: ${message.data}');
      final notification = NotificationModel(
        title: message.notification?.title ?? 'Public Patch',
        body: message.notification?.body ?? '',
        isRead: false,
        reportId: message.data['reportId']?.toString() ?? '',
        timestamp: DateTime.now(),
      );
      if (!Hive.isBoxOpen(_storage.boxName)) {
        await Hive.openBox<NotificationModel>(_storage.boxName);
      }
      await _storage.saveNotification(notification);
    }
    final data = message.data;

    if (data['reportId'] != null) {
      if (navigatorKey.currentState != null) {
        final route = ReportPage(reportId: int.parse(data['reportId']));
        navigatorKey.currentState!.push(
          CreateRoute.createRoute(route),
        );
      }
    }
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Listening for messages');
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      // Create and save notification to Hive
      final notificationModel = NotificationModel(
        title: notification.title ?? 'Public Patch',
        body: notification.body ?? '',
        isRead: false,
        reportId: message.data['reportId']?.toString() ?? '',
        timestamp: DateTime.now(),
      );
      if (!Hive.isBoxOpen(_storage.boxName)) {
        await Hive.openBox<NotificationModel>(_storage.boxName);
      }
      // Save to Hive storage
      await _storage.saveNotification(notificationModel);
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

    await _localNotifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (details) {
        Map<String, dynamic> data = jsonDecode(details.payload!);
        debugPrint('Parsed data: $data');
        RemoteMessage message = RemoteMessage.fromMap(data);
        message.data['reportId'] = data['reportId'];
        message.data['status'] = data['status'];
        message.data['stored'] = 'true';
        handleMessage(message);
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!;
    await platform.createNotificationChannel(_androidChannel);
  }

  Future<void> initialize() async {
    final request = await _firebaseMessage.requestPermission();
    if (request.authorizationStatus == AuthorizationStatus.denied) {
      Fluttertoast.showToast(msg: 'Permission denied');
      return;
    }
    final fcmToken = await _firebaseMessage.getToken();
    if (fcmToken == null) return;

    final GetTokenModel existingToken = await FcmtokenService().getUserToken(
      await UserSecureStorage.getUserId(),
      Platform.isAndroid ? 'Android' : 'iOS',
    );
    if (existingToken.FCMKey == fcmToken) {
      debugPrint('Token already exists');
    } else {
      final userId = await UserSecureStorage.getUserId();

      final saveToken = SaveToken(
        FCMKey: fcmToken,
        UserId: userId,
        DeviceType: Platform.isAndroid ? 'Android' : 'iOS',
      );
      FcmtokenService().saveToken(
        saveToken,
      );
    }
    initializeHive();
    initPushNotifications();
    initLocalNotifications();
  }
}
