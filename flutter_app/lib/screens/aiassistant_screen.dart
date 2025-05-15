import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_app/services/gemini_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/utils/response_dialog.dart';
import 'package:test_app/widgets/input_area.dart';
import 'package:test_app/widgets/responses_list.dart';

/**
 * AiassistantScreen is a StatefulWidget that represents the AI Assistant screen.
 * It allows users to send queries to the AI and receive responses.
 * The screen includes a message list area and an input area for user interaction.
 * It also handles file picking and displays the selected file name in the input area.
 * The screen fetches responses from the server and updates the message list accordingly.
 * The screen is initialized with the user's username and email.
 */
///
class AiassistantScreen extends StatefulWidget {
  final String username;
  final String email;

  const AiassistantScreen({super.key, required this.username, required this.email});

  @override
  State<AiassistantScreen> createState() => _AiassistantScreenState();
}

/**
 * _AiassistantScreenState is the state class for AiassistantScreen.
 * It manages the state of the screen, including loading status, selected file,
 * message list, and user input.
 * It also handles sending queries, fetching responses, and scrolling to the bottom of the message list.
 */
///
class _AiassistantScreenState extends State<AiassistantScreen> {
  bool _isLoading = false;
  File? _selectedFile;
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchResponses(); // Fetch initial messages when the screen is created
  }

  /**
   * _scrollToBottom function scrolls the message list to the bottom.
   * It is called after sending a query or when new messages are fetched.
   * It uses the ScrollController to animate the scroll position.
   */
  ///
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent, // Scroll to the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /**
   * _sendQuery function sends the user's query to the server.
   * It handles the loading state, updates the message list with the user's query,
   * and fetches the AI's response from the server.
   * It also handles errors and displays appropriate messages to the user.
   * @param query The user's query to be sent to the server.
   */
  ///
  Future<void> _sendQuery(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a query')),
      );
      return;
    }

    setState(() {
      _isLoading = true;

      // Add the user's query to the list with a temporary flag
      if (!_messages.any((message) => message['text'] == query && message['sender'] == 'user')) {
        _messages.add({
          '_id': DateTime.now().toIso8601String(), // Temporary unique ID
          'sender': 'user',
          'text': query,
          'isTemporary': true, // Mark this message as temporary
        });
      }
    });

    try {
      final url = Uri.parse('http://192.168.1.195:3000/geminiresponses');
      final requestBody = jsonEncode({
        'query': query,
        'date': DateTime.now().toIso8601String(),
        'sender': widget.username,
        'sender_email': widget.email,
        'fileData': null,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GeminiService.apiKey}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        debugPrint('Query sent successfully');
        _fetchResponses(); // Fetch updated messages after sending the query
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        setState(() {
          _messages.add({'sender': 'ai', 'text': 'Failed to fetch response from AI.'});
        });
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      setState(() {
        _messages.add({'sender': 'ai', 'text': 'An error occurred while fetching the response.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /**
   * _fetchResponses function fetches the AI responses from the server.
   * It updates the message list with the fetched responses and handles errors.
   * It also removes temporary messages before updating the list.
   * It is called when the screen is initialized and after sending a query.
   */
  ///
  Future<void> _fetchResponses() async {
    try {
      final url = Uri.parse('http://192.168.1.195:3000/geminiresponses');
      debugPrint('Fetching Gemini responses from $url');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          // Remove temporary messages before updating the list
          _messages.removeWhere((message) => message['isTemporary'] == true);

          for (var response in responseData) {
            // Check if the message already exists in the list
            if (!_messages.any((message) => message['_id'] == response['_id'])) {
              final parsedResponse = response['response'] is String
                  ? jsonDecode(response['response'])
                  : response['response'];

              final text = parsedResponse?['parts']?[0]?['text'] ?? 'No content available';
              final query = response['query'] ?? 'No query available';
              final timestamp = response['date'] ?? 'No timestamp available';

              _messages.add({
                '_id': response['_id'], // Add unique identifier
                'sender': response['sender'] ?? 'ai',
                'text': text,
                'query': query, // Add the query
                'timestamp': timestamp, // Add the timestamp
              });
            }
          }
        });
      } else {
        debugPrint('Failed to fetch responses, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch responses')),
        );
      }
    } catch (e) {
      debugPrint('Error fetching responses: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching responses: $e')),
      );
    }
  }

  /**
   * _pickFile function allows the user to pick a file from their device.
   * It uses the FilePicker package to open the file picker dialog.
   * If a file is selected, it updates the selected file state.
   */
  ///
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  /**
   * build function builds the UI of the AiassistantScreen.
   * It includes the AppBar, message list area, and input area.
   * It uses the ResponsesList and InputArea widgets to display messages and handle user input.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Message list area
          Expanded(
            child: ResponsesList(
              messages: _messages,
              onMessageTap: (message) => showMessageDetailsDialog(context, message),
              scrollController: _scrollController,
            ),
          ),
          // Input area
          InputArea(
            isLoading: _isLoading,
            queryController: _queryController,
            onSend: (query) {
              _sendQuery(query);
              _queryController.clear();
              _scrollToBottom();
            },
            onFilePick: _pickFile,
            selectedFile: _selectedFile,
          ),
        ],
      ),
    );
  }
}