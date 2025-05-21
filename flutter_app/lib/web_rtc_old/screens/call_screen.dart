import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/**
 * CallScreen is a StatefulWidget that represents a video call screen.
 * It allows users to create or join a video call room using WebRTC and Firebase Realtime Database.
 * The screen includes local and remote video views, and buttons to start or join a call.
 * The screen uses the flutter_webrtc package for WebRTC functionality and the firebase_database package for real-time communication.
 */
///
class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

/**
 * _CallScreenState is the state class for CallScreen.
 * It manages the state of the video call, including local and remote video streams, and room management.
 * It also handles the initialization of video renderers, starting local streams, and room creation/joining.
 */
///
class _CallScreenState extends State<CallScreen> {
  late RTCPeerConnection peerConnection;
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  final roomId = 'testRoom';

  bool isCaller = true;

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    peerConnection.close();
    super.dispose();
  }

  /**
   * initRenderers initializes the local and remote video renderers.
   * It sets up the video rendering for local and remote streams.
   * This method is called during the initialization of the state.
   */
  ///
  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  /**
   * startWebRTC starts the WebRTC connection.
   * It sets up the peer connection and either creates or joins a room based on the isCaller flag.
   */
  ///
  Future<void> startWebRTC() async {
    await _setupPeerConnection();

    if (isCaller) {
      await _createRoom();
    } else {
      await _joinRoom();
    }
  }

  /**
   * _setupPeerConnection sets up the WebRTC peer connection.
   * It initializes the local and remote video streams and handles
   * ICE candidates for establishing the connection.
   */
  ///
  Future<void> _setupPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    peerConnection = await createPeerConnection(config);

    // Local stream
    final stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    localRenderer.srcObject = stream;
    for (var track in stream.getTracks()) {
      peerConnection.addTrack(track, stream);
    }

    // Remote stream
    peerConnection.onTrack = (event) {
      if (event.track.kind == 'video') {
        remoteRenderer.srcObject = event.streams[0];
      }
    };
  }

  /**
   * _createRoom creates a new room in Firebase Realtime Database.
   * It sets up the offer and ICE candidates for the caller.
   */
  ///
  Future<void> _createRoom() async {
    final roomRef = FirebaseDatabase.instance.ref('rooms/$roomId');
    final callerCandidatesRef = roomRef.child('callerCandidates');

    peerConnection.onIceCandidate = (candidate) {
      callerCandidatesRef.push().set({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
        };

    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    await roomRef.child('offer').set({
      'type': offer.type,
      'sdp': offer.sdp,
    });

    // Listen for answer
    roomRef.child('answer').onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        final answer = RTCSessionDescription(data['sdp'], data['type']);
        await peerConnection.setRemoteDescription(answer);
      }
    });

    // Callee ICE candidates
    roomRef.child('calleeCandidates').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map;
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      peerConnection.addCandidate(candidate);
    });
  }

  /**
   * _joinRoom joins an existing room in Firebase Realtime Database.
   * It sets up the answer and ICE candidates for the callee.
   */
  ///
  Future<void> _joinRoom() async {
    final roomRef = FirebaseDatabase.instance.ref('rooms/$roomId');
    final offerSnapshot = await roomRef.child('offer').get();

    if (!offerSnapshot.exists) {
      print('No offer found.');
      return;
    }

    final data = offerSnapshot.value as Map;
    final offer = RTCSessionDescription(data['sdp'], data['type']);
    await peerConnection.setRemoteDescription(offer);

    final answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    await roomRef.child('answer').set({
      'type': answer.type,
      'sdp': answer.sdp,
    });

    // ICE candidate handling
    final calleeCandidatesRef = roomRef.child('calleeCandidates');
    peerConnection.onIceCandidate = (candidate) {
      calleeCandidatesRef.push().set({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
        };

    roomRef.child('callerCandidates').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map;
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      peerConnection.addCandidate(candidate);
    });
  }

  /**
   * The build method returns a Scaffold widget that contains the AppBar and the body of the screen.
   * The body includes local and remote video views, and buttons to start or join a call.
   */
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebRTC Firebase')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Local Video"),
          Container(
            height: 200,
            color: Colors.black,
            child: RTCVideoView(localRenderer, mirror: true),
          ),
          const SizedBox(height: 10),
          const Text("Remote Video"),
          Container(
            height: 200,
            color: Colors.black,
            child: RTCVideoView(remoteRenderer),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCaller = true;
                  });
                  startWebRTC();
                },
                child: const Text("Start Call (Caller)"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCaller = false;
                  });
                  startWebRTC();
                },
                child: const Text("Join Call (Callee)"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}