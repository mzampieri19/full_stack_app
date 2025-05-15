import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:test_app/screens/video_tracking/exercises/RBH.dart';
import 'package:test_app/screens/video_tracking/exercises/STS.dart';
import 'package:test_app/widgets/dashboard_card.dart';

class VideoTrackingDashboard extends StatefulWidget {
  const VideoTrackingDashboard({super.key});

  @override
  State<VideoTrackingDashboard> createState() => _VideoTrackingDashboardState();
}

class _VideoTrackingDashboardState extends State<VideoTrackingDashboard> {
  late VideoElement _videoElement;
  late CanvasElement _canvasElement;

  @override
  void initState() {
    super.initState();
    _initializeCameraAndPoseTracking();
  }

  void _initializeCameraAndPoseTracking() {
    // Create a video element for the camera feed
    _videoElement = VideoElement()
      ..id = 'video-element'
      ..width = 640
      ..height = 480
      ..autoplay = true;

    _videoElement.style
      ..position = 'absolute'
      ..top = '50%'
      ..left = '50%'
      ..transform = 'translate(-50%, -50%)'
      ..zIndex = '1';

    document.body!.append(_videoElement);

    // Create a canvas element for drawing pose landmarks
    _canvasElement = CanvasElement(width: 640, height: 480)
      ..id = 'pose-canvas';

    _canvasElement.style
      ..position = 'absolute'
      ..top = '50%'
      ..left = '50%'
      ..transform = 'translate(-50%, -50%)'
      ..zIndex = '2';

    document.body!.append(_canvasElement);

    // Access the user's camera
    window.navigator.mediaDevices?.getUserMedia({'video': true}).then((stream) {
      _videoElement.srcObject = stream;

      // Initialize pose tracking using MediaPipe
      js.context.callMethod('eval', [
        '''
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

        pose.onResults((results) => {
          ctx.clearRect(0, 0, canvas.width, canvas.height);

          if (results.poseLandmarks) {
            for (const landmark of results.poseLandmarks) {
              ctx.beginPath();
              ctx.arc(landmark.x * canvas.width, landmark.y * canvas.height, 5, 0, 2 * Math.PI);
              ctx.fillStyle = '#00FF00';
              ctx.fill();
            }
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
        title: const Text('Video Tracking Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Add a Positioned widget to place the cards at the bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Sit to Stand Exercise Card
                SizedBox(
                  width: 200,
                  height: 150,
                  child: DashboardCard(
                    icon: Icons.accessibility_new,
                    title: 'Sit to Stand',
                    description: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SitStandExercise(
                            videoElement: _videoElement,
                            canvasElement: _canvasElement,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Raise Both Hands Exercise Card
                SizedBox(
                  width: 200,
                  height: 150,
                  child: DashboardCard(
                    icon: Icons.handyman,
                    title: 'Raise Both Hands',
                    description: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaiseBothHandsExercise(
                            videoElement: _videoElement,
                            canvasElement: _canvasElement,
                          ),
                        ),
                      );
                    },
                  ),
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
    // Clean up the video and canvas elements when the dashboard is disposed
    _videoElement.remove();
    _canvasElement.remove();
    super.dispose();
  }
}