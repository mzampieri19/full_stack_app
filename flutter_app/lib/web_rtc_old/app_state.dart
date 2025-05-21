// app_state.dart
import 'package:flutter/material.dart';

/**
 * AppState is a ChangeNotifier class that manages the state of the application.
 * It tracks whether the user is connected, if a thumbs-up gesture is detected,
 * if the user is standing, and the time taken to complete the exercise.
 */
///
class AppState with ChangeNotifier {
  bool _isConnected = false;
  bool _isThumbsUpDetected = false;
  bool _isStanding = false;
  DateTime? _startTime;
  Duration? _completionTime;

  // Public getters
  bool get isConnected => _isConnected;
  bool get isThumbsUpDetected => _isThumbsUpDetected;
  bool get isStanding => _isStanding;
  Duration? get completionTime => _completionTime;
  DateTime? get startTime => _startTime; // Add this getter

  /**
   * setConnected sets the connection status of the application.
   * It updates the _isConnected variable and notifies listeners of the change.
   * @param value The new connection status (true or false).
   */
  ///
  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  /**
   * detectThumbsUp detects if the user has made a thumbs-up gesture.
   * It updates the _isThumbsUpDetected variable and sets the start time.
   * It notifies listeners of the change.
   */
   ///
  void detectThumbsUp() {
    if (!_isThumbsUpDetected) {
      _isThumbsUpDetected = true;
      _startTime = DateTime.now();
      notifyListeners();
    }
  }

  /**
   * detectStanding detects if the user is standing based on the thumbs-up gesture.
   * It updates the _isStanding variable and calculates the completion time.
   * It notifies listeners of the change.
   */
   ///
  void detectStanding() {
    if (_isThumbsUpDetected && !_isStanding) {
      _isStanding = true;
      _completionTime = DateTime.now().difference(_startTime!);
      notifyListeners();
    }
  }

  /**
   * reset resets the state of the application.
   * It sets all variables to their initial values and notifies listeners of the change.
   */
   ///
  void reset() {
    _isThumbsUpDetected = false;
    _isStanding = false;
    _startTime = null;
    _completionTime = null;
    notifyListeners();
  }
}