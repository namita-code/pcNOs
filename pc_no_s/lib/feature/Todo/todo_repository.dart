import '../../core/network/api_endpoints.dart';
import '../../core/network/http_client.dart';

class TodoRepository {
  final HttpClient _httpClient = HttpClient();

  Future<String> getTodoPlan(Map<String, dynamic> userData) async {
    try {
      final response = await _httpClient.post(ApiEndpoints.todoPlan, userData);
      return response['todo'];   // Backend returns { "todo": "..." }
    } catch (e) {
      print("Error fetching Todo Plan: $e");
      rethrow;
    }
  }
}
