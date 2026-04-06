import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'jarvis.dart';
import 'controller/speech_controller.dart';
import 'services/gemini_service.dart';

const apiKey =
    'AIzaSyD9jv-vqO495MGI01Q8mhgbUhGkR5Qk0mM'; // Replace with your actual API key

void main() {
  /// Add this line - Initialize Flutter Gemini
  GeminiService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SpeechController())],
      child: MaterialApp(
        title: 'JARVIS - Voice Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const Jarvis(),
      ),
    );
  }
}
