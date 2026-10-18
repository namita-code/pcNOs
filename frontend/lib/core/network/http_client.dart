import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pc_no_s/core/network/api_endpoints.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  final http.Client _client = http.Client();

  Future<dynamic> get(String endpoint) async {
    final response = await _client.get(Uri.parse('${ApiEndpoints.baseUrl}$endpoint'));
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }

}