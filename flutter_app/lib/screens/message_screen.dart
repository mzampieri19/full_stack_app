import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/screens/message_details_screen.dart';
import 'package:test_app/widgets/loggedInUser.dart';

/**
 * MessageScreen is a StatefulWidget that displays a message screen.
 * It allows users to send and receive messages.
 * The screen fetches messages from a backend server and displays them in a ListView.
 * It also includes a text field for composing new messages.
 */
///
class MessageScreen extends StatefulWidget {
  final String username;
  final String email;
  const MessageScreen({super.key, required this.username, required this.email}); // Constructor to receive the username and email from the sign-up process.

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
  final ScrollController _scrollController = ScrollController();
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
      final response = await http.get(Uri.parse('http://192.168.1.2:3000/messages/${widget.username}'));
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
          'email': widget.email,
          'message': message,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      debugPrint('Response status code: ${response.statusCode}');
      if (response.statusCode == 201) { // Expect 201 for success
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
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                SizedBox(width: 10),
                Text(
                  'Logged in as: ${widget.username}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(child: Text('No messages found'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isCurrentUser = message['username'] == widget.username;

                          return Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: isCurrentUser ? Radius.circular(15) : Radius.zero,
                                  bottomRight: isCurrentUser ? Radius.zero : Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                  color: isCurrentUser ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
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
                      hintText: 'Enter your message',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}