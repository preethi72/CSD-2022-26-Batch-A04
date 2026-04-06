import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/controller/speech_controller.dart';
import 'package:jarvis/controller/waveform_controller.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:url_launcher/url_launcher.dart';

class Jarvis extends StatefulWidget {
  const Jarvis({super.key});

  @override
  State<Jarvis> createState() => _JarvisState();
}

class _JarvisState extends State<Jarvis> with TickerProviderStateMixin {
  bool isBloob = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _textController = TextEditingController();
  final WaveformController _waveformController = WaveformController();
  String _selectedLanguage = 'en_US';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Connect waveform controller to speech controller after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final speechController = Provider.of<SpeechController>(
        context,
        listen: false,
      );
      speechController.setWaveformController(_waveformController);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  // Test Gemini API connection
  Future<void> _testGeminiConnection() async {
    final speechController = Provider.of<SpeechController>(
      context,
      listen: false,
    );

    try {
      print("Testing Gemini API connection...");

      final result = await speechController.testGeminiConnection();

      if (mounted) {
        if (result['status'] == 'success') {
          print("✅ Gemini API working!");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Gemini API is working perfectly!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print("❌ Gemini API error: ${result['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ API Error: ${result['message']}"),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Gemini API test failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Connection failed: $e"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildStatusIndicator(SpeechController speechController) {
    String statusText = '';
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.circle;

    if (speechController.isListening) {
      statusText = 'Listening...';
      statusColor = Colors.green;
      statusIcon = Icons.mic;
    } else if (speechController.isProcessing) {
      statusText = 'Processing...';
      statusColor = Colors.orange;
      statusIcon = Icons.psychology;
    } else if (speechController.isSpeaking) {
      statusText = 'Speaking...';
      statusColor = Colors.blue;
      statusIcon = Icons.volume_up;
    } else {
      statusText = speechController.isOnlineMode
          ? 'Online Ready'
          : 'Offline Ready';
      statusColor = speechController.isOnlineMode ? Colors.cyan : Colors.purple;
      statusIcon = speechController.isOnlineMode
          ? Icons.cloud
          : Icons.offline_bolt;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 14),
          SizedBox(width: 6),
          Text(
            statusText,
            style: GoogleFonts.roboto(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(SpeechController speechController) {
    return PopupMenuButton<String>(
      onSelected: (String languageCode) {
        setState(() {
          _selectedLanguage = languageCode;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.cyan.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyan.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: Colors.cyan, size: 14),
            SizedBox(width: 4),
            Text(
              _getLanguageName(_selectedLanguage),
              style: GoogleFonts.roboto(
                color: Colors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 16),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return speechController.getAvailableLanguages().map((language) {
          return PopupMenuItem<String>(
            value: language['code'],
            child: Text(
              language['name']!,
              style: GoogleFonts.roboto(fontSize: 14),
            ),
          );
        }).toList();
      },
    );
  }

  String _getLanguageName(String code) {
    final languages = {
      'en_US': 'EN',
      'en_GB': 'EN-GB',
      'es_ES': 'ES',
      'fr_FR': 'FR',
      'de_DE': 'DE',
      'it_IT': 'IT',
      'pt_BR': 'PT',
      'hi_IN': 'HI',
      'zh_CN': 'ZH',
      'ja_JP': 'JA',
      'ko_KR': 'KO',
      'ru_RU': 'RU',
      'ar_SA': 'AR',
    };
    return languages[code] ?? 'EN';
  }

  Widget _buildConversationCard(String title, String content, IconData icon) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.cyan, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.rajdhani(
                    color: Colors.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.cyan.withOpacity(0.5)),
            ),
            child: Icon(icon, color: Colors.cyan, size: 30),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(color: Colors.cyan, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMainInterface(SpeechController speechController) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Top controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusIndicator(speechController),
              _buildLanguageSelector(speechController),
              // Gemini API test button
              GestureDetector(
                onTap: _testGeminiConnection,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.api, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Test API",
                        style: GoogleFonts.roboto(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Greeting
          Text(
            "Hi 👋",
            style: GoogleFonts.shareTech(
              textStyle: const TextStyle(
                color: Colors.cyan,
                letterSpacing: .5,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main question
          Text(
            "How can I help you?",
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              letterSpacing: .5,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 10),

          // Mode indicator
          Text(
            speechController.isOnlineMode ? "🌐 AI-Powered" : "⚡ Offline Mode",
            style: GoogleFonts.roboto(
              color: speechController.isOnlineMode
                  ? Colors.green
                  : Colors.purple,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30),

          // Main JARVIS animation/button
          GestureDetector(
            onTap: () {
              setState(() {
                isBloob = false;
              });
              if (speechController.isListening) {
                speechController.stopListening();
              } else {
                speechController.startListening(
                  languageCode: _selectedLanguage,
                );
              }
            },
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      speechController.isListening ||
                          speechController.isProcessing
                      ? _pulseAnimation.value
                      : 1.0,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (speechController.isOnlineMode
                                  ? Colors.cyan
                                  : Colors.purple)
                              .withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/jarvis.gif',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if GIF is not found
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.cyan.withOpacity(0.8),
                                  Colors.blue.withOpacity(0.6),
                                  Colors.purple.withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.mic,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),

          // Animated assistant name
          TextAnimatorSequence(
            loop: true,
            children: [
              TextAnimator(
                speechController.assistantName.split('').join(' . '),
                style: GoogleFonts.comfortaa(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                atRestEffect: WidgetRestingEffects.pulse(),
              ),
            ],
          ),
          SizedBox(height: 40),

          // Quick action buttons with multilingual support
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                Icons.wb_sunny,
                "Weather",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("weather", _selectedLanguage),
                ),
              ),
              _buildQuickActionButton(
                Icons.access_time,
                "Time",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("time", _selectedLanguage),
                ),
              ),
              _buildQuickActionButton(
                Icons.emoji_emotions,
                "Joke",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("joke", _selectedLanguage),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Additional quick actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                Icons.music_note,
                "Music",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("music", _selectedLanguage),
                ),
              ),
              _buildQuickActionButton(
                Icons.calculate,
                "Math",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("math", _selectedLanguage),
                ),
              ),
              _buildQuickActionButton(
                Icons.help,
                "Help",
                () => speechController.processTextCommand(
                  _getLocalizedCommand("help", _selectedLanguage),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Online/Offline toggle
          GestureDetector(
            onTap: speechController.toggleOnlineMode,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    (speechController.isOnlineMode
                            ? Colors.green
                            : Colors.purple)
                        .withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: speechController.isOnlineMode
                      ? Colors.green
                      : Colors.purple,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    speechController.isOnlineMode
                        ? Icons.cloud
                        : Icons.offline_bolt,
                    color: speechController.isOnlineMode
                        ? Colors.green
                        : Colors.purple,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    speechController.isOnlineMode
                        ? "Switch to Offline"
                        : "Switch to Online",
                    style: GoogleFonts.roboto(
                      color: speechController.isOnlineMode
                          ? Colors.green
                          : Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationInterface(SpeechController speechController) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with back button
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isBloob = true;
                    });
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.cyan),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      speechController.assistantName,
                      style: GoogleFonts.rajdhani(
                        color: Colors.cyan,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildStatusIndicator(speechController),
              ],
            ),
            SizedBox(height: 20),

            // API test and language selector row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _testGeminiConnection,
                  icon: Icon(Icons.api, size: 18),
                  label: Text("Test Gemini API"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                _buildLanguageSelector(speechController),
              ],
            ),

            SizedBox(height: 20),

            // Service status card
            Card(
              color:
                  (speechController.isOnlineMode ? Colors.green : Colors.purple)
                      .withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color:
                      (speechController.isOnlineMode
                              ? Colors.green
                              : Colors.purple)
                          .withOpacity(0.3),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      speechController.isOnlineMode
                          ? Icons.cloud
                          : Icons.offline_bolt,
                      color: speechController.isOnlineMode
                          ? Colors.green
                          : Colors.purple,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            speechController.isOnlineMode
                                ? "Gemini AI Active"
                                : "Offline Mode Active",
                            style: GoogleFonts.rajdhani(
                              color: speechController.isOnlineMode
                                  ? Colors.green
                                  : Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            speechController.isOnlineMode
                                ? "AI-powered responses • Multilingual support"
                                : "Basic responses • No internet required",
                            style: GoogleFonts.roboto(
                              color:
                                  (speechController.isOnlineMode
                                          ? Colors.green
                                          : Colors.purple)
                                      .withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: speechController.isOnlineMode,
                      onChanged: (_) => speechController.toggleOnlineMode(),
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Conversation display
            if (speechController.lastWords.isNotEmpty)
              _buildConversationCard(
                "You said:",
                speechController.lastWords,
                Icons.person,
              ),

            if (speechController.lastResponse.isNotEmpty) SizedBox(height: 10),

            if (speechController.lastResponse.isNotEmpty)
              _buildConversationCard(
                "${speechController.assistantName} replied:",
                speechController.lastResponse,
                Icons.smart_toy,
              ),

            SizedBox(height: 20),

            // Text input for manual commands
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: GoogleFonts.roboto(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a command in any language...",
                        hintStyle: GoogleFonts.roboto(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          speechController.processTextCommand(text);
                          _textController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        speechController.processTextCommand(
                          _textController.text,
                        );
                        _textController.clear();
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.cyan),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: speechController.isListening
                      ? speechController.stopListening
                      : () => speechController.startListening(
                          languageCode: _selectedLanguage,
                        ),
                  backgroundColor: speechController.isListening
                      ? Colors.red
                      : Colors.cyan,
                  child: Icon(
                    speechController.isListening ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  onPressed: speechController.isSpeaking
                      ? speechController.stopSpeaking
                      : null,
                  backgroundColor: speechController.isSpeaking
                      ? Colors.orange
                      : Colors.grey,
                  child: Icon(Icons.volume_off, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {
                    speechController.clearConversation();
                  },
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.clear, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final speechController = Provider.of<SpeechController>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 2, 42),
      body: SafeArea(
        child: isBloob
            ? _buildMainInterface(speechController)
            : _buildConversationInterface(speechController),
      ),
      bottomNavigationBar: !isBloob
          ? Container(
              height: 120,
              child: Column(
                children: [
                  if (speechController.isListening)
                    Container(
                      height: 80,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: SiriWaveform.ios9(
                          controller: _waveformController.controller,
                          options: const IOS9SiriWaveformOptions(
                            height: 60,
                            width: 400,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          speechController.isListening
                              ? "Listening... (${_getLanguageName(_selectedLanguage)})"
                              : speechController.isProcessing
                              ? "Processing with ${speechController.isOnlineMode ? 'Gemini AI' : 'Offline Mode'}..."
                              : speechController.isSpeaking
                              ? "Speaking..."
                              : "Tap mic to speak in ${_getLanguageName(_selectedLanguage)}",
                          style: GoogleFonts.roboto(
                            color: Colors.cyan,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  // Helper method to get localized commands
  String _getLocalizedCommand(String type, String languageCode) {
    final commands = {
      'en_US': {
        'weather': 'What\'s the weather like?',
        'time': 'What time is it?',
        'joke': 'Tell me a joke',
        'music': 'Play some music',
        'math': 'Calculate 25 plus 17',
        'help': 'What can you do?',
      },
      'es_ES': {
        'weather': '¿Cómo está el clima?',
        'time': '¿Qué hora es?',
        'joke': 'Cuéntame un chiste',
        'music': 'Pon algo de música',
        'math': 'Calcula 25 más 17',
        'help': '¿Qué puedes hacer?',
      },
      'fr_FR': {
        'weather': 'Quel temps fait-il?',
        'time': 'Quelle heure est-il?',
        'joke': 'Raconte-moi une blague',
        'music': 'Joue de la musique',
        'math': 'Calcule 25 plus 17',
        'help': 'Que peux-tu faire?',
      },
      'de_DE': {
        'weather': 'Wie ist das Wetter?',
        'time': 'Wie spät ist es?',
        'joke': 'Erzähl mir einen Witz',
        'music': 'Spiele Musik',
        'math': 'Rechne 25 plus 17',
        'help': 'Was kannst du tun?',
      },
      'hi_IN': {
        'weather': 'मौसम कैसा है?',
        'time': 'समय क्या है?',
        'joke': 'मुझे एक जोक सुनाओ',
        'music': 'कुछ संगीत बजाओ',
        'math': '25 और 17 का जोड़ करो',
        'help': 'आप क्या कर सकते हैं?',
      },
      'zh_CN': {
        'weather': '天气怎么样？',
        'time': '现在几点了？',
        'joke': '告诉我一个笑话',
        'music': '播放音乐',
        'math': '计算25加17',
        'help': '你能做什么？',
      },
      'ja_JP': {
        'weather': '天気はどうですか？',
        'time': '今何時ですか？',
        'joke': 'ジョークを教えて',
        'music': '音楽を再生して',
        'math': '25足す17を計算して',
        'help': '何ができますか？',
      },
    };

    return commands[languageCode]?[type] ?? commands['en_US']![type]!;
  }
}
