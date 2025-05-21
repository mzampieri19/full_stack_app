import 'package:flutter/material.dart';
import 'package:test_app/web_rtc_new/new_call_screen.dart';
import 'package:test_app/web_rtc_old/exercises/RBH.dart';
import 'package:test_app/web_rtc_old/exercises/STS.dart';

/**
 * VideoTrackingDashboard is a StatelessWidget that represents the main dashboard for video tracking exercises.
 * It provides options for the user to navigate to different exercises and a video call with motion tracking.
 */
///
class VideoTrackingDashboard extends StatelessWidget {
  const VideoTrackingDashboard({super.key});

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes a welcome message, a prompt for user action, and buttons for different exercises.
   * Each button navigates to the corresponding exercise screen when tapped.
   */
   ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Therapy Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SitStandExercise()),
              ),
              child: const Text('Sit-Stand Exercise'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RaiseBothHandsExercise()),
              ),
              child: const Text('Raise Both Hands Exercise'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoTrackingScreen()),
              ),
              child: const Text('Join a video call with motion tracking'),
            ),
          ],
        ),
      ),
    );
  }
}