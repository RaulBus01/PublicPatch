import 'package:geocoding/geocoding.dart';

class CreateReport {
  final Location location;
  final String title;
  final String description;
  final String userId;
  final int category;
  final List<String> imageUrls;

  CreateReport({
    required this.location,
    required this.title,
    required this.description,
    required this.userId,
    required this.category,
    required this.imageUrls,
  });
}
