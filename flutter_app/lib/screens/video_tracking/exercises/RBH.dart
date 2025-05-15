import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/material.dart';

class RaiseBothHandsExercise extends StatefulWidget {
  final VideoElement videoElement;
  final CanvasElement canvasElement;

  const RaiseBothHandsExercise({
    super.key,
    required this.videoElement,
    required this.canvasElement,
  });

  @override
  State<RaiseBothHandsExercise> createState() => _RaiseBothHandsExerciseState();
}

class _RaiseBothHandsExerciseState extends State<RaiseBothHandsExercise> {
  int raiseCount = 0;
  bool handsRaised = false; // Track if hands are currently raised

  @override
  void initState() {
    super.initState();
    _initializePoseTracking();
  }

  void _initializePoseTracking() {
    // Attach JavaScript interop to call the `update` function
    js.context['updateRaiseBothHands'] = js.allowInterop((List<dynamic> landmarks) {
      update(landmarks);
    });
  }

  void update(List<dynamic> landmarks) {
    // Extract relevant landmarks
    final leftShoulder = landmarks[11];
    final rightShoulder = landmarks[12];
    final leftWrist = landmarks[15];
    final rightWrist = landmarks[16];

    // Check if both hands are raised above the shoulders
    final handsAreRaised = leftWrist['y'] < leftShoulder['y'] && rightWrist['y'] < rightShoulder['y'];

    // Check if hands were raised and then lowered
    if (handsAreRaised && !handsRaised) {
      setState(() {
        handsRaised = true; // Mark hands as raised
      });
    } else if (!handsAreRaised && handsRaised) {
      setState(() {
        handsRaised = false; // Reset handsRaised
        raiseCount++; // Increment the counter
      });
    }
  }

  void reset() {
    setState(() {
      raiseCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise Both Hands Exercise'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Perform the Raise Both Hands Exercise',
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
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  'Count: $raiseCount',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: reset,
                  child: const Text('Reset Counter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up JavaScript interop
    js.context.deleteProperty('updateRaiseBothHands');
    super.dispose();
  }
}