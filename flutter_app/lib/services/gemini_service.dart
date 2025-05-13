
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static final String baseUrl = 'http://192.168.1.2:3000';
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<bool> fetchGeminiData(String query) async {
    debugPrint('Fetching data from Gemini API with query: $query');
    final url = Uri.parse('$baseUrl/gemini');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'query': query}),
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