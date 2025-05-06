import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

/**
 * ConfirmScreen is a StatefulWidget that handles the confirmation of the sign-up process.
 * It includes a text field for entering the confirmation code sent to the user's email.
 * If the confirmation is successful, it navigates back to the login screen.
 */
///
class ConfirmScreen extends StatefulWidget {
  final String username;

  const ConfirmScreen({super.key, required this.username}); // Constructor to receive the username from the sign-up process.

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

/**
 * _ConfirmScreenState is the state class for ConfirmScreen.
 * It contains the logic for handling user input, making API calls,
 * and managing the UI state for the confirmation process.
 */
///
class _ConfirmScreenState extends State<ConfirmScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

/**
 * Confirms the sign-up process by sending the confirmation code to the backend.
 * It validates the input, makes a POST request to the confirmation endpoint,
 * and handles the response.
 * If the confirmation is successful, it navigates back to the login screen.
 */
///
Future<void> _confirmSignUp() async {
  final code = _codeController.text.trim();

  if (code.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter the confirmation code')));
    return;
  }

  setState(() => _isLoading = true);

  try {
    final url = Uri.parse('http://192.168.1.2:3000/confirm'); // Replace with your backend URL
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': widget.username,
        'confirmationCode': code,
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account confirmed successfully!')));
      Navigator.pop(context); // Navigate back to the login screen
    } else {
      final error = json.decode(response.body);
      print("Confirmation failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confirmation failed: ${error["error"] ?? "Unknown error"}')));
    }
  } catch (e) {
    setState(() => _isLoading = false);
    print('Exception: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

  /**
   * Generates a secret hash using HMAC SHA-256.
   * This is required by AWS Cognito for secure communication.
   */
  ///
  generateSecretHash({required String username, required String clientId, required String clientSecret}) {
    final key = utf8.encode(clientSecret);
    final message = utf8.encode(username + clientId);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(message);
    return base64.encode(digest.bytes);
  }

  /**
   * Builds the UI for the confirmation screen.
   * It includes a text field for entering the confirmation code,
   * a button to confirm the sign-up, and a loading indicator.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Account')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Enter the confirmation code sent to your email.'),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Confirmation Code'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _confirmSignUp,
                    child: Text('Confirm'),
                  ),
          ],
        ),
      ),
    );
  }
}