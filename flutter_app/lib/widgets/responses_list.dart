import 'package:flutter/material.dart';

/**
 * ResponsesList is a StatelessWidget that represents the list of responses
 * received from the AI Assistant.
 * It displays the messages in a scrollable list format.
 * Each message includes the query, a snippet of the response,
 * and a tap action to view details.
 * The list is designed to be user-friendly and visually appealing.
 */
///
class ResponsesList extends StatelessWidget {
  final List<dynamic> messages;
  final Function(Map<String, dynamic>) onMessageTap;
  final ScrollController scrollController;

  const ResponsesList({
    super.key,
    required this.messages,
    required this.onMessageTap,
    required this.scrollController,
  });

  /**
   * Builds the responses list widget.
   * It displays a message when there are no messages yet.
   * Otherwise, it shows a scrollable list of messages with query and response snippets.
   * Each message is tappable to view details.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: messages.isEmpty
          ? const Center(
              child: Text(
                'No messages yet. Start by sending a query!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                final query = message['query'] ?? 'No query available';
                final text = message['text'] ?? 'No content available';
                final snippet = text.length > 100 ? '${text.substring(0, 100)}...' : text;

                return GestureDetector(
                  onTap: () => onMessageTap(message),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[50] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the query
                        Text(
                          'Query: $query',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Display the snippet of the response
                        Text(
                          snippet,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to view details',
                          style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}