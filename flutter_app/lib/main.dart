import 'dart:html' as html;
import 'dart:ui_web' as ui show platformViewRegistry;
import 'package:flutter/material.dart';
import 'package:test_app/screens/auth_screen.dart';
import 'package:test_app/screens/dashboard_screen.dart';
import 'package:test_app/screens/video_tracking_screen.dart';
import 'package:test_app/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/**
 * registerViewFactories function registers a view factory for the hcaptcha-container.
 * It creates a DivElement with specific styles and an ID.
 * This is used to display the hCaptcha widget in the Flutter web application.
 * This was used for an earlier implementation of the hCaptcha widget, now using a different approach.
 */
///
void registerViewFactories() {
  ui.platformViewRegistry.registerViewFactory(
    'hcaptcha-container',
    (int viewId) => html.DivElement()
      ..id = 'hcaptcha-container'
      ..style.width = '300px'
      ..style.height = '150px'
      ..style.display = 'block',
  );
}

/**
 * main function is the entry point of the Flutter web application.
 * It loads environment variables from a .env file, registers view factories,
 * initializes the AuthService, and runs the MyApp widget.
 */
///
Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  registerViewFactories(); // Register the view factories
  AuthService.initialize();
  runApp(const MyApp());
}

/**
 * MyApp is the main widget of the Flutter application.
 * It sets up the MaterialApp with a title, theme, and home screen.
 * The home screen is set to AuthScreen, which handles user authentication.
 */
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /**
   * The build method returns a MaterialApp widget with a title, theme, and home screen.
   * The home screen is set to AuthScreen, which handles user authentication.
   */
   ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: VideoTrackingScreen()
      //home: ChatScreen(currentUser: 'Michael', otherUser: 'icloud', senderEmail: 'michelangeloz03@gmail.com', recieverEmail: 'michii03@icloud.com')
      //home: AiassistantScreen(username: 'Michael', email: 'michelangeloz03@gmail.com',),
      //home: AuthScreen(username:'', email:''), // Set the home screen to AuthScreen
      home: DashboardScreen(
        username: 'Michael', 
        email: 'michelangeloz03@gmail.com', 
        users: [
                {
                  'username': 'Michael',
                  'email': 'michelangeloz03@gmail.com',
                  'password': 'Michi.2003!',
                },
                {
                  'username': 'icloud',
                  'email': 'michii03@icloud.com',
                  'password': 'Michi.2003!',
                },
                {
                  'username': 'Brandeis',
                  'email': 'mzampieri@brandeis.edu',
                  'password': 'Michi.2003!',
                },
                {
                  'username': 'Imago',
                  'email': 'michelangelo.zampieri@imagorehab.com',
                  'password': 'Michi.2003!',
                },
              ]
      )
    );
  }
}