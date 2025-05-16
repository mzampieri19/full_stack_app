import 'package:flutter/material.dart';
import 'package:test_app/video_tracking/setup/camera_setup.dart';

class RaiseBothHandsExercise extends StatefulWidget {
  const RaiseBothHandsExercise({super.key});

  @override
  State<RaiseBothHandsExercise> createState() => _RaiseBothHandsExerciseState();
}

class _RaiseBothHandsExerciseState extends State<RaiseBothHandsExercise> {
  int _raiseCount = 0;

  @override
  void initState() {
    super.initState();
    initializePoseTracking((_) {}, _onBothHandsRaised);
  }

  void _onBothHandsRaised() {
    setState(() {
      _raiseCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise Both Hands Exercise'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Raise both hands to start counting!',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              'Reps: $_raiseCount',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}