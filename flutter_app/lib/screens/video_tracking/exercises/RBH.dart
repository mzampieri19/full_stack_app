import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/video_tracking/setup/dots_setup.dart';
import '../setup/camera_setup.dart';

class HandRaiseCounter extends StatefulWidget {
  @override
  _HandRaiseCounterState createState() => _HandRaiseCounterState();
}

class _HandRaiseCounterState extends State<HandRaiseCounter> {
  final CameraSetup cameraSetup = CameraSetup();
  List<Offset> joints = [];
  int handRaiseCount = 0;

  @override
  void initState() {
    super.initState();
    cameraSetup.initializeCamera(_onJointDetected);
  }

  void _onJointDetected(dynamic image) {
    // Replace with your hand raise detection logic
    setState(() {
      joints = [Offset(200, 300), Offset(250, 350)]; // Example positions
    });
  }

  @override
  void dispose() {
    cameraSetup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hand Raise Counter")),
      body: Stack(
        children: [
          if (cameraSetup.isInitialized)
            CameraPreview(cameraSetup.cameraController),
          DotTracker(jointPositions: joints),
          // Add counter UI here
        ],
      ),
    );
  }
}
