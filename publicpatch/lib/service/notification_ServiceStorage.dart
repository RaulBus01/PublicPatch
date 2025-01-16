import 'package:hive_flutter/hive_flutter.dart';
import 'package:publicpatch/models/NotificationModel.dart';

class NotificationStorage {
  static const String _baseBoxName = 'notifications';
  final String userId;
  late final String boxName;

  NotificationStorage({required this.userId}) {
    boxName = '${_baseBoxName}_$userId';
  }

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }
    await Hive.openBox<NotificationModel>(boxName);
  }

  Future<void> closeBox() async {
    final box = Hive.box<NotificationModel>(boxName);
    await box.close();
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
