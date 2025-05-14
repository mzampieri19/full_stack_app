
import 'dart:io';
import 'package:flutter/material.dart';

/**
 * InputArea is a StatelessWidget that represents the input area of the AI Assistant screen.
 * It includes a text input field for user queries, a file picker button,
 * and a send button to submit the query.
 * The input area is designed to be responsive and user-friendly.
 * It also shows a loading indicator when the query is being processed.
 */
///
class InputArea extends StatelessWidget {
  final bool isLoading;
  final TextEditingController queryController;
  final Function(String) onSend;
  final Function() onFilePick;
  final File? selectedFile;

  const InputArea({
    super.key,
    required this.isLoading,
    required this.queryController,
    required this.onSend,
    required this.onFilePick,
    required this.selectedFile,
  });

  /**
   * Builds the input area widget.
   * It includes a text input field, a file picker button, and a send button.
   * The text input field shows a hint text based on the selected file.
   * The send button is disabled when the query is being processed.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          // File picker button
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: onFilePick,
          ),
          // Text input field
          Expanded(
            child: TextField(
              controller: queryController,
              decoration: InputDecoration(
                hintText: selectedFile != null
                    ? 'File attached: ${selectedFile!.path.split('/').last}'
                    : 'Enter patient details here...',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    final query = queryController.text.trim();
                    onSend(query);
                  },
            child: isLoading
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
    );
  }
}
