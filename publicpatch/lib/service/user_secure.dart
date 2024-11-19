import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<int> getUserId() async {
    final token = await getToken();
    if (token == null) return 0;
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    return int.parse(decodedToken['sub']);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
