import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:publicpatch/models/GetTokenModel.dart';
import 'package:publicpatch/models/SaveToken.dart';
import 'package:publicpatch/models/User.dart';
import 'package:publicpatch/models/UserLogin.dart';
import 'package:publicpatch/utils/api_utils.dart';

class FcmtokenService {
  Future<String> saveToken(SaveToken save) async {
    try {
      final response = await ApiUtils.client.post(
        Uri.parse('${ApiUtils.baseUrl}/fcm-token/AddFCMToken'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': save.FCMKey,
          'userId': save.UserId,
          'DeviceType': save.DeviceType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      throw Exception('Failed to create token: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Error creating token: $e');
    }
  }

  Future<GetTokenModel> getUserToken(int userID, String device) async {
    try {
      final response = await ApiUtils.client.get(
        Uri.parse(
            '${ApiUtils.baseUrl}/fcm-token/GetFCMTokenByUserId/$userID/$device'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Token: ${response.body}');
        return GetTokenModel.fromMap(jsonDecode(response.body));
      }
      return GetTokenModel(
        id: 0,
        FCMKey: '',
        UserId: 0,
        DeviceType: '',
        isActive: false,
      );
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Error getting token: $e');
    }
  }

  void dispose() {
    ApiUtils.client.close();
  }
}
