import 'package:flutter/material.dart';
import 'package:test_app/screens/video_tracking/exercises/RBH.dart';
import 'package:test_app/screens/video_tracking/exercises/STS.dart';
import 'package:test_app/widgets/dashboard_card.dart';

class VideoTrackingDashboard extends StatelessWidget {
  const VideoTrackingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tracking Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Squat Tracking Card
            DashboardCard(
              icon: Icons.chair,
              title: 'Sit to Stand Tracking',
              description: 'Track the time needed to go from sitting to standing.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SitStandTimer(),
                  ),
                );
              },
            ),
            // Push-Up Tracking Card
            DashboardCard(
              icon: Icons.handshake,
              title: 'Raise Both Hands Tracking',
              description: 'Track the time needed to raise both hands.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HandRaiseCounter(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}