import '../../core/network/api_endpoints.dart';
import '../../core/network/http_client.dart';

class SymptomsRepository {
  final HttpClient _httpClient = HttpClient();

  Future<String> getPcosProbability(Map<String, dynamic> symptomsData) async {
    try {
      final response = await _httpClient.post(ApiEndpoints.predictPCOS, symptomsData);
      return response['pcos_severity'];
    } catch (e) {
      print('Error predicting PCOS: $e');
      rethrow;
    }
  }
}