import 'dart:async';
import 'dart:html';
import 'dart:js' as js;

import 'package:flutter/material.dart';

class VideoTrackingScreen extends StatefulWidget {
  const VideoTrackingScreen({super.key});

  @override
  State<VideoTrackingScreen> createState() => _VideoTrackingScreenState();
}

class _VideoTrackingScreenState extends State<VideoTrackingScreen> {
  int _raiseHandsCount = 0;
  bool _isSitting = true;
  bool _timerRunning = false;
  Stopwatch _sitStandTimer = Stopwatch();
  double? _initialHipY;

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
    _initializePoseTracking();
    _updateTimerUI();
  }

  void _updateTimerUI() async {
    while (true) {
      if (_timerRunning) {
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _initializePoseTracking() {
    final videoElement = VideoElement()
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

    final canvas = CanvasElement(width: 640, height: 480)
      ..id = 'pose-canvas'
      ..style.position = 'absolute'
      ..style.top = '50%'
      ..style.left = '50%'
      ..style.transform = 'translate(-50%, -50%)'
      ..style.zIndex = '2'
      ..style.pointerEvents = 'none';

    document.body!.append(canvas);

    js.context['incrementRaiseCount'] = js.allowInterop(() {
      setState(() {
        _raiseHandsCount++;
      });
    });

    js.context['sitStandUpdate'] = js.allowInterop((double avgHipY) {
      if (_initialHipY == null) {
        _initialHipY = avgHipY;
      }

      final displacement = _initialHipY! - avgHipY;
      final standingThreshold = 0.15;

      if (!_timerRunning && displacement > standingThreshold) {
        _sitStandTimer.reset();
        _sitStandTimer.start();
        _timerRunning = true;
      }

      if (_timerRunning && displacement < 0.05) {
        _sitStandTimer.stop();
        _timerRunning = false;
        _initialHipY = avgHipY;  // Reset to the current sitting position
      }

      setState(() {});
    });

    window.navigator.mediaDevices?.getUserMedia({'video': true}).then((stream) {
      videoElement.srcObject = stream;

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
