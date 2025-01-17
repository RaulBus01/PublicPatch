import "dart:io";

import "package:publicpatch/models/LocationData.dart";

class Report {
  final int id;
  final String title;
  final int categoryId;
  final LocationData location;
  final String description;
  final int userId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final int upvotes;
  final int downvotes;
  final List<String> ReportImages;

  Report({
    required this.id,
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
    required this.ReportImages,
    required this.status,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? 0,
      location: LocationData.fromMap(map['location'] ?? {}),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? 0,
      categoryId: map['categoryId'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toUtc()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toUtc()),
      resolvedAt:
          map['resolvedAt'] != null ? DateTime.parse(map['resolvedAt']) : null,
      upvotes: map['upvotes'] ?? 0,
      downvotes: map['downvotes'] ?? 0,
      ReportImages: List<String>.from(map['reportImagesUrls'] ?? []),
      status: map['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location.toMap(),
      'title': title,
      'description': description,
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt.toUtc(),
      'updatedAt': updatedAt.toUtc(),
      'resolvedAt': resolvedAt?.toUtc(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'reportImagesUrls': ReportImages,
      'status': status,
    };
  }
}

class UpdateReportModel{
  final int id;
  final int userId;
  final String title;
  final LocationData location;
  final String description;
  final List<File> reportImages;

   UpdateReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.description,
    required this.reportImages,
  });

   factory UpdateReportModel.fromJson(Map<String, dynamic> json) {
    return UpdateReportModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      location: json['location'],
      description: json['description'],
      reportImages: json['reportImages'],
    );
  }
}
