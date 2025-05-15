import 'dart:async';
import 'dart:html';
import 'dart:js' as js;

import 'package:flutter/material.dart';

/**
 * VideoTrackingScreen is a StatefulWidget that handles video tracking using the MediaPipe Pose library.
 * It captures video from the user's camera, processes it to detect poses,
 * and provides a timer for sit-stand transitions.
 * It also tracks the number of times the user raises their hands.
 */
///
class VideoTrackingScreen extends StatefulWidget {
  const VideoTrackingScreen({super.key});

  @override
  State<VideoTrackingScreen> createState() => _VideoTrackingScreenState();
}

/**
 * _VideoTrackingScreenState is the state class for VideoTrackingScreen.
 * It manages the state of the video tracking process, including hand raise count,
 * sit-stand timer, and pose detection.
 */
///
class _VideoTrackingScreenState extends State<VideoTrackingScreen> {
  int _raiseHandsCount = 0; // Track the number of times hands are raised
  bool _isSitting = true; // Track if the user is sitting
  bool _timerRunning = false; // Track if the sit-stand timer is running
  Stopwatch _sitStandTimer = Stopwatch(); // Stopwatch for sit-stand timer
  double? _initialHipY; // Initial Y-coordinate of the hips for sit-stand detection

  /**
   * formattedSitStandTime is a getter that formats the elapsed time of the sit-stand timer.
   * It returns a string in the format "MM:SS.ms" where MM is minutes, SS is seconds, and ms is milliseconds.
   * The elapsed time is calculated using the Stopwatch class.
   * The time is formatted to ensure two digits for minutes and seconds, and two digits for milliseconds.
   */
  ///
  String get _formattedSitStandTime {
    final elapsed = _sitStandTimer.elapsed;
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;
    return '$minutes:$seconds.${milliseconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _initializePoseTracking(); // Initialize pose tracking
    _updateTimerUI(); // Start the timer UI update loop
  }

  /**
   * _updateTimerUI is a method that updates the timer UI every 50 milliseconds.
   * It checks if the timer is running and updates the state accordingly.
   */
  ///
  void _updateTimerUI() async {
    while (true) {
      if (_timerRunning) {
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 50)); // Update every 50 milliseconds
    }
  }

  /**
   * _initializePoseTracking is a method that sets up the video tracking using the MediaPipe Pose library.
   * It creates a video element and a canvas element for rendering the pose landmarks.
   * It also sets up the camera and handles pose detection results.
   */
  ///
  void _initializePoseTracking() {
    final videoElement = VideoElement() // Create a video element for capturing video
      ..id = 'video-element'
      ..width = 640
      ..height = 480
      ..autoplay = true
      ..style.position = 'absolute'
      ..style.top = '50%'
      ..style.left = '50%'
      ..style.transform = 'translate(-50%, -50%)'
      ..style.zIndex = '1'
      ..style.borderRadius = '10px';

    document.body!.append(videoElement);

    final canvas = CanvasElement(width: 640, height: 480) // Create a canvas element for rendering pose landmarks
      ..id = 'pose-canvas'
      ..style.position = 'absolute'
      ..style.top = '50%'
      ..style.left = '50%'
      ..style.transform = 'translate(-50%, -50%)'
      ..style.zIndex = '2'
      ..style.pointerEvents = 'none';

    document.body!.append(canvas);

    // Set up the JavaScript functions to be called from Dart
    js.context['incrementRaiseCount'] = js.allowInterop(() {
      setState(() {
        _raiseHandsCount++;
      });
    });

    // Function to update sit-stand status based on hip Y-coordinate
    js.context['sitStandUpdate'] = js.allowInterop((double avgHipY) {
      if (_initialHipY == null) {
        _initialHipY = avgHipY;
      }
      // Calculate the displacement from the initial hip Y-coordinate
      // and determine if the user is sitting or standing
      final displacement = _initialHipY! - avgHipY;
      final standingThreshold = 0.15;

      // Check if the user is standing
      if (!_timerRunning && displacement > standingThreshold) {
        _sitStandTimer.reset();
        _sitStandTimer.start();
        _timerRunning = true;
      }
      // Check if the user is sitting
      if (_timerRunning && displacement < 0.05) {
        _sitStandTimer.stop();
        _timerRunning = false;
        _initialHipY = avgHipY;  // Reset to the current sitting position
      }

      setState(() {});
    });
    // Request access to the user's camera
    // and start the video stream
    window.navigator.mediaDevices?.getUserMedia({'video': true}).then((stream) {
      videoElement.srcObject = stream;

      // Load the MediaPipe Pose library and set up the pose detection
      js.context.callMethod('eval', [
        r'''
        const videoElement = document.getElementById('video-element');
        const canvas = document.getElementById('pose-canvas');
        const ctx = canvas.getContext('2d');

        const pose = new Pose({
          locateFile: (file) => 'https://cdn.jsdelivr.net/npm/@mediapipe/pose/' + file
        });

        pose.setOptions({
          modelComplexity: 1,
          smoothLandmarks: true,
          enableSegmentation: false,
          smoothSegmentation: false,
          minDetectionConfidence: 0.5,
          minTrackingConfidence: 0.5
        });

        let handsRaisedPreviously = false;

        pose.onResults((results) => {
          ctx.clearRect(0, 0, canvas.width, canvas.height);

          if (results.poseLandmarks) {
            for (const landmark of results.poseLandmarks) {
              ctx.beginPath();
              ctx.arc(landmark.x * canvas.width, landmark.y * canvas.height, 5, 0, 2 * Math.PI);
              ctx.fillStyle = '#00FF00';
              ctx.fill();
            }

            const leftHip = results.poseLandmarks[23];
            const rightHip = results.poseLandmarks[24];
            const avgHipY = (leftHip.y + rightHip.y) / 2;
            window.sitStandUpdate(avgHipY);
          }
        });

        const camera = new Camera(videoElement, {
          onFrame: async () => {
            await pose.send({image: videoElement});
          },
          width: 640,
          height: 480
        });
        camera.start();
        '''
      ]);
    }).catchError((err) {
      print('Error accessing camera: $err');
    });
  }

  /**
   * build method constructs the UI for the VideoTrackingScreen.
   * It includes a Scaffold with an AppBar and a Stack for overlaying the timer UI.
   */
  ///
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
                  _timerRunning
                      ? 'Standing... Time: $_formattedSitStandTime'
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
