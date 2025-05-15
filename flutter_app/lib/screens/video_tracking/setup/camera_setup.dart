import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraSetup {
  late CameraController cameraController;
  bool isInitialized = false;

  Future<void> initializeCamera(Function onJointDetected) async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
      await cameraController.initialize();
      
      // Set up frame processing here if needed
      cameraController.startImageStream((image) {
        // Call the joint detection callback
        onJointDetected(image);
      });

      isInitialized = true;
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void dispose() {
    if (isInitialized) {
      cameraController.dispose();
    }
  }
}
