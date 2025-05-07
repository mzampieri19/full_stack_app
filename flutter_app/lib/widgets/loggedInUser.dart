import 'package:flutter/material.dart';

/**
 * LoggedInUserWidget is a StatelessWidget that displays the username of the logged-in user.
 * It includes an icon and a text label indicating the logged-in status.
 */
///
class LoggedInUserWidget extends StatelessWidget {
  final String username;
  const LoggedInUserWidget({Key? key, required this.username}) : super(key: key);

  /**
   * The build method returns a Container widget that displays the logged-in user's information.
   * It includes an icon and a text label indicating the logged-in status.
   */
   ///
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Logged in as: $username',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}