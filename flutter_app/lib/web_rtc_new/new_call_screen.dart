import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:test_app/web_rtc_old/pose_pointer.dart';

class VideoTrackingScreen extends StatefulWidget {
  const VideoTrackingScreen({super.key});

  @override
  State<VideoTrackingScreen> createState() => _VideoTrackingScreenState();
}

class _VideoTrackingScreenState extends State<VideoTrackingScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  late final PoseDetector _poseDetector;
  List<PoseLandmark> _landmarks = [];
  String? _roomId;
  // ignore: unused_field
  DatabaseReference? _roomRef;
  // ignore: unused_field
  Uint8List? _data;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startLocalStream();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startLocalStream() async {
    final stream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});
    _localRenderer.srcObject = stream;
    setState(() {
      _localStream = stream;
    });
    // Pose tracking: Only works on web with captureFrame, see note below
    _startPoseTracking();
  }

  Future<void> _startPoseTracking() async {
  if (!kIsWeb) return;
  while (mounted) {
    try {
      // Get the video track from the local stream
      final videoTracks = _localStream?.getVideoTracks();
      if (videoTracks == null || videoTracks.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 200));
        continue;
      }
      final track = videoTracks.first;

      // Use captureFrame() on the video track (web only, flutter_webrtc >=0.9.40)
      final buffer = await track.captureFrame();
      final bytes = buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final inputImage = InputImage.fromBytes(
          bytes: byteData.buffer.asUint8List(),
          inputImageData: InputImageData(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            imageRotation: InputImageRotation.rotation0deg,
            inputImageFormat: InputImageFormat.bgra8888,
            planeData: [],
          ),
        );
        final poses = await _poseDetector.processImage(inputImage);
        if (poses.isNotEmpty) {
          setState(() {
            _landmarks = poses.first.landmarks.values.toList();
          });
        }
      }
        } catch (e) {
      // Optionally log error
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

  Future<void> _createRoom() async {
    // Firebase Realtime Database signaling (adapt as needed)
    final db = FirebaseDatabase.instance.ref();
    final roomRef = db.child('rooms').push();
    await roomRef.set({'created': DateTime.now().toIso8601String()});
    setState(() {
      _roomId = roomRef.key;
      _roomRef = roomRef;
    });
    // TODO: Add WebRTC signaling logic here (offer, ICE, etc.)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room created: $_roomId')));
  }

  Future<void> _joinRoom() async {
    String? inputRoomId;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Room ID'),
          content: TextField(
            onChanged: (value) => inputRoomId = value,
            decoration: const InputDecoration(hintText: "Room ID"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (inputRoomId != null && inputRoomId!.isNotEmpty) {
      final db = FirebaseDatabase.instance.ref();
      final roomRef = db.child('rooms/$inputRoomId');
      setState(() {
        _roomId = inputRoomId;
        _roomRef = roomRef;
      });
      // TODO: Add WebRTC signaling logic here (answer, ICE, etc.)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined room: $_roomId')));
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Video Tracking')),
      body: Column(
        children: [
          // Local video with pose overlay
          Expanded(
            child: Stack(
              children: [
                RTCVideoView(_localRenderer, mirror: true),
                CustomPaint(
                  painter: PosePainter(_landmarks),
                  child: Container(),
                ),
              ],
            ),
          ),
          // Remote video
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
          // Room controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _createRoom,
                  child: const Text('Create Room'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _joinRoom,
                  child: const Text('Join Room'),
                ),
              ],
            ),
          ),
          if (_roomId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText('Room ID: $_roomId'),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy Room ID',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _roomId!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Room ID copied!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      );
    }
  }
      