import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * UserListScreen is a StatefulWidget that displays a list of users.
 * It fetches the user data from a backend server and displays it in a ListView.
 * The screen also includes a logout button in the AppBar.
 */
///
class UserListScreen extends StatefulWidget {
  final String username;

  const UserListScreen({super.key, required this.username});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

/**
 * _UserListScreenState is the state class for UserListScreen.
 * It manages the state of the user list, including loading indicators and user data fetching.
 */
///
class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /**
   * Fetches the list of users from the backend server.
   * It makes a GET request to the /users endpoint and updates the state with the fetched data.
   */
   ///
  Future<void> _fetchUsers() async {
    try {
      final url = Uri.parse('http://192.168.1.2:3000/users'); // Replace with your backend URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        print('Failed to fetch users: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch users')));
      }
    } catch (e) {
      print('Error fetching users: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching users')));
    }
  }

  /**
   * Logs out the user by making a POST request to the /logout endpoint.
   * It passes the username to the backend for logout processing.
   */
   ///
  Future<void> _logout() async {
    try {
      final url = Uri.parse('http://192.168.1.2:3000/logout'); // Replace with your backend URL
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': widget.username, // Pass the username for logout
        }),
      );

      if (response.statusCode == 200) {
        print('Logout successful');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout successful!')));

        // Navigate back to the login screen
        Navigator.pop(context);
      } else {
        final error = json.decode(response.body);
        print('Logout failed: ${error["error"]}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: ${error["error"]}')));
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error during logout: $e')));
    }
  }

  /**
   * Builds the UI for the UserListScreen.
   * It displays a loading indicator while fetching data and a list of users once the data is loaded.
   */
   ///
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Call the logout function
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            user['username'][0].toUpperCase(), // First letter of the username
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user['username']),
                        subtitle: Text(user['email']),
                      ),
                    );
                  },
                ),
    );
  }
}