import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:publicpatch/models/User.dart';
import 'package:publicpatch/models/UserLogin.dart';

class UserService {
  static String get baseUrl {
    return 'https://192.168.1.215:5001';
  }

  late final http.Client _client;

  UserService() {
    HttpOverrides.global = _CustomHttpOverrides();
    _client = http.Client();
  }

  Future<String> createUser(User user) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users/Register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': user.username,
          'email': user.email,
          'password': user.password,
          'role': 'user',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      throw Exception('Failed to create user: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Error creating user: $e');
    }
  }

  Future<String> login(UserLogin user) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users/Login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      throw Exception('Failed to login: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Login error: $e');
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
