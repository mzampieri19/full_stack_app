import 'package:flutter/material.dart';
import 'package:test_app/web_rtc_old/setup/camera_setup.dart';

/**
 * SitStandExercise is a StatefulWidget that represents an exercise screen
 * where the user is prompted to perform a sit-stand exercise.
 * It tracks the user's pose using ML Kit and measures the time spent standing.
 * The screen includes a message prompting the user to stand and displays the elapsed time.
 */
 ///
class SitStandExercise extends StatefulWidget {
  const SitStandExercise({super.key});

  @override
  State<SitStandExercise> createState() => _SitStandExerciseState();
}

/**
 * _SitStandExerciseState is the state class for SitStandExercise.
 * It manages the state of the exercise, including the timer for standing time.
 * It initializes pose tracking and updates the timer based on the user's hip position.
 */
 ///
class _SitStandExerciseState extends State<SitStandExercise> {
  double? _initialHipY;
  final Stopwatch _timer = Stopwatch();
  bool _timerRunning = false;

  /**
   * _formatTime function formats the elapsed time from the stopwatch
   * into a string in the format "MM:SS.ms".
   * It calculates the minutes, seconds, and milliseconds from the elapsed time
   */
  ///
  String get _formattedTime {
    final elapsed = _timer.elapsed;
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;
    return '$minutes:$seconds.${milliseconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    initializePoseTracking(_onHipPositionUpdate, () {});
  }

  /**
   * _onHipPositionUpdate is a callback function that is called when the user's hip position is updated.
   * It calculates the displacement from the initial hip position and starts/stops the timer accordingly.
   */
   ///
  void _onHipPositionUpdate(double avgHipY) {
    _initialHipY ??= avgHipY;

    final displacement = _initialHipY! - avgHipY;
    const standingThreshold = 0.15;

    if (!_timerRunning && displacement > standingThreshold) {
      _timer.start();
      _timerRunning = true;
    }

    if (_timerRunning && displacement < 0.05) {
      _timer.stop();
      _timerRunning = false;
      _initialHipY = avgHipY;
    }

    setState(() {});
  }

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes a message prompting the user to stand and displays the elapsed time.
   */
   ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sit-Stand Exercise'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              _timerRunning ? 'Standing...' : 'Please stand to start the timer',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              'Time: $_formattedTime',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}