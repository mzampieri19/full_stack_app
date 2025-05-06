import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/secret_hash.dart';

/**
 * AuthService is a class that handles authentication-related operations.
 * It provides methods for logging in and signing up users.
 * The class uses the http package to make API calls to a backend server.
 * The base URL, client ID, and client secret are loaded from environment variables using dotenv.
 */
///
class AuthService {
  static final String baseUrl = 'http://192.168.1.2:3000';
  static final String clientId = dotenv.env['CLIENT_ID'] ?? '';
  static final String clientSecret = dotenv.env['CLIENT_SECRET'] ?? '';
  static final String cognitoRegion = dotenv.env['COGNITO_REGION'] ?? '';

  static final String captchaSiteKey = dotenv.env['CAPTCHA_SITE_KEY'] ?? '';
  static final String captchaSecretKey = dotenv.env['CAPTCHA_SECRET_KEY'] ?? '';

  /**
   * Logs in a user with the provided username and password.
   * Generates a secret hash using the username, client ID, and client secret.
   * Sends a POST request to the login endpoint with the username, password, and secret hash.
   * Returns true if the login is successful, false otherwise.
   */
  ///
  static Future<bool> login(String username, String password) async {
    final cognitoRegion = dotenv.env['COGNITO_REGION'] ?? '';
    final cognitoClientId = dotenv.env['COGNITO_CLIENT_ID'] ?? '';
    final cognitoClientSecret = dotenv.env['COGNITO_CLIENT_SECRET'] ?? '';

    debugPrint('Login initiated for username: $username');
    debugPrint('Cognito Region: $cognitoRegion');
    debugPrint('Cognito Client ID: $cognitoClientId');

    // Generate the secret hash
    final secretHash = generateSecretHash(
      username: username,
      clientId: cognitoClientId,
      clientSecret: cognitoClientSecret,
    );
    debugPrint('Generated secret hash: $secretHash');

    final url = Uri.parse('https://cognito-idp.$cognitoRegion.amazonaws.com/');
    debugPrint('Login URL: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth',
      },
      body: json.encode({
        'AuthFlow': 'USER_PASSWORD_AUTH',
        'ClientId': cognitoClientId,
        'AuthParameters': {
          'USERNAME': username,
          'PASSWORD': password,
          'SECRET_HASH': secretHash,
        },
      }),
    );

    debugPrint('Login response status code: ${response.statusCode}');
    debugPrint('Login response body: ${response.body}');

    if (response.statusCode != 200) {
      debugPrint('Error: ${response.body}');
      return false;
    }

    return true;
  }

  /**
   * Signs up a new user with the provided username, password, and email.
   * Sends a POST request to the signup endpoint with the username, password, and email.
   * Returns true if the signup is successful, false otherwise.
   */
  ///
  static Future<bool> signUp(String username, String password, String email) async {
    debugPrint('Sign-up initiated for username: $username, email: $email');

    final url = Uri.parse('$baseUrl/signup');
    debugPrint('Sign-up URL: $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    debugPrint('Sign-up response status code: ${response.statusCode}');
    debugPrint('Sign-up response body: ${response.body}');

    return response.statusCode == 200;
  }

  /**
   * Verifies the captcha response from the user.
   * Sends a POST request to the captcha endpoint with the secret and response.
   * Returns true if the verification is successful, false otherwise.
   */
  ///
  static Future<bool> verifyCaptcha(String token) async {
    debugPrint('Captcha verification initiated with token: $token');

    final url = Uri.parse('$baseUrl/captcha');
    debugPrint('Captcha verification URL: $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'secret': captchaSecretKey,
        'h-captcha-response': token,
      }),
    );

    debugPrint('Captcha verification response status code: ${response.statusCode}');
    debugPrint('Captcha verification response body: ${response.body}');

    final body = json.decode(response.body);
    debugPrint('Captcha verification parsed response: $body');

    return body['responseCode'] == 200;
  }

  static void initialize() {}
}