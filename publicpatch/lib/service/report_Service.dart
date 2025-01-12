import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:publicpatch/models/CreateReport.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/service/image_Service.dart';

class ReportService {
  static String get baseUrl {
    return 'https://192.168.1.215:5001';
  }

  late final http.Client _client;

  ReportService() {
    HttpOverrides.global = _CustomHttpOverrides();
    _client = http.Client();
  }

  Future<Report?> createReport(CreateReport report) async {
    try {
      final imageUrls = await ImageService().uploadImages(report.imageUrls);
      debugPrint('Image URLs: $imageUrls');

      final response = await _client.post(
        Uri.parse('$baseUrl/reports/CreateReport'),
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
          'Status': report.status ?? 0,
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

  Future<Report> getReport(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/reports/GetReport/$id'),
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
      final response = await _client.get(
        Uri.parse('$baseUrl/reports/GetUserReports/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch user reports: ${response.statusCode}');
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
      final response = await _client.get(
        Uri.parse('$baseUrl/reports/GetAllReports'),
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

  Future<List<Report>> getReportsByZone(LocationData location) async {
    try {
      final uri = Uri.parse('$baseUrl/reports/GetReportsByZone').replace(
        queryParameters: {
          'Latitude': location.latitude.toString(),
          'Longitude': location.longitude.toString(),
          'Radius': location.radius.toString(),
        },
      );

      final response = await _client.get(
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
      final response = await _client.delete(
        Uri.parse('$baseUrl/reports/DeleteReport/$reportId'),
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
    _client.close();
  }
}

class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
