import 'package:flutter/material.dart';
import 'package:test_app/screens/aiassistant_screen.dart';
import 'package:test_app/screens/user_list_screen.dart';
import 'package:test_app/screens/encouragement_screen.dart';
import 'package:test_app/screens/video_tracking_screen.dart'; // Import the new screen

class DashboardScreen extends StatelessWidget {
  final String username;
  final String email;
  final List<Map<String, String>> users;

  const DashboardScreen({super.key, required this.username, required this.email, required this.users});

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
                  _buildDashboardCard(
                    context,
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
                  _buildDashboardCard(
                    context,
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
                  _buildDashboardCard(
                    context,
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
                  _buildDashboardCard(
                    context,
                    icon: Icons.videocam_outlined,
                    title: 'Video Tracking',
                    description: 'Track and analyze videos automatically.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoTrackingScreen(),
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

  // Helper method to build a dashboard card
  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}