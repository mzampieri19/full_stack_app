import 'dart:html';

/**
 * initializePoseTracking initializes the pose tracking using MediaPipe Pose.
 * It sets up the video element, canvas, and JavaScript functions for pose detection.
 */
///
void drawPoseLandmarks(List landmarks) {
  final canvas = document.getElementById('pose-canvas') as CanvasElement;
  final ctx = canvas.context2D;

  ctx.clearRect(0, 0, canvas.width!, canvas.height!);

  for (final landmark in landmarks) {
    ctx.beginPath();
    ctx.arc(landmark['x'] * canvas.width!, landmark['y'] * canvas.height!, 5, 0, 2 * 3.14159);
    ctx.fillStyle = '#00FF00';
    ctx.fill();
  }
}