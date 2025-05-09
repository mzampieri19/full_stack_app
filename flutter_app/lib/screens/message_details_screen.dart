import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

/**
 * MessageDetailScreen is a StatelessWidget that displays the details of a message.
 * It shows the sender, receiver, message content, date, and time.
 * The date and time are formatted for better readability.
 */
///
class MessageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageDetailScreen({Key? key, required this.message}) : super(key: key);

    /**
     * Builds the UI for the MessageDetailScreen.
     * It includes an AppBar, a Card for message details, and formatted date and time.
     * The date and time are displayed in a user-friendly format.
     */
    ///
    @override
    Widget build(BuildContext context) {
      // Parse the date string into a DateTime object
      final DateTime dateTime = DateTime.parse(message['date']);

      // Format the date and time
      final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); // Example: 2025-05-08
      final String formattedTime = DateFormat('hh:mm a').format(dateTime.toUtc().subtract(Duration(hours: 4))); // Convert to EST (UTC-5)

      return Scaffold(
        appBar: AppBar(
          title: Text('Message Details'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender Information
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Sender:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        message['sender'],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Receiver Information
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Receiver:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        message['receiver'],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Message Content
                  Text(
                    'Message:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Date:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        formattedDate, // Display the formatted date
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Time
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Time:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        formattedTime, // Display the formatted time
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }