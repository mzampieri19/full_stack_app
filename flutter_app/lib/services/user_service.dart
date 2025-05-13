import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/**
 * UserService is a class that handles user-related operations.
 * It provides methods for fetching user data from a backend server.
 * The class uses the http package to make API calls.
 */
///
class UserService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';


  /**
   * Fetches the list of users from the backend server.
   * It makes a GET request to the /users endpoint and returns the response data.
   */
  ///
  static Future<List<dynamic>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');
    debugPrint('Sending GET request to: $url');
    final response = await http.get(url);

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body) as List<dynamic>;
      } catch (e) {
        debugPrint('Error parsing response body: $e');
        throw Exception('Failed to parse user data');
      }
    } else {
      debugPrint('Failed to fetch users with status code: ${response.statusCode}');
      throw Exception('Failed to fetch users');
    }
  }

  /**
   * Fetches user details from the backend server.
   * It makes a GET request to the /users/{username} endpoint and returns the user details as a Map.
   */
  ///
  static Future<Map<String, dynamic>> getUserDetails(String username) async {
    debugPrint('Fetching user data for username: $username');

    // Correct the URL by removing the colon
    final url = Uri.parse('http://192.168.1.2:3000/users/$username');
    debugPrint('User data URL: $url');

    final response = await http.get(url);

    debugPrint('User data response status code: ${response.statusCode}');
    debugPrint('User data response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  /**
   * Gets all users from the backend server.
   * It makes a GET request to the /users endpoint and returns a list of users.
   * Each user is represented as a Map with 'username' and 'email' keys.
   */
  ///
  static Future<List<Map<String, String>>> getAllUsers() async {
    final url = Uri.parse('http://192.168.1.2:3000/users/getAllUsers');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((user) {
        return {
          'username': user['username'] as String, // Explicitly cast to String
          'email': user['email'] as String, // Explicitly cast to String
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

}