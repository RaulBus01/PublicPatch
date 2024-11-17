import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:publicpatch/entity/User.dart';
import 'package:publicpatch/entity/UserLogin.dart';

class UserService {
  late final Dio _dio;
  final String baseUrl = 'https://10.0.2.2:5001';

  UserService() {
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

  Future<bool> createUser(User user) async {
    try {
      final response = await _dio.post(
        '/users/createUser',
        data: {
          'username': user.username,
          'email': user.email,
          'password': user.password,
          'role': 'user',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      SnackBar(content: Text(e.message.toString()));
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      SnackBar(content: Text(e.toString()));

      throw Exception('Network error: $e');
    }
  }

  Future<String> login(UserLogin user) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': user.email,
          'password': user.password,
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
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Error logging inA',
          gravity: ToastGravity.TOP);

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: e.toString(),
          gravity: ToastGravity.TOP);

      throw Exception('Network error: $e');
    }
  }
}
