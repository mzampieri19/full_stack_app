import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:test_app/screens/dashboard_screen.dart';
import 'app_state.dart';
import 'call_screen.dart';

import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final dbUrl = dotenv.env['FIREBASE_DATABASE_URL'];
  if (dbUrl == null) {
    throw Exception('FIREBASE_DATABASE_URL not found in .env file');
  }
  final db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: dbUrl,
  );
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID']!,
    ),
  );
  // Initialize WebRTC for web
  if (WebRTC.platformIsWeb) {
    await html.window.navigator.mediaDevices?.getUserMedia({'audio': true, 'video': true});
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
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
      home: const DashboardScreen(
        username: 'Michael',
        email: 'email@gmail.com',
        users:[],
      )
    );
  }
}