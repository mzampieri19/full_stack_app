import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/video_tracking/setup/dots_setup.dart';
import '../setup/camera_setup.dart';

class SitStandTimer extends StatefulWidget {
  @override
  _SitStandTimerState createState() => _SitStandTimerState();
}

class _SitStandTimerState extends State<SitStandTimer> {
  final CameraSetup cameraSetup = CameraSetup();
  List<Offset> joints = [];

  @override
  void initState() {
    super.initState();
    cameraSetup.initializeCamera(_onJointDetected);
  }

  void _onJointDetected(dynamic image) {
    // Replace this with your joint detection logic
    setState(() {
      joints = [Offset(100, 200), Offset(150, 300)]; // Example positions
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
      appBar: AppBar(title: Text("Sit-Stand Timer")),
      body: Stack(
        children: [
          if (cameraSetup.isInitialized)
            CameraPreview(cameraSetup.cameraController),
          DotTracker(jointPositions: joints),
          // Add timer UI here
        ],
      ),
    );
  }
}
