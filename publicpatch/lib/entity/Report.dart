// report.dart
class Report {
  final int id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<String> imageUrls;

  Report({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    required this.createdAt,
    this.imageUrls = const [],
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      title: map['title'],
      description: map['description'],
      imageUrls: List<String>.from(map['image_urls']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
