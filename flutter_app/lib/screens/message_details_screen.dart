import 'package:flutter/material.dart';

class MessageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageDetailScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              message['message'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'By: ${message['username']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${message['email']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateTime.parse(message['date']).toLocal().toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${DateTime.parse(message['date']).toLocal().toIso8601String().split('T')[1].split('.')[0]} EST',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}