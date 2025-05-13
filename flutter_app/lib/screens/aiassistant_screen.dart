import 'package:flutter/material.dart';
import 'package:test_app/services/gemini_service.dart';

/**
 * This is the AI Assistant screen that allows users to interact with the AI.
 * It includes a text input field for users to type their queries and a response area
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
 * This is the state class for the AI Assistant screen.
 * It manages the state of the screen, including loading state and user input.
 */
///
class _AiassistantScreenState extends State<AiassistantScreen> {
  bool _isLoading = false;
  String username = '';
  String email = '';
final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = []; // Stores the conversation (user and AI messages)


  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    debugPrint('Username: $username, Email: $email');
  }
  
/**
 * This function fetches data from the Gemini API based on the user's query.
 * It handles the loading state and displays appropriate messages based on the API response.
 * @param query The user's query to be sent to the Gemini API.
 * It checks if the query is empty and shows a snackbar message if it is.
 */
///
Future<void> _fetchGeminiData(String query) async {
  debugPrint('Fetching data from Gemini API with query: $query');
  if (query.isEmpty) {
    debugPrint('Query is empty, please provide a valid query');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid query')));
    return;
  }

  setState(() {
    _isLoading = true;
    debugPrint('Loading state set to true');
  });

  try {
    final success = await GeminiService.fetchGeminiData(query, username, email);
    debugPrint('Gemini API call completed');

    if (success) {
      debugPrint('Data fetched successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data fetched successfully')));
    } else {
      debugPrint('Error fetching data from Gemini API');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching data')));

    }
  } catch (e) {
    debugPrint('Gemini API call failed: $e');
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

/**
 * This function builds the UI for the AI Assistant screen.
 * It includes an AppBar, a response area, and an input area with a text field and a send button.
 * The response area displays the AI's response or a prompt to ask a question.
 * The input area allows users to type their queries and send them to the AI.
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
          // Conversation area
          Expanded(
            child: Container(
              color: Colors.white, // Set background to white
              child: ListView.builder(
                reverse: true, // Show the latest message at the bottom
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
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: const InputDecoration(
                      hintText: 'Type your query...',
                      border: OutlineInputBorder(),
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
                          _fetchGeminiData(query);
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