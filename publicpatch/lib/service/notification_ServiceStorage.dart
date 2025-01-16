import 'package:hive_flutter/hive_flutter.dart';
import 'package:publicpatch/models/NotificationModel.dart';

class NotificationStorage {
  static const String _baseBoxName = 'notifications';
  final String userId;
  late final String boxName;
  static NotificationStorage? _instance;

  NotificationStorage._({required this.userId}) {
    boxName = '${_baseBoxName}_$userId';
  }

  factory NotificationStorage({required String userId}) {
    if (_instance?.userId != userId) {
      _instance?.closeBox(); // Close previous user's box
      _instance = NotificationStorage._(userId: userId);
    }
    return _instance!;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }

    // Close any open box with the same name before opening
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<NotificationModel>(boxName).close();
    }

    await Hive.openBox<NotificationModel>(boxName);
  }

  Future<void> closeBox() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box<NotificationModel>(boxName);
      await box.close();
    }
  }

  Future<void> saveNotification(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>(boxName);
    await box.add(notification);
  }

  List<NotificationModel> getAllNotifications() {
    final box = Hive.box<NotificationModel>(boxName);
    final notifications = box.values.toList();
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifications;
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    await notification.delete();
  }

  Future<void> clearAllNotifications() async {
    final box = Hive.box<NotificationModel>(boxName);
    await box.clear();
  }
}
