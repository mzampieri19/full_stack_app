import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/screens/auth_screen.dart';

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
  debugPrint('Confirmation code entered: $code');

  if (code.isEmpty) {
    debugPrint('No confirmation code entered.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter the confirmation code')));
    return;
  }

  setState(() => _isLoading = true);
  debugPrint('Sending confirmation request to backend...');

  try {
    final url = Uri.parse('http://192.168.1.2:3000/confirm'); // Replace with your backend URL
    debugPrint('Backend URL: $url');
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

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      debugPrint('Account confirmed successfully.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account confirmed successfully!')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen(username: widget.username)),
      );
    } else {
      final error = json.decode(response.body);
      debugPrint("Confirmation failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confirmation failed: ${error["error"] ?? "Unknown error"}')));
    }
  } catch (e) {
    setState(() => _isLoading = false);
    debugPrint('Exception occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
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
      appBar: AppBar(
        title: Text('Confirm Email'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Confirm Your Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Enter the confirmation code sent to your email:',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: 'Confirmation code',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _confirmSignUp, // Call the confirmation method
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}