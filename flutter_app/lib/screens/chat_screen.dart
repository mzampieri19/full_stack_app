import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/screens/message_details_screen.dart';

/**
 * ChatScreen is a StatefulWidget that handles the chat functionality.
 * It allows users to send and receive messages in a chat interface.
 * The screen fetches messages from a backend server and displays them in a ListView.
 * It also includes a text field for composing new messages.
 */
///
class ChatScreen extends StatefulWidget {
  final String currentUser;
  final String otherUser;
  final String senderEmail;
  final String recieverEmail;

  const ChatScreen({
    Key? key,
    required this.currentUser,
    required this.otherUser,
    required this.senderEmail,
    required this.recieverEmail,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();

}

/**
 * _ChatScreenState is the state class for ChatScreen.
 * It manages the state of the message list, including loading indicators and message sending.
 */
///
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _isLoading = true;

  /**
   * Initializes the state of the ChatScreen.
   * It fetches the messages from the backend server when the screen is first created.
   */
  ///
  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _scrollToBottom() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent, // Scroll to the bottom
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  }

  /**
   * Fetches the list of messages from the backend server.
   * It makes a GET request to the /messages endpoint and updates the state with the fetched data.
   */
  ///
  Future<void> _fetchMessages() async {
    try {
      final url = Uri.parse('http://192.168.1.2:3000/messages/${widget.currentUser}/${widget.otherUser}');
      debugPrint('Fetching messages for user: ${widget.currentUser} and ${widget.otherUser}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint('Messages fetched successfully');
        debugPrint('Response body: ${response.body}');
        setState(() {
          _messages = json.decode(response.body);
          _isLoading = false;
        });
        _scrollToBottom();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      } else {
        debugPrint('Failed to fetch messages, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch messages')));
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching messages: $e')));
    }
  }

  /**
   * Sends a message to the backend server.
   * It validates the input, makes a POST request to the /messages endpoint,
   * and updates the message list if successful.
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
      final url = Uri.parse('http://192.168.1.2:3000/messages'); // Correct URL for POST request
      debugPrint('Sending POST request to $url');
      debugPrint('Request body: ${json.encode({
        'sender': widget.currentUser,
        'receiver': widget.otherUser,
        'sender_email': widget.senderEmail,
        'reciever_email': widget.recieverEmail,
        'message': message,
        'date': DateTime.now().toIso8601String(),
      })}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': widget.currentUser, // Sender username
          'receiver': widget.otherUser, // Receiver username
          'sender_email': widget.senderEmail, // Sender email
          'reciever_email': widget.recieverEmail, // Receiver email
          'message': message, // Message content
          'date': DateTime.now().toIso8601String(), // Current date in ISO format
        }),
      );

      debugPrint('Response status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        debugPrint('Message sent successfully');
        _messageController.clear();
        _fetchMessages(); // Refresh the messages list
        _scrollToBottom();
      } else {
        debugPrint('Failed to send message, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send message')));
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
    }
  }

  /**
   * Builds the UI for the ChatScreen.
   * It includes an AppBar, a ListView for displaying messages,
   * and a text field for composing new messages.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat with ${widget.otherUser}', style: TextStyle(fontSize: 18)),
            Text('Logged in as: ${widget.currentUser}', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(child: Text('No messages found'))
                    :ListView.builder(
                      controller: _scrollController,
                      reverse: true, // Reverse the order of messages
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isFromCurrentUser = message['sender'] == widget.currentUser;

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the MessageDetailsScreen with the selected message
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageDetailScreen(
                                  message: message, // Pass the entire message object
                                ),
                              ),
                            );
                          },
                          child: Align(
                            alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(12),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isFromCurrentUser ? Colors.blue : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: isFromCurrentUser ? Radius.circular(15) : Radius.zero,
                                  bottomRight: isFromCurrentUser ? Radius.zero : Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                  color: isFromCurrentUser ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
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