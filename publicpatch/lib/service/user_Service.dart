import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:publicpatch/models/User.dart';
import 'package:publicpatch/models/UserLogin.dart';
import 'package:publicpatch/utils/api_utils.dart';

class UserService {
  Future<String> createUser(User user) async {
    try {
      final response = await ApiUtils.client.post(
        Uri.parse('${ApiUtils.baseUrl}/users/Register'),
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
      final response = await ApiUtils.client.post(
        Uri.parse('${ApiUtils.baseUrl}/users/Login'),
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
    ApiUtils.client.close();
  }
}
