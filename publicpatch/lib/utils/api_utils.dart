import 'dart:io';
import 'package:http/http.dart' as http;

class ApiUtils {
  static const String baseUrl = 'https://192.168.1.108:5001';
  static http.Client? _client;

  static http.Client get client {
    if (_client == null) {
      HttpOverrides.global = _CustomHttpOverrides();
      _client = http.Client();
    }
    return _client!;
  }

  static void dispose() {
    _client?.close();
    _client = null;
  }
}

class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
