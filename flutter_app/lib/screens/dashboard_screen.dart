import 'package:flutter/material.dart';
import 'package:test_app/screens/aiassistant_screen.dart';
import 'package:test_app/screens/user_list_screen.dart';
import 'package:test_app/screens/encouragement_screen.dart';
import 'package:test_app/screens/video_tracking_dashboard.dart'; 
import 'package:test_app/widgets/dashboard_card.dart';

/**
 * DashboardScreen is a StatelessWidget that represents the main dashboard of the application.
 * It displays a welcome message and provides options for the user to navigate to different features.
 * The screen includes cards for AI Assistant, User List, Encouragement, and Automated Video Tracking.
 * The screen is initialized with the user's username, email, and a list of users.
 * It uses a GridView to display the cards in a grid layout.
 */
///
class DashboardScreen extends StatelessWidget {
  final String username;
  final String email;
  final List<Map<String, String>> users;

  const DashboardScreen({super.key, required this.username, required this.email, required this.users});

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes a welcome message, a prompt for user action, and a GridView with cards.
   * Each card is clickable and navigates to the corresponding screen when tapped.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'What would you like to do today?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Dashboard options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // AI Assistant Card
                  DashboardCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'AI Assistant',
                    description: 'Interact with the AI Assistant to get answers and insights.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AiassistantScreen(username: username, email: email),
                        ),
                      );
                    },
                  ),
                  // User List Card
                  DashboardCard(
                    icon: Icons.people_outline,
                    title: 'User List',
                    description: 'View and manage the list of users in the system.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(
                            currentUser: username,
                            currentUserEmail: email,
                            users: users,
                          ),
                        ),
                      );
                    },
                  ),
                  // Encouragement Card
                  DashboardCard(
                    icon: Icons.favorite_outline,
                    title: 'Encouragement',
                    description: 'Get motivational advice to brighten your day.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EncouragementScreen(),
                        ),
                      );
                    },
                  ),
                  // Automated Video Tracking Card
                  DashboardCard(
                    icon: Icons.videocam_outlined,
                    title: 'Video Tracking',
                    description: 'Track and analyze videos automatically.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoTrackingDashboard(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}