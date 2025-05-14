import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EncouragementWidget extends StatefulWidget {
  const EncouragementWidget({super.key});

  @override
  State<EncouragementWidget> createState() => _EncouragementWidgetState();
}

class _EncouragementWidgetState extends State<EncouragementWidget> {
  String? _advice; // Store the advice (either generated or random)
  bool _isLoading = false; // Track the loading state

  // Function to fetch advice from the Gemini API and database
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

        setState(() {
          // Extract the advice from the "parts" and "text" section
          final parts = responseData['response']?['parts'];
          _advice = parts != null && parts.isNotEmpty
              ? parts[0]['text']
              : 'No advice available.';
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

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}