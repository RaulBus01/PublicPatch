// report.dart

import "package:publicpatch/entity/Location.dart";

class Report {
  final Location location;
  final String title;
  final String description;
  final String userId;
  final int category;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime resolvedAt;
  final int upvotes;
  final int downvotes;
  final List<String> imageUrls;

  Report({
    required this.location,
    required this.title,
    required this.description,
    required this.userId,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.resolvedAt,
    required this.upvotes,
    required this.downvotes,
    required this.imageUrls,
    required this.status,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      location: Location.fromMap(map['location']),
      title: map['title'],
      description: map['description'],
      userId: map['user_id'],
      category: map['category'],
      status: map['status'],
      upvotes: map['upvotes'],
      downvotes: map['downvotes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      resolvedAt: DateTime.parse(map['resolved_at']),
      imageUrls: List<String>.from(map['image_urls']),
    );
  }
}
