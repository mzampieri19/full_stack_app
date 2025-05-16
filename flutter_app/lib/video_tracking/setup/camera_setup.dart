import 'dart:html';
import 'dart:js' as js;

void initializePoseTracking(Function(double) sitStandCallback, Function() raiseHandCallback) {
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

  js.context['sitStandUpdate'] = js.allowInterop(sitStandCallback);
  js.context['raiseHandUpdate'] = js.allowInterop(raiseHandCallback);

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

          const leftWrist = results.poseLandmarks[15];
          const rightWrist = results.poseLandmarks[16];
          const leftShoulder = results.poseLandmarks[11];
          const rightShoulder = results.poseLandmarks[12];
          const leftHandRaised = leftWrist.y < leftShoulder.y;
          const rightHandRaised = rightWrist.y < rightShoulder.y;

          if (leftHandRaised && rightHandRaised) {
            window.raiseHandUpdate();
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
