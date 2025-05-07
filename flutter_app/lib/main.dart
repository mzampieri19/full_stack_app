import 'dart:html' as html;
import 'dart:ui_web' as ui show platformViewRegistry;
import 'package:flutter/material.dart';
import 'package:test_app/services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


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

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  registerViewFactories(); // Register the view factories
  AuthService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(username: '',),
    );
  }
}