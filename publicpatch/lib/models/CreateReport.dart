import 'package:publicpatch/models/LocationData.dart';

class CreateReport {
  final String title;
  final int categoryId;
  final LocationData location;
  final String description;
  final int userId;
  final int status = 0;
  final DateTime createdAt = DateTime.now();
  final DateTime updatedAt = DateTime.now();
  final int upvotes = 0;
  final int downvotes = 0;

  final List<String> imageUrls;

  CreateReport({
    required this.title,
    required this.categoryId,
    required this.location,
    required this.description,
    required this.userId,
    required this.imageUrls,
  });

  factory CreateReport.fromMap(Map<String, dynamic> map) {
    return CreateReport(
      title: map['title'] ?? '',
      categoryId: map['categoryId'] ?? 0,
      location: LocationData(
        latitude: (map['latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? 0.0).toDouble(),
        address: map['address'] ?? '',
      ),
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categoryId': categoryId,
      'location': location.toMap(),
      'description': description,
      'userId': userId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'imageUrls': imageUrls,
    };
  }
}
