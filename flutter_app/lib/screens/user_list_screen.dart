import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'aiassistant_screen.dart';

/**
 * UserListScreen is a StatelessWidget that displays a list of users.
 * It shows the logged-in user at the top and other users below.
 * Tapping on a user navigates to the ChatScreen for that user.
 */
///
class UserListScreen extends StatelessWidget {
  final String currentUser;
  final String currentUserEmail;
  final List<Map<String, String>> users; // List of all users with their usernames and emails

  /**
   * Constructor for UserListScreen.
   * It takes the current user's username, email, and a list of users as parameters.
   */
  ///
  const UserListScreen({
    super.key,
    required this.currentUser,
    required this.currentUserEmail,
    required this.users,
  });

  /**
   * Builds the UserListScreen widget.
   * It separates the logged-in user from the rest of the users and displays them in a ListView.
   */
  ///
  @override
  Widget build(BuildContext context) {
    // Separate the logged-in user from the rest of the users
    final otherUsers = users.where((user) => user['username'] != currentUser).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Section for the logged-in user
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Logged-in User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(currentUser),
            subtitle: Text(currentUserEmail),
            onTap: () {
              // Optionally handle tap for the logged-in user
            },
          ),
          Divider(),
          // Section for other users
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Other Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...otherUsers.map((user) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(user['username']!),
              subtitle: Text(user['email']!),
              onTap: () {
                // Navigate to the ChatScreen for the selected user
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      currentUser: currentUser,
                      otherUser: user['username']!,
                      senderEmail: currentUserEmail,
                      recieverEmail: user['email']!,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => AiassistantScreen(username: currentUser, email: currentUserEmail) // Pass the current user's username and email to AiassistantScreen,
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),

    );
  }
}