import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:publicpatch/models/CreateReport.dart';
import 'package:publicpatch/models/Report.dart';

class ReportService {
  late final Dio _dio;
  final String baseUrl = 'https://10.0.2.2:5001';

  ReportService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    ));

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };
  }

  Future<Report?> createReport(CreateReport report) async {
    try {
      final data = {
        'Title': report.title,
        'location': {
          'longitude': report.location.longitude,
          'latitude': report.location.latitude,
          'address': report.location.address
        },
        'CategoryId': report.categoryId,
        'Description': report.description,
        'UserId': report.userId,
        'Status': report.status ?? 1,
        'CreatedAt': DateTime.now().toUtc().toIso8601String(),
        'UpdatedAt': DateTime.now().toUtc().toIso8601String(),
        'Upvotes': 0,
        'Downvotes': 0,
        'ReportImagesUrls': report.imageUrls,
      };

      print('Request data: ${data.toString()}'); // Debug log

      final response = await _dio.post(
        '/reports/CreteReport',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data != null ? Report.fromMap(response.data) : null;
      }
      throw Exception('Failed to create report: ${response.statusMessage}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Error creating report: $e');
    }
  }

  Future<Report> getReport(int id) async {
    try {
      final response = await _dio.get(
        '/reports/GetReport/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Report.fromMap(response.data);
      }
      throw Exception('Failed to get report: ${response.statusMessage}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Report>> getReports(int userId) async {
    try {
      final response = await _dio.get(
        '/reports/GetUserReports/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("Response: ${response.data}");
      return List<Report>.from(
          response.data.map((report) => Report.fromMap(report)));
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print("Error: $e");
      throw Exception('Network error: $e');
    }
  }

  Future<String> deleteReport(int reportId) async {
    try {
      final response = await _dio.delete(
        '/reports/DeleteReport/$reportId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201
          ? response.toString()
          : '';
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
