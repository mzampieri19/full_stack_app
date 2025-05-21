import 'package:flutter/material.dart';
import 'package:test_app/web_rtc_old/setup/camera_setup.dart';

class SitStandExercise extends StatefulWidget {
  const SitStandExercise({super.key});

  @override
  State<SitStandExercise> createState() => _SitStandExerciseState();
}

class _SitStandExerciseState extends State<SitStandExercise> {
  double? _initialHipY;
  final Stopwatch _timer = Stopwatch();
  bool _timerRunning = false;

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