
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<bool> fetchGeminiData(String query, String username, String email) async {
    debugPrint('Fetching data from Gemini API with query: $query');
    final url = Uri.parse('$baseUrl/gemini');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'query': query,
        'date': DateTime.now().toIso8601String(),
        'sender': username,
        'sender_email': email,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Response from Gemini API: ${response.body}');
      return true;
    } else {
      debugPrint('Error: ${response.body}');
      return false;
    }
  }
}