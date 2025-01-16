import 'package:hive/hive.dart';

part 'NotificationModel.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final String reportId;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.reportId,
    required this.timestamp,
    this.isRead = false,
  });
}
