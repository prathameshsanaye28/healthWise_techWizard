import 'dart:convert';
import 'package:http/http.dart' as http;

class SentimentAnalysisService {
  static const String apiUrl = 'YOUR_API_ENDPOINT'; // Could be your own server or a service

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to analyze sentiment');
      }
    } catch (e) {
      throw Exception('Error analyzing sentiment: $e');
    }
  }
}
