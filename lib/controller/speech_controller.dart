import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:jarvis/services/gemini_service.dart';
import 'package:jarvis/controller/waveform_controller.dart';

class SpeechController extends ChangeNotifier {
  SpeechToText _speechToText = SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  WaveformController? _waveformController;

  bool _speechEnabled = false;
  String _lastWords = '';
  String _lastResponse = '';
  bool _isProcessing = false;
  bool _isSpeaking = false;
  String _assistantName = 'JARVIS';
  bool _isOnlineMode = true;

  // Getter Methods
  bool get speechEnabled => _speechEnabled;
  String get lastWords => _lastWords;
  String get lastResponse => _lastResponse;
  bool get isListening => _speechToText.isListening;
  bool get isProcessing => _isProcessing;
  bool get isSpeaking => _isSpeaking;
  String get assistantName => _assistantName;
  bool get isOnlineMode => _isOnlineMode;

  SpeechController() {
    _initSpeech();
    _initTts();
  }

  void setWaveformController(WaveformController waveformController) {
    _waveformController = waveformController;
  }

  Future _initSpeech() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print("Microphone permission denied");
        return;
      }

      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          print("Speech recognition error: $error");
          _waveformController?.setIdleState();
          notifyListeners();
        },
        onStatus: (status) {
          print("Speech recognition status: $status");
          if (status == 'listening') {
            _waveformController?.setListeningState();
          } else if (status == 'notListening') {
            _waveformController?.setIdleState();
          }
          notifyListeners();
        },
      );

      print("Speech recognition initialized: $_speechEnabled");
    } catch (e) {
      print("Error in speech initialization: $e");
    }
    notifyListeners();
  }

  Future _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        _waveformController?.setSpeakingState();
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _waveformController?.setIdleState();
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        print("TTS Error: $msg");
        _isSpeaking = false;
        _waveformController?.setIdleState();
        notifyListeners();
      });

      print("TTS initialized successfully");
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  // FIXED: Start listening with proper language support
  void startListening({String? languageCode}) async {
    if (!_speechEnabled) {
      print("Speech recognition not enabled");
      return;
    }

    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    try {
      _waveformController?.setListeningState();
      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          notifyListeners();

          if (result.finalResult && _lastWords.isNotEmpty) {
            _processCommand(_lastWords, languageCode ?? "en_US");
          }
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: languageCode ?? "en_US",
        cancelOnError: true,
      );
    } catch (e) {
      print("Error starting speech recognition: $e");
      _waveformController?.setIdleState();
    }
    notifyListeners();
  }

  void stopListening() async {
    try {
      await _speechToText.stop();
      _waveformController?.setIdleState();
    } catch (e) {
      print("Error stopping speech recognition: $e");
    }
    notifyListeners();
  }

  // ENHANCED: Process command with language support
  Future<void> _processCommand(String command, String languageCode) async {
    if (command.isEmpty || _isProcessing) return;

    _isProcessing = true;
    _waveformController?.setProcessingState();
    notifyListeners();

    try {
      print(
        "Processing command with Gemini: $command in language: $languageCode",
      );

      Map<String, dynamic> response;

      if (_isOnlineMode) {
        response = await GeminiService.processCommand(command, languageCode);

        if (response['status'] != 'success') {
          print("Gemini API failed, switching to offline mode");
          _isOnlineMode = false;
          response = GeminiService.getOfflineResponse(command);
        }
      } else {
        response = GeminiService.getOfflineResponse(command);
      }

      if (response['status'] == 'success' && response['message'] != null) {
        _lastResponse = response['message'];
        _handleResponseType(response);

        // Don't speak if it's a music response (YouTube was opened)
        if (response['type'] != 'music' || response['youtubeUrl'] == null) {
          await _speak(_lastResponse, languageCode);
        } else {
          print("🎵 Music opened in YouTube, skipping TTS");
        }
      } else {
        _lastResponse =
            response['message'] ?? 'Sorry, I could not process that command.';
        await _speak(_lastResponse, languageCode);
      }
    } catch (e) {
      print("Error processing command: $e");
      _lastResponse =
          'Sorry, there was an error processing your request. Please try again.';
      await _speak(_lastResponse, languageCode);

      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        _isOnlineMode = false;
        notifyListeners();
      }
    } finally {
      _isProcessing = false;
      if (!_isSpeaking) {
        _waveformController?.setIdleState();
      }
      notifyListeners();
    }
  }

  void _handleResponseType(Map<String, dynamic> response) {
    String responseType = response['type'] ?? 'general';

    switch (responseType) {
      case 'time':
        print("⏰ Time request handled");
        break;
      case 'weather':
        print("🌤️ Weather request handled");
        break;
      case 'music':
        print("🎵 Music request handled - YouTube: ${response['youtubeUrl']}");
        break;
      case 'joke':
        print("😄 Joke request handled - Category: ${response['category']}");
        break;
      case 'calculation':
        print("🔢 Math calculation handled");
        break;
      case 'help':
        print("❓ Help request handled");
        break;
      default:
        print("💬 General response handled");
    }
  }

  // ENHANCED: Speak with language detection and TTS language setting
  Future<void> _speak(String text, String languageCode) async {
    if (text.isEmpty) return;

    try {
      String ttsLanguage = _getTtsLanguageCode(languageCode);
      await _flutterTts.setLanguage(ttsLanguage);
      await _flutterTts.speak(text);
    } catch (e) {
      print("Error speaking text: $e");
      _waveformController?.setIdleState();
    }
  }

  // Convert language codes to TTS compatible format
  String _getTtsLanguageCode(String languageCode) {
    final ttsLanguageMap = {
      'en_US': 'en-US',
      'en_GB': 'en-GB',
      'hi_IN': 'hi-IN',
      'ta_IN': 'ta-IN',
      'te_IN': 'te-IN',
      'bn_IN': 'bn-IN',
      'mr_IN': 'mr-IN',
      'gu_IN': 'gu-IN',
      'kn_IN': 'kn-IN',
      'ml_IN': 'ml-IN',
      'pa_IN': 'pa-IN',
      'es_ES': 'es-ES',
      'fr_FR': 'fr-FR',
      'de_DE': 'de-DE',
      'it_IT': 'it-IT',
      'pt_BR': 'pt-BR',
      'zh_CN': 'zh-CN',
      'ja_JP': 'ja-JP',
      'ko_KR': 'ko-KR',
      'ru_RU': 'ru-RU',
      'ar_SA': 'ar-SA',
    };
    return ttsLanguageMap[languageCode] ?? 'en-US';
  }

  // PUBLIC: Speak any text with language support
  Future<void> speak(String text, {String languageCode = 'en_US'}) async {
    await _speak(text, languageCode);
  }

  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _waveformController?.setIdleState();
    } catch (e) {
      print("Error stopping TTS: $e");
    }
  }

  Future<void> updateAssistantName(String newName) async {
    try {
      final response = await GeminiService.updateAssistantName(newName);
      if (response['status'] == 'success') {
        _assistantName = newName;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating assistant name: $e");
    }
  }

  // ENHANCED: Process text command with language support
  Future<void> processTextCommand(
    String command, {
    String languageCode = 'en_US',
  }) async {
    _lastWords = command;
    await _processCommand(command, languageCode);
  }

  Future<Map<String, dynamic>> testGeminiConnection() async {
    try {
      final result = await GeminiService.testConnection();

      if (result['status'] == 'success') {
        _isOnlineMode = true;
      } else {
        _isOnlineMode = false;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _isOnlineMode = false;
      notifyListeners();
      return {'status': 'error', 'message': 'Connection test failed: $e'};
    }
  }

  void toggleOnlineMode() {
    _isOnlineMode = !_isOnlineMode;
    notifyListeners();
  }

  // ENHANCED: Get available languages with Indian regional languages
  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'code': 'en_US', 'name': 'English (US)'},
      {'code': 'en_GB', 'name': 'English (UK)'},
      {'code': 'hi_IN', 'name': 'हिंदी (Hindi)'},
      {'code': 'ta_IN', 'name': 'தமிழ் (Tamil)'},
      {'code': 'te_IN', 'name': 'తెలుగు (Telugu)'},
      {'code': 'bn_IN', 'name': 'বাংলা (Bengali)'},
      {'code': 'mr_IN', 'name': 'मराठी (Marathi)'},
      {'code': 'gu_IN', 'name': 'ગુજરાતી (Gujarati)'},
      {'code': 'kn_IN', 'name': 'ಕನ್ನಡ (Kannada)'},
      {'code': 'ml_IN', 'name': 'മലയാളം (Malayalam)'},
      {'code': 'pa_IN', 'name': 'ਪੰਜਾਬੀ (Punjabi)'},
      {'code': 'es_ES', 'name': 'Español'},
      {'code': 'fr_FR', 'name': 'Français'},
      {'code': 'de_DE', 'name': 'Deutsch'},
      {'code': 'zh_CN', 'name': '中文'},
      {'code': 'ja_JP', 'name': '日本語'},
      {'code': 'ar_SA', 'name': 'العربية'},
    ];
  }

  void clearConversation() {
    _lastWords = '';
    _lastResponse = '';
    _waveformController?.setIdleState();
    notifyListeners();
  }

  // Setters for UI updates
  void setLastWords(String words) {
    _lastWords = words;
    notifyListeners();
  }

  void setLastResponse(String response) {
    _lastResponse = response;
    notifyListeners();
  }

  void setProcessing(bool processing) {
    _isProcessing = processing;
    if (processing) {
      _waveformController?.setProcessingState();
    } else {
      _waveformController?.setIdleState();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}
