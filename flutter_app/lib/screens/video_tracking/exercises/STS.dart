import 'dart:html';
import 'package:flutter/material.dart';

class SitStandExercise extends StatelessWidget {
  final VideoElement videoElement;
  final CanvasElement canvasElement;

  const SitStandExercise({
    super.key,
    required this.videoElement,
    required this.canvasElement,
  });

  bool get timerRunning => false;

  get formattedTime => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sit to Stand Exercise'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Perform the Sit to Stand Exercise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Follow the instructions and ensure proper form.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void update(double avgHipY) {
    // Update the exercise state based on the average hip Y position
    

  }
}