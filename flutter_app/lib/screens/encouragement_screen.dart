import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * EncouragementScreen is a StatefulWidget that represents the Encouragement screen.
 * It allows users to fetch and display encouraging messages from the server.
 * The screen includes a button to fetch the message and displays it in a text widget.
 * It also handles loading state and error handling.
 */
///
class EncouragementScreen extends StatefulWidget {
  const EncouragementScreen({super.key});

  @override
  State<EncouragementScreen> createState() => _EncouragementScreenState();
}

/**
 * _EncouragementScreenState is the state class for EncouragementScreen.
 * It manages the state of the screen, including loading status and the fetched advice.
 * It also handles fetching the encouraging message from the server and updating the UI accordingly.
 */
///
class _EncouragementScreenState extends State<EncouragementScreen> {
  String? _advice; // Store the advice (either generated or random)
  bool _isLoading = false; // Track the loading state

  /**
   * _fetchEncouragingMessage function fetches an encouraging message from the server.
   * It sends a POST request to the specified URL and handles the response.
   * If the request is successful, it updates the state with the fetched advice.
   * If an error occurs, it updates the state with an error message.
   */
  ///
  Future<void> _fetchEncouragingMessage() async {
  setState(() {
    _isLoading = true;
    _advice = null; // Clear the previous advice
  });

  try {
    final url = Uri.parse('http://192.168.1.195:3000/geminiresponses/generateEncouragement');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      debugPrint('API response: $responseData'); // Log the API response for debugging

      setState(() {
        // Safely extract the advice from the "parts" and "text" section
        if (responseData != null &&
            responseData['generatedContent'] != null &&
            responseData['generatedContent']['parts'] is List &&
            responseData['generatedContent']['parts'].isNotEmpty &&
            responseData['generatedContent']['parts'][0] is Map &&
            responseData['generatedContent']['parts'][0]['text'] is String) {
          _advice = responseData['generatedContent']['parts'][0]['text'];
        } else {
          _advice = 'No advice available.';
        }
      });
    } else {
      setState(() {
        _advice = 'Failed to fetch advice. Status code: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      _advice = 'An error occurred: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes a button to fetch the encouraging message and displays the message if available.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encouragement'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the advice
            if (_advice != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _advice!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            // Show a loading indicator while fetching the message
            if (_isLoading)
              const CircularProgressIndicator(),
            // Button to fetch the encouraging message
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchEncouragingMessage,
              child: const Text('Get Encouragement'),
            ),
          ],
        ),
      ),
    );
  }
}