import 'dart:html';
import 'dart:js' as js;

// Camera setup (video and canvas elements)
void setupCameraElements() {
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
}