import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * MessageScreen is a StatefulWidget that displays a message screen.
 * It allows users to send and receive messages.
 * The screen fetches messages from a backend server and displays them in a ListView.
 * It also includes a text field for composing new messages.
 */
///
class MessageScreen extends StatefulWidget {
  final String username;

  const MessageScreen({Key? key, required this.username}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

/**
 * _MessageScreenState is the state class for MessageScreen.
 * It manages the state of the message list, including loading indicators and message sending.
 */
///
class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  bool _isLoading = true;

  /**
   * Initializes the state of the MessageScreen.
   * It fetches the messages from the backend server when the screen is first created.
   */
  ///
  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  /**
   * Fetches the list of messages from the backend server.
   * It makes a GET request to the /messages endpoint and updates the state with the fetched data.
   */
  ///
  Future<void> _fetchMessages() async {
    debugPrint('Fetching messages from backend...');
    try {
      final response = await http.get(Uri.parse('http://192.168.1.2:3000/messages')); // Replace with your backend URL
      debugPrint('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Messages fetched successfully');
        setState(() {
          _messages = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        debugPrint('Failed to fetch messages, status code: ${response.statusCode}');
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching messages')));
    }
  }

  /**
   * Sends a new message to the backend server.
   * It validates the input, makes a POST request to the /messages endpoint,
   * and updates the messages list if successful.
   */
  ///
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    debugPrint('Attempting to send message: $message');
    if (message.isEmpty) {
      debugPrint('Message is empty, showing snackbar');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message cannot be empty')));
      return;
    }

    try {
      debugPrint('Sending POST request to backend');
      final response = await http.post(
        Uri.parse('http://192.168.1.2:3000/messages'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': widget.username,
          'message': message,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      debugPrint('Response status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        debugPrint('Message sent successfully');
        _messageController.clear();
        _fetchMessages(); // Refresh the messages list
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent!')));
      } else {
        debugPrint('Failed to send message, status code: ${response.statusCode}');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending message')));
    }
  }

  /**
   * Builds the UI for the MessageScreen.
   * It includes an AppBar, a ListView for displaying messages,
   * and a TextField for composing new messages.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(child: Text('No messages found'))
                    : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return ListTile(
                            title: Text(message['message']),
                            subtitle: Text('By: ${message['username']} on ${message['date']}'),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}