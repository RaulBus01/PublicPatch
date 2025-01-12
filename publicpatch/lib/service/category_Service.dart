import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:publicpatch/models/Category.dart';

class CategoryService {
  late final http.Client _client;
  static String get baseUrl => 'https://192.168.1.215:5001';

  CategoryService() {
    HttpOverrides.global = _CustomHttpOverrides();
    _client = http.Client();
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/GetCategories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final categories = List<Category>.from(
        (data as List).map((category) => Category.fromMap(category)),
      );

      return categories;
    } catch (e) {
      debugPrint('Error fetching categories from API: $e');
      // Fallback to local database
      return getLocalCategories();
    }
  }

  Future<List<Category>> getLocalCategories() async {
    final categories = <Category>[];
    categories.add(Category(
        id: 1,
        name: 'Local-Traffic',
        description: 'Contains traffic related issues',
        icon: 'TrafficIcon'));
    categories.add(Category(
        id: 2,
        name: 'Local-Parking',
        description: 'Report parking issues',
        icon: 'LocalParkingIcon'));

    return categories;
  }

  Future<Category> getCategory(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/categories/GetCategory/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch category: ${response.statusCode}');
      }

      return Category.fromMap(jsonDecode(response.body));
    } catch (e) {
      debugPrint('Error fetching category: $e');
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
