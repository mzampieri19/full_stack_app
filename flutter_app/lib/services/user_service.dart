import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * UserService is a class that handles user-related operations.
 * It provides methods for fetching user data from a backend server.
 * The class uses the http package to make API calls.
 */
///
class UserService {
  static const String baseUrl = 'http://192.168.1.2:3000';

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
      return json.decode(response.body);
    } else {
      debugPrint('Failed to fetch users with status code: ${response.statusCode}');
      throw Exception('Failed to fetch users');
    }
  }
}