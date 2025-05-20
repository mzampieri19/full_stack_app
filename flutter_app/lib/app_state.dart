// app_state.dart
import 'package:flutter/material.dart';

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

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void detectThumbsUp() {
    if (!_isThumbsUpDetected) {
      _isThumbsUpDetected = true;
      _startTime = DateTime.now();
      notifyListeners();
    }
  }

  void detectStanding() {
    if (_isThumbsUpDetected && !_isStanding) {
      _isStanding = true;
      _completionTime = DateTime.now().difference(_startTime!);
      notifyListeners();
    }
  }

  void reset() {
    _isThumbsUpDetected = false;
    _isStanding = false;
    _startTime = null;
    _completionTime = null;
    notifyListeners();
  }
}