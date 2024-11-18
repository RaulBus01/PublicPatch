import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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

  Future<String> createReport(Report report) async {
    try {
      final response = await _dio.post(
        '/reports/CreateReport',
        data: {
          'title': report.title,
          'location': report.location,
          'description': report.description,
          'category': report.categoryId,
          'images': report.imageUrls,
        },
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

  Future<Report> getReport(String id) async {
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

      return Report.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final response = await _dio.get(
        '/reports/GetUserReports/26',
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
}
