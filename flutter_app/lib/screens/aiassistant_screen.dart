import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_app/services/gemini_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class AiassistantScreen extends StatefulWidget {
  final String username;
  final String email;

  const AiassistantScreen({super.key, required this.username, required this.email});

  @override
  State<AiassistantScreen> createState() => _AiassistantScreenState();
}

class _AiassistantScreenState extends State<AiassistantScreen> {
  bool _isLoading = false;
  File? _selectedFile;
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchResponses(); // Fetch initial messages when the screen is created
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent, // Scroll to the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  /// Sends a query to the backend.
  Future<void> _sendQuery(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a query')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _messages.add({'sender': 'user', 'text': query}); // Add user message
    });

    try {
      final url = Uri.parse('${GeminiService.baseUrl}/gemini');
      final requestBody = jsonEncode({
        'query': query,
        'date': DateTime.now().toIso8601String(),
        'sender': widget.username,
        'email': widget.email,
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

  /// Fetches all messages from the backend and updates the UI.
  Future<void> _fetchResponses() async {
   try {
      final url = Uri.parse('${GeminiService.baseUrl}/geminiresponses');
      debugPrint('Constructed URL: $url');
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Conversation area
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUser = message['sender'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        message['text']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                // File picker button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickFile,
                ),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      hintText: _selectedFile != null
                          ? 'File attached: ${_selectedFile!.path.split('/').last}'
                          : 'Enter patient detials here...',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          final query = _queryController.text.trim();
                          _sendQuery(query);
                          _queryController.clear();
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}