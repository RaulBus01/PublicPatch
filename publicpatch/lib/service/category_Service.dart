import 'dart:convert';



import 'package:flutter/material.dart';
import 'package:publicpatch/models/Category.dart';
import 'package:publicpatch/utils/api_utils.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    try {
      final response = await ApiUtils.client.get(
        Uri.parse('${ApiUtils.baseUrl}/GetCategories'),
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
      final response = await ApiUtils.client.get(
        Uri.parse('${ApiUtils.baseUrl}/categories/GetCategory/$id'),
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
    ApiUtils.client.close();
  }
}
