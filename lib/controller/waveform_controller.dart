import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';

class WaveformController extends ChangeNotifier {
  // Create different controllers for different states
  late IOS9SiriWaveformController _idleController;
  late IOS9SiriWaveformController _listeningController;
  late IOS9SiriWaveformController _processingController;
  late IOS9SiriWaveformController _speakingController;

  IOS9SiriWaveformController _currentController;
  bool _isActive = false;
  String _currentState = 'idle';

  WaveformController()
    : _currentController = IOS9SiriWaveformController(
        amplitude: 0.0,
        color1: Color(0xFF333333),
        color2: Color(0xFF555555),
        color3: Color(0xFF777777),
        speed: 0.05,
      ) {
    _initializeControllers();
  }

  void _initializeControllers() {
    // Idle state controller
    _idleController = IOS9SiriWaveformController(
      amplitude: 0.1,
      color1: Color(0xFF333333),
      color2: Color(0xFF555555),
      color3: Color(0xFF777777),
      speed: 0.05,
    );

    // Listening state controller
    _listeningController = IOS9SiriWaveformController(
      amplitude: 0.9,
      color1: Color(0xFF00FF00), // Green
      color2: Color(0xFF00FFFF), // Cyan
      color3: Color(0xFF0099FF), // Blue
      speed: 0.25,
    );

    // Processing state controller
    _processingController = IOS9SiriWaveformController(
      amplitude: 0.6,
      color1: Color(0xFFFF9900), // Orange
      color2: Color(0xFFFFCC00), // Yellow
      color3: Color(0xFFFF6600), // Dark orange
      speed: 0.15,
    );

    // Speaking state controller
    _speakingController = IOS9SiriWaveformController(
      amplitude: 1.0,
      color1: Color(0xFF0099FF), // Blue
      color2: Color(0xFF00FFFF), // Cyan
      color3: Color(0xFF6699FF), // Light blue
      speed: 0.3,
    );

    _currentController = _idleController;
  }

  IOS9SiriWaveformController get controller => _currentController;
  bool get isActive => _isActive;
  String get currentState => _currentState;

  // Start waveform animation (generic)
  void startAnimation() {
    if (!_isActive) {
      _isActive = true;
      setListeningState();
    }
  }

  // Stop waveform animation
  void stopAnimation() {
    if (_isActive) {
      _isActive = false;
      setIdleState();
    }
  }

  // Set animation for listening state
  void setListeningState() {
    _isActive = true;
    _currentState = 'listening';
    _currentController = _listeningController;
    notifyListeners();
  }

  // Set animation for processing state
  void setProcessingState() {
    _isActive = true;
    _currentState = 'processing';
    _currentController = _processingController;
    notifyListeners();
  }

  // Set animation for speaking state
  void setSpeakingState() {
    _isActive = true;
    _currentState = 'speaking';
    _currentController = _speakingController;
    notifyListeners();
  }

  // Set idle state
  void setIdleState() {
    _isActive = false;
    _currentState = 'idle';
    _currentController = _idleController;
    notifyListeners();
  }

  // Create a custom controller with specific parameters
  void setCustomState({
    required double amplitude,
    required double speed,
    Color? color1,
    Color? color2,
    Color? color3,
  }) {
    _currentController = IOS9SiriWaveformController(
      amplitude: amplitude,
      speed: speed,
      color1: color1 ?? Color(0xFF00FFFF),
      color2: color2 ?? Color(0xFF0099FF),
      color3: color3 ?? Color(0xFF00FF99),
    );
    _currentState = 'custom';
    notifyListeners();
  }

  // Pulse animation for emphasis
  void pulseAmplitude() {
    if (_isActive) {
      // Create a high amplitude version temporarily
      final highAmplitudeController = IOS9SiriWaveformController(
        amplitude: 1.5,
        speed: _currentController.speed,
        color1: _currentController.color1,
        color2: _currentController.color2,
        color3: _currentController.color3,
      );

      _currentController = highAmplitudeController;
      notifyListeners();

      // Reset after a short duration
      Future.delayed(Duration(milliseconds: 500), () {
        // Return to previous state
        switch (_currentState) {
          case 'listening':
            setListeningState();
            break;
          case 'processing':
            setProcessingState();
            break;
          case 'speaking':
            setSpeakingState();
            break;
          default:
            setIdleState();
        }
      });
    }
  }

  @override
  void dispose() {
    // IOS9SiriWaveformController doesn't have dispose method
    // Just dispose the ChangeNotifier
    super.dispose();
  }
}
