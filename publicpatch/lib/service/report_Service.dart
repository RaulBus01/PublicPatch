import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:publicpatch/models/CreateReport.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/service/image_Service.dart';
import 'package:publicpatch/utils/api_utils.dart';

class ReportService {
  Future<Report?> createReport(CreateReport report) async {
    try {
      final imageUrls = await ImageService().uploadImages(report.imageUrls);
      debugPrint('Image URLs: $imageUrls');

      final response = await ApiUtils.client.post(
        Uri.parse('${ApiUtils.baseUrl}/reports/CreateReport'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'Title': report.title,
          'location': {
            'longitude': report.location.longitude,
            'latitude': report.location.latitude,
            'address': report.location.address
          },
          'CategoryId': report.categoryId,
          'Description': report.description,
          'UserId': report.userId,
          'Status': report.status,
          'CreatedAt': DateTime.now().toUtc().toIso8601String(),
          'UpdatedAt': DateTime.now().toUtc().toIso8601String(),
          'Upvotes': 0,
          'Downvotes': 0,
          'ReportImages': imageUrls,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Report.fromMap(jsonDecode(response.body));
      }
      throw Exception('Failed to create report: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Error creating report: $e');
    }
  }

  Future<Report?> updateReport(UpdateReportModel report) async {
    try {
      // Upload new images if any
      final imageUrls = await ImageService().uploadImages(report.reportImages);
      debugPrint('Updated Image URLs: $imageUrls');

      final response = await ApiUtils.client.put(
        Uri.parse('${ApiUtils.baseUrl}/reports/UpdateReport/${report.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'Id': report.id,
          'UserId': report.userId,
          'Title': report.title,
          'location': {
            'longitude': report.location.longitude,
            'latitude': report.location.latitude,
            'address': report.location.address
          },
          'Description': report.description,
          'UpdatedAt': DateTime.now().toUtc().toIso8601String(),
          'ReportImages': imageUrls,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData != null ? Report.fromMap(responseData) : null;
      }

      if (response.statusCode == 404) {
        throw Exception('Report not found');
      }

      throw Exception('Failed to update report: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error updating report: $e');
      throw Exception('Error updating report: $e');
    }
  }

  Future<Report> getReport(int id) async {
    try {
      final response = await ApiUtils.client.get(
        Uri.parse('${ApiUtils.baseUrl}/reports/GetReport/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Report.fromMap(jsonDecode(response.body));
      }
      throw Exception('Failed to get report: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Report>> getUserReports(int userId) async {
    try {
      final response = await ApiUtils.client.get(
        Uri.parse('${ApiUtils.baseUrl}/reports/GetUserReports/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return List<Report>.empty();
      }

      final data = jsonDecode(response.body);
      return List<Report>.from(
        (data as List).map((report) => Report.fromMap(report)),
      );
    } catch (e) {
      debugPrint('Error fetching user reports: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final response = await ApiUtils.client.get(
        Uri.parse('${ApiUtils.baseUrl}/reports/GetAllReports'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return List<Report>.empty();
      }

      final data = jsonDecode(response.body);
      return List<Report>.from(
        (data as List).map((report) => Report.fromMap(report)),
      );
    } catch (e) {
      debugPrint('Error fetching reports: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<Report>> getReportsByZone(LocationData location) async {
    try {
      final uri =
          Uri.parse('${ApiUtils.baseUrl}/reports/GetReportsByZone').replace(
        queryParameters: {
          'Latitude': location.latitude.toString(),
          'Longitude': location.longitude.toString(),
          'Radius': location.radius.toString(),
        },
      );

      final response = await ApiUtils.client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch reports: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return List<Report>.from(
        (data as List).map((report) => Report.fromMap(report)),
      );
    } catch (e) {
      debugPrint('Error fetching reports: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<String> deleteReport(int reportId) async {
    try {
      final response = await ApiUtils.client.delete(
        Uri.parse('${ApiUtils.baseUrl}/reports/DeleteReport/$reportId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      throw Exception('Failed to delete report: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  void dispose() {
    ApiUtils.client.close();
  }
}
