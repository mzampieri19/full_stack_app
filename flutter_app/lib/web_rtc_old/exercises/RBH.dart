import 'package:flutter/material.dart';
import 'package:test_app/web_rtc_old/setup/camera_setup.dart';

/**
 * RaiseBothHandsExercise is a StatefulWidget that represents an exercise screen
 * where the user is prompted to raise both hands.
 * It tracks the user's pose using ML Kit and counts the number of times both hands are raised.
 * The screen includes a message prompting the user to raise both hands and displays the count of repetitions.
 */
///
class RaiseBothHandsExercise extends StatefulWidget {
  const RaiseBothHandsExercise({super.key});

  @override
  State<RaiseBothHandsExercise> createState() => _RaiseBothHandsExerciseState();
}

/**
 * _RaiseBothHandsExerciseState is the state class for RaiseBothHandsExercise.
 * It manages the state of the exercise, including the count of repetitions.
 * It initializes pose tracking and updates the count when both hands are raised.
 */
///
class _RaiseBothHandsExerciseState extends State<RaiseBothHandsExercise> {
  int _raiseCount = 0;

  @override
  void initState() {
    super.initState();
    initializePoseTracking((_) {}, _onBothHandsRaised);
  }

  /**
   * _onBothHandsRaised is a callback function that is called when both hands are raised.
   * It updates the state to increment the raise count.
   */
   ///
  void _onBothHandsRaised() {
    setState(() {
      _raiseCount++;
    });
  }

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes a message prompting the user to raise both hands and displays the count of repetitions.
   */
   ///
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