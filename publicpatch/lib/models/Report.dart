import "package:publicpatch/models/Location.dart";

class Report {
  final String title;
  final int categoryId;
  final Location location;
  final String description;
  final int userId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final int upvotes;
  final int downvotes;
  final List<String> imageUrls;

  Report({
    required this.location,
    required this.title,
    required this.description,
    required this.userId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    required this.upvotes,
    required this.downvotes,
    required this.imageUrls,
    required this.status,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      location: Location.fromMap(map['location'] ?? {}),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? 0,
      categoryId: map['categoryId'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      resolvedAt: map['resolvedAt'] != null ? DateTime.parse(map['resolvedAt']) : null,
      upvotes: map['upvotes'] ?? 0,
      downvotes: map['downvotes'] ?? 0,
      imageUrls: List<String>.from(map['reportImagesUrls'] ?? []),
      status: map['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location.toMap(),
      'title': title,
      'description': description,
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'reportImagesUrls': imageUrls,
      'status': status,
    };
  }
}
