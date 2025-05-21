import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'; // Uncomment if using ML Kit
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui_web';

class VideoTrackingScreen extends StatefulWidget {
  const VideoTrackingScreen({super.key});

  @override
  State<VideoTrackingScreen> createState() => _VideoTrackingScreenState();
}

class _VideoTrackingScreenState extends State<VideoTrackingScreen> {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _roomId;

  // For pose tracking (pseudo-code, see comments)
  // late final PoseDetector _poseDetector;
  // bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startLocalStream();
    // _poseDetector = PoseDetector(options: PoseDetectorOptions());
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
    // _startPoseTracking(stream); // Uncomment if implementing pose tracking
  }

  // --- ROOM LOGIC ---

  Future<void> _createRoom() async {
    // Replace with your backend endpoint
    final response = await http.post(Uri.parse('$baseUrl/api/rooms'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _roomId = data['roomId'];
      });
      await _setupConnection(isCaller: true, roomId: _roomId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room created: $_roomId')));
    }
  }

  Future<void> _joinRoom() async {
    final roomId = await _promptForRoomId();
    if (roomId == null) return;
    setState(() {
      _roomId = roomId;
    });
    await _setupConnection(isCaller: false, roomId: roomId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined room: $roomId')));
  }

  Future<String?> _promptForRoomId() async {
    String? input;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Room ID'),
          content: TextField(
            onChanged: (value) => input = value,
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
    return input;
  }

  Future<void> _setupConnection({required bool isCaller, required String roomId}) async {
    // This is a simplified placeholder. You must implement your own signaling logic.
    final config = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    _peerConnection = await createPeerConnection(config);

    // Add local stream tracks
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
    }

    // Handle remote stream
    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    // TODO: Implement signaling with your backend (offer/answer/ICE exchange)
    // Use HTTP/WebSocket to send/receive SDP and ICE candidates
  }

  // --- POSE TRACKING LOGIC (pseudo-code) ---
  // void _startPoseTracking(MediaStream stream) {
  //   // Use ML Kit or another package to process video frames for pose detection
  //   // For each frame, call _poseDetector.processImage(...)
  //   // Update UI with pose results
  // }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.dispose();
    // _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Tracking')),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
          Row(
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
          if (_roomId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Room ID: $_roomId'),
            ),
        ],
      ),
    );
  }
}