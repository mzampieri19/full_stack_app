import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final List<PoseLandmark> landmarks;
  PosePainter(this.landmarks);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0
      ..style = PaintingStyle.fill;

    for (final landmark in landmarks) {
      final x = landmark.x * size.width;
      final y = landmark.y * size.height;
      canvas.drawCircle(Offset(x, y), 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) =>
      oldDelegate.landmarks != landmarks;
}