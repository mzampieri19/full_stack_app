import 'package:flutter/material.dart';
import 'package:test_app/web_rtc_old/exercises/RBH.dart';
import 'package:test_app/web_rtc_old/exercises/STS.dart';


class VideoTrackingScreen extends StatelessWidget {
  const VideoTrackingScreen({super.key});

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
          ],
        ),
      ),
    );
  }
}