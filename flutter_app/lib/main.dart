import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:test_app/screens/dashboard_screen.dart';
import 'package:test_app/video_tracking/new_call_screen.dart';
import 'app_state.dart';

import 'package:universal_html/html.dart' as html;
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoTrackingScreen()
    );
  }
}
