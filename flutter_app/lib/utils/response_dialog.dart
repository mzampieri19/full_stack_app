import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/**
 * _pretty_printer function formats the response string into a more readable format.
 * It removes unnecessary characters and splits the response into sections based on headings.
 * Each section is displayed with a bold heading and normal text.
 * @param response The response string to be formatted.
 * @return A Column widget containing the formatted response sections.
 */
///
Widget _pretty_printer(String response) {
  final formattedResponse = response.replaceAll(RegExp(r'\*\*'), '').trim();
  final sections = formattedResponse.split(RegExp(r'\n(?=[A-Z]+\.)'));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: sections.map((section) {
      final lines = section.split('\n');
      final heading = lines.first.trim();
      final content = lines.skip(1).join('\n').trim();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

/**
 * showMessageDetailsDialog function displays a dialog with detailed information about a message.
 * It shows the query, response, date, and time of the message.
 * @param context The BuildContext of the current widget.
 * @param message The message data containing query, response, and timestamp.
 */
///
void showMessageDetailsDialog(BuildContext context, Map<String, dynamic> message) {
  final isUser = message['sender'] == 'user';
  final query = message['query'] ?? 'No query available';
  final response = message['text'] ?? 'No response available';
  final timestamp = message['timestamp'] ?? 'No timestamp available';

  // Parse and format the timestamp
  String formattedDate = 'No date available';
  String formattedTime = 'No time available';
  try {
    final dateTime = DateTime.parse(timestamp).toUtc().add(const Duration(hours: -5)); // Convert to EST
    formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); // Format as YYYY-MM-DD
    formattedTime = DateFormat('hh:mm a').format(dateTime); // Format as HH:MM AM/PM
  } catch (e) {
    debugPrint('Error parsing timestamp: $e');
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(isUser ? 'User Query' : 'AI Response'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Query:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(query, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              const Text(
                'Response:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              _pretty_printer(response),
              const SizedBox(height: 16),
              const Text(
                'Date:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(formattedDate, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 16),
              const Text(
                'Time (EST):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(formattedTime, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}