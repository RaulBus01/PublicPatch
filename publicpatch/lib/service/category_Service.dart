// lib/services/category_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:publicpatch/models/Category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:dio/io.dart';

class CategoryService {
  static Database? _db;
  late final Dio _dio;
  final String baseUrl = 'https://10.0.2.2:5001'; // Add your API base URL

  CategoryService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'categories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            icon TEXT
          )
        ''');
      },
    );
  }

  Future<List<Category>> getCategories() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        final response = await _dio.get('/GetCategories');
        print(response.data);
        if (response.statusCode == 200) {
          final categories = (response.data as List)
              .map((item) => Category.fromMap(item))
              .toList();
          await _saveCategories(categories);
          return categories;
        }
      }
      return await _getLocalCategories();
    } catch (e) {
      print('Error fetching categories: $e');
      // Return default categories if both API and local storage fail
      return [
        Category(
            id: 1,
            name: 'Road Issue',
            description: 'Report road issues',
            icon: 'TrafficIcon'),
        Category(
            id: 2,
            name: 'Street Light',
            description: 'Report street light issues',
            icon: 'LocalParkingIcon'),
      ];
    }
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final db = await database;
    final batch = db.batch();

    // Clear existing categories
    batch.delete('categories');

    // Insert new categories
    for (var category in categories) {
      batch.insert('categories', category.toMap());
    }

    await batch.commit();
  }

  Future<List<Category>> _getLocalCategories() async {
    try {
      final db = await database;
      final maps = await db.query('categories');

      if (maps.isNotEmpty) {
        return maps.map((map) => Category.fromMap(map)).toList();
      }

      // Fallback to static categories if no cached data
      return [
        Category(
            id: 1,
            name: 'Road Issue',
            description: 'Report road issues',
            icon: 'TrafficIcon'),
        Category(
            id: 2,
            name: 'Street Light',
            description: 'Report street light issues',
            icon: 'LocalParkingIcon'),
      ];
    } catch (e) {
      print('Error getting local categories: $e');
      return [];
    }
  }
}
