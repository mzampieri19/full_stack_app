import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


/**
 * GeminiService is a class that handles communication with the Gemini API.
 * It includes methods to fetch data from the API based on user queries and other parameters.
 */
///
class GeminiService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  /**
   * fetchGeminiData function sends a POST request to the Gemini API with the user's query and other parameters.
   * It handles the response and returns a boolean indicating success or failure.
   * @param query The user's query to be sent to the Gemini API.
   * @param username The username of the user making the request.
   * @param email The email of the user making the request.
   */
  ///
  static Future<bool> fetchGeminiData(String query, String username, String email) async {
    debugPrint('Entered fetchGeminiData with query: $query, for user: $username, email: $email');
    final url = Uri.parse('$baseUrl/gemini');
    debugPrint('Constructed URL: $url');
    debugPrint('Using API Key: ${apiKey.isNotEmpty ? "Provided" : "Not Provided"}');

    final requestBody = jsonEncode({
      'query': query,
      'date': DateTime.now().toIso8601String(),
      'sender': username,
      'email': email,
      'fileData': null, // Assuming fileData is not used in this request
    });
    debugPrint('Request Body: $requestBody');

    try {
      debugPrint('Sending POST request to $url with headers: {Content-Type: application/json, Authorization: Bearer $apiKey}');
      debugPrint('Request Body: $requestBody');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody,
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Request to Gemini API was successful.');
        return true;
      } else {
        debugPrint('Request to Gemini API failed with status: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('An error occurred while making the request: $e');
      return false;
    }
  }
}