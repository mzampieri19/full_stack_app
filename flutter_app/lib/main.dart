import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/screens/auth_screen.dart';

/**
 * Main entry point of the Flutter application.
 * It initializes Firebase and loads environment variables from a .env file.
 * It sets up the app theme and home screen.
 */
///
void main() async {
  await dotenv.load(fileName: "/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      databaseURL: dotenv.env['FIREBASE_DATABASE_URL']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID']!,
    ),
  );
  await dotenv.load();
  runApp(const MyApp());
}

/**
 * MyApp is the main widget of the application.
 * It sets up the MaterialApp with a title, theme, and home screen.
 */
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /**
   * The build method returns a MaterialApp widget that contains the title, theme, and home screen.
   * The home screen is set to AuthScreen with empty username and email.
   */
   ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(username: '', email: '',)
    );
  }
}
