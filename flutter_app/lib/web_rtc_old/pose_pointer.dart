import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/**
 * PosePainter is a CustomPainter that draws the pose landmarks on a canvas.
 * It takes a list of PoseLandmark objects and draws circles at their positions.
 * The circles are drawn in green color with a specified stroke width.
 */
///
class PosePainter extends CustomPainter {
  final List<PoseLandmark> landmarks;
  PosePainter(this.landmarks);

  /**
   * paint method is overridden to perform custom painting on the canvas.
   * It iterates through the landmarks and draws circles at their positions.
   * The circles are filled with green color and have a specified stroke width.
   */
  ///
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

  /**
   * shouldRepaint method is overridden to determine if the painter should repaint.
   * It compares the current landmarks with the old landmarks to decide if a repaint is needed.
   */
  ///
  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) =>
      oldDelegate.landmarks != landmarks;
}