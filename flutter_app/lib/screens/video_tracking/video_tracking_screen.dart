import 'package:flutter/material.dart';
import 'package:test_app/screens/video_tracking/exercises/RBH.dart';
import 'package:test_app/screens/video_tracking/exercises/STS.dart';
import 'package:test_app/screens/video_tracking/setup/camera_setup.dart';
import 'dart:html';
import 'dart:js' as js;

class VideoTrackingScreen extends StatefulWidget {
  const VideoTrackingScreen({super.key});

  @override
  State<VideoTrackingScreen> createState() => _VideoTrackingScreenState();
}

class _VideoTrackingScreenState extends State<VideoTrackingScreen> {
  final SitStandExercise sitStandExercise = SitStandExercise(
    videoElement: VideoElement(),
    canvasElement: CanvasElement(),
  );
  final RaiseBothHandsExercise raiseBothHandsExercise = RaiseBothHandsExercise(
    videoElement: VideoElement(),
    canvasElement: CanvasElement(),
  );

  @override
  void initState() {
    super.initState();
    setupCameraElements();

    // js.context['sitStandUpdate'] = js.allowInterop((double avgHipY) {
    //   sitStandExercise.update(avgHipY);
    //   setState(() {});
    // });

    // js.context['incrementRaiseCount'] = js.allowInterop(() {
    //   raiseBothHandsExercise.update();
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tracking'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sitStandExercise.timerRunning
                      ? 'Standing... Time: ${sitStandExercise.formattedTime}'
                      : 'Please stand to start the timer',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    document.getElementById('video-element')?.remove();
    document.getElementById('pose-canvas')?.remove();
    super.dispose();
  }
}