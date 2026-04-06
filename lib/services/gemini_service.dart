// // // // // // import 'dart:async';
// // // // // // import 'package:flutter_gemini/flutter_gemini.dart';

// // // // // // class GeminiService {
// // // // // //   static const String apiKey =
// // // // // //       'AIzaSyCxCJoOU1A5JPDAwtmpt5nr-Q97jTqLNzg'; // Replace with your actual API key
// // // // // //   static const Duration timeoutDuration = Duration(seconds: 15);
// // // // // //   static bool _isInitialized = false;

// // // // // //   /// Initialize the Gemini service
// // // // // //   static void init() {
// // // // // //     if (apiKey != 'gh') {
// // // // // //       try {
// // // // // //         Gemini.init(apiKey: apiKey);
// // // // // //         _isInitialized = true;
// // // // // //         print("✅ Flutter Gemini initialized successfully");
// // // // // //       } catch (e) {
// // // // // //         print("❌ Failed to initialize Gemini: $e");
// // // // // //         _isInitialized = false;
// // // // // //       }
// // // // // //     } else {
// // // // // //       print("⚠️ Gemini API key not set, using offline mode");
// // // // // //       _isInitialized = false;
// // // // // //     }
// // // // // //   }

// // // // // //   /// Check if Gemini is properly initialized
// // // // // //   static bool get isInitialized => _isInitialized;

// // // // // //   /// Process any voice command using Gemini API
// // // // // //   static Future<Map<String, dynamic>> processCommand(String command) async {
// // // // // //     try {
// // // // // //       print("Processing command with Flutter Gemini: $command");

// // // // // //       if (!_isInitialized) {
// // // // // //         print("⚠️ Gemini not initialized, using offline mode");
// // // // // //         return getOfflineResponse(command);
// // // // // //       }

// // // // // //       final String enhancedPrompt = _createEnhancedPrompt(command);
// // // // // //       final response = await _callGeminiAPI(enhancedPrompt);

// // // // // //       if (response != null && response.isNotEmpty) {
// // // // // //         final responseType = _analyzeResponseType(command, response);

// // // // // //         return {
// // // // // //           'status': 'success',
// // // // // //           'message': response,
// // // // // //           'type': responseType,
// // // // // //           'originalCommand': command,
// // // // // //         };
// // // // // //       } else {
// // // // // //         print("Empty response from Gemini API, falling back to offline");
// // // // // //         return getOfflineResponse(command);
// // // // // //       }
// // // // // //     } on TimeoutException catch (e) {
// // // // // //       print("Gemini API timeout: $e");
// // // // // //       return {
// // // // // //         'status': 'timeout',
// // // // // //         'message': 'Request timed out. Using offline response.',
// // // // // //         'type': 'offline',
// // // // // //         'fallback': getOfflineResponse(command),
// // // // // //       };
// // // // // //     } catch (e) {
// // // // // //       print("Error in Gemini API call: $e");
// // // // // //       return {
// // // // // //         'status': 'error',
// // // // // //         'message':
// // // // // //             'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
// // // // // //         'type': 'offline',
// // // // // //         'fallback': getOfflineResponse(command),
// // // // // //       };
// // // // // //     }
// // // // // //   }

// // // // // //   /// Create an enhanced prompt that provides context to Gemini
// // // // // //   static String _createEnhancedPrompt(String userCommand) {
// // // // // //     return '''
// // // // // // You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

// // // // // // Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// // // // // // Guidelines:
// // // // // // - If asked about time, provide current time information
// // // // // // - If asked about weather, explain you need location services
// // // // // // - If asked to play music, suggest popular platforms
// // // // // // - If asked math questions, solve them clearly
// // // // // // - If asked for jokes, tell a clean, family-friendly joke
// // // // // // - If asked what you can do, list your main capabilities
// // // // // // - For general questions, provide helpful information
// // // // // // - Respond in the same language the user used
// // // // // // - Keep responses under 100 words for voice output
// // // // // // - Be friendly and conversational

// // // // // // User's request: $userCommand
// // // // // // ''';
// // // // // //   }

// // // // // //   /// Make the actual API call to Gemini using the flutter_gemini package
// // // // // //   static Future<String?> _callGeminiAPI(String prompt) async {
// // // // // //     try {
// // // // // //       if (!_isInitialized) {
// // // // // //         print("Gemini not initialized");
// // // // // //         return null;
// // // // // //       }

// // // // // //       print("Sending request to Flutter Gemini...");
// // // // // //       final gemini = Gemini.instance;

// // // // // //       final response = await gemini
// // // // // //           .prompt(parts: [Part.text(prompt)])
// // // // // //           .timeout(timeoutDuration);

// // // // // //       print("Flutter Gemini API Response received");

// // // // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // // // //         final outputText = response.output!;
// // // // // //         print(
// // // // // //           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
// // // // // //         );
// // // // // //         return outputText;
// // // // // //       } else {
// // // // // //         print("Empty response output");
// // // // // //         return null;
// // // // // //       }
// // // // // //     } on TimeoutException {
// // // // // //       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
// // // // // //       rethrow;
// // // // // //     } catch (e) {
// // // // // //       print("Unexpected error in API call: $e");
// // // // // //       rethrow;
// // // // // //     }
// // // // // //   }

// // // // // //   /// Analyze the response to determine what type of response it is
// // // // // //   static String _analyzeResponseType(String command, String response) {
// // // // // //     final lowerCommand = command.toLowerCase();

// // // // // //     if (lowerCommand.contains('time') || lowerCommand.contains('clock')) {
// // // // // //       return 'time';
// // // // // //     } else if (lowerCommand.contains('weather') ||
// // // // // //         lowerCommand.contains('temperature')) {
// // // // // //       return 'weather';
// // // // // //     } else if (lowerCommand.contains('play') ||
// // // // // //         lowerCommand.contains('music') ||
// // // // // //         lowerCommand.contains('song')) {
// // // // // //       return 'music';
// // // // // //     } else if (lowerCommand.contains('calculate') ||
// // // // // //         lowerCommand.contains('math') ||
// // // // // //         lowerCommand.contains('+') ||
// // // // // //         lowerCommand.contains('-') ||
// // // // // //         lowerCommand.contains('*') ||
// // // // // //         lowerCommand.contains('/')) {
// // // // // //       return 'calculation';
// // // // // //     } else if (lowerCommand.contains('joke') ||
// // // // // //         lowerCommand.contains('funny')) {
// // // // // //       return 'joke';
// // // // // //     } else if (lowerCommand.contains('help') ||
// // // // // //         lowerCommand.contains('what can you do')) {
// // // // // //       return 'help';
// // // // // //     } else {
// // // // // //       return 'general';
// // // // // //     }
// // // // // //   }

// // // // // //   /// Update assistant name (placeholder for consistency with original code)
// // // // // //   static Future<Map<String, dynamic>> updateAssistantName(
// // // // // //     String newName,
// // // // // //   ) async {
// // // // // //     return {
// // // // // //       'status': 'success',
// // // // // //       'message': 'Assistant name updated to $newName',
// // // // // //     };
// // // // // //   }

// // // // // //   /// Test the Gemini API connection
// // // // // //   static Future<Map<String, dynamic>> testConnection() async {
// // // // // //     try {
// // // // // //       print("Testing connection to Flutter Gemini API...");

// // // // // //       if (!_isInitialized) {
// // // // // //         return {
// // // // // //           'status': 'error',
// // // // // //           'message': 'Gemini not initialized. Please check your API key.',
// // // // // //         };
// // // // // //       }

// // // // // //       final gemini = Gemini.instance;
// // // // // //       final response = await gemini
// // // // // //           .prompt(
// // // // // //             parts: [
// // // // // //               Part.text(
// // // // // //                 "Hello, respond with just 'Hello' to test the connection",
// // // // // //               ),
// // // // // //             ],
// // // // // //           )
// // // // // //           .timeout(Duration(seconds: 10));

// // // // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // // // //         return {
// // // // // //           'status': 'success',
// // // // // //           'message':
// // // // // //               'Flutter Gemini API is working perfectly! Response: ${response.output}',
// // // // // //         };
// // // // // //       } else {
// // // // // //         return {
// // // // // //           'status': 'error',
// // // // // //           'message': 'API responded but with empty content',
// // // // // //         };
// // // // // //       }
// // // // // //     } on TimeoutException {
// // // // // //       return {
// // // // // //         'status': 'timeout',
// // // // // //         'message': 'Connection test timed out. Check your internet connection.',
// // // // // //       };
// // // // // //     } catch (e) {
// // // // // //       return {
// // // // // //         'status': 'error',
// // // // // //         'message': 'Connection test failed: ${e.toString()}',
// // // // // //       };
// // // // // //     }
// // // // // //   }

// // // // // //   /// Get current time (helper function)
// // // // // //   static String getCurrentTime() {
// // // // // //     final now = DateTime.now();
// // // // // //     final hour = now.hour;
// // // // // //     final minute = now.minute.toString().padLeft(2, '0');
// // // // // //     final period = hour >= 12 ? 'PM' : 'AM';
// // // // // //     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

// // // // // //     return "The current time is $displayHour:$minute $period";
// // // // // //   }

// // // // // //   /// Get sample responses for offline mode
// // // // // //   static Map<String, dynamic> getOfflineResponse(String command) {
// // // // // //     final lowerCommand = command.toLowerCase();

// // // // // //     if (lowerCommand.contains('time') || lowerCommand.contains('clock')) {
// // // // // //       return {'status': 'success', 'message': getCurrentTime(), 'type': 'time'};
// // // // // //     } else if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message':
// // // // // //             'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// // // // // //         'type': 'greeting',
// // // // // //       };
// // // // // //     } else if (lowerCommand.contains('joke') ||
// // // // // //         lowerCommand.contains('funny')) {
// // // // // //       final jokes = [
// // // // // //         "Why don't scientists trust atoms? Because they make up everything!",
// // // // // //         "Why did the scarecrow win an award? He was outstanding in his field!",
// // // // // //         "Why don't eggs tell jokes? They'd crack each other up!",
// // // // // //         "What do you call a bear with no teeth? A gummy bear!",
// // // // // //         "Why don't programmers like nature? It has too many bugs!",
// // // // // //       ];
// // // // // //       final randomJoke = jokes[DateTime.now().millisecond % jokes.length];
// // // // // //       return {'status': 'success', 'message': randomJoke, 'type': 'joke'};
// // // // // //     } else if (lowerCommand.contains('weather')) {
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message':
// // // // // //             'I can\'t check the weather in offline mode, but you can check your local weather app!',
// // // // // //         'type': 'weather',
// // // // // //       };
// // // // // //     } else if (lowerCommand.contains('music') ||
// // // // // //         lowerCommand.contains('play')) {
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message':
// // // // // //             'I can\'t play music directly, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
// // // // // //         'type': 'music',
// // // // // //       };
// // // // // //     } else if (lowerCommand.contains('calculate') ||
// // // // // //         lowerCommand.contains('math')) {
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message':
// // // // // //             'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
// // // // // //         'type': 'calculation',
// // // // // //       };
// // // // // //     } else if (lowerCommand.contains('help') ||
// // // // // //         lowerCommand.contains('what can you do')) {
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message':
// // // // // //             'I can tell you the time, share jokes, help with basic questions, and chat with you! For advanced features, try switching to online mode.',
// // // // // //         'type': 'help',
// // // // // //       };
// // // // // //     } else {
// // // // // //       final responses = [
// // // // // //         'I\'m currently in offline mode, but I can still help with basic tasks!',
// // // // // //         'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
// // // // // //         'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
// // // // // //         'Thanks for talking with me! I can do more when connected to the internet.',
// // // // // //       ];
// // // // // //       final randomResponse =
// // // // // //           responses[DateTime.now().millisecond % responses.length];
// // // // // //       return {
// // // // // //         'status': 'success',
// // // // // //         'message': randomResponse,
// // // // // //         'type': 'offline',
// // // // // //       };
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // import 'dart:async';
// // // // // import 'dart:convert';
// // // // // import 'package:flutter_gemini/flutter_gemini.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:geolocator/geolocator.dart';
// // // // // import 'package:url_launcher/url_launcher.dart';

// // // // // class GeminiService {
// // // // //   static const String apiKey = 'AIzaSyCxCJoOU1A5JPDAwtmpt5nr-Q97jTqLNzg';
// // // // //   static const Duration timeoutDuration = Duration(seconds: 15);
// // // // //   static bool _isInitialized = false;

// // // // //   /// Initialize the Gemini service
// // // // //   static void init() {
// // // // //     if (apiKey != 'gh') {
// // // // //       try {
// // // // //         Gemini.init(apiKey: apiKey);
// // // // //         _isInitialized = true;
// // // // //         print("✅ Flutter Gemini initialized successfully");
// // // // //       } catch (e) {
// // // // //         print("❌ Failed to initialize Gemini: $e");
// // // // //         _isInitialized = false;
// // // // //       }
// // // // //     } else {
// // // // //       print("⚠️ Gemini API key not set, using offline mode");
// // // // //       _isInitialized = false;
// // // // //     }
// // // // //   }

// // // // //   /// Check if Gemini is properly initialized
// // // // //   static bool get isInitialized => _isInitialized;

// // // // //   /// Process any voice command using Gemini API with language support
// // // // //   static Future<Map<String, dynamic>> processCommand(
// // // // //     String command,
// // // // //     String languageCode
// // // // //   ) async {
// // // // //     try {
// // // // //       print("Processing command with Flutter Gemini: $command in language: $languageCode");

// // // // //       // Handle time requests locally (faster and more accurate)
// // // // //       if (_isTimeRequest(command)) {
// // // // //         final timeResponse = getCurrentTime();
// // // // //         return {
// // // // //           'status': 'success',
// // // // //           'message': await _translateToLanguage(timeResponse, languageCode),
// // // // //           'type': 'time',
// // // // //           'originalCommand': command,
// // // // //         };
// // // // //       }

// // // // //       // Handle weather requests with API integration
// // // // //       if (_isWeatherRequest(command)) {
// // // // //         return await _handleWeatherRequest(command, languageCode);
// // // // //       }

// // // // //       // Handle music requests with YouTube search
// // // // //       if (_isMusicRequest(command)) {
// // // // //         return await _handleMusicRequest(command, languageCode);
// // // // //       }

// // // // //       if (!_isInitialized) {
// // // // //         print("⚠️ Gemini not initialized, using offline mode");
// // // // //         final offlineResponse = getOfflineResponse(command);
// // // // //         offlineResponse['message'] = await _translateToLanguage(
// // // // //           offlineResponse['message'],
// // // // //           languageCode
// // // // //         );
// // // // //         return offlineResponse;
// // // // //       }

// // // // //       // Translate non-English commands to English for Gemini
// // // // //       String processedCommand = command;
// // // // //       if (!_isEnglish(languageCode)) {
// // // // //         processedCommand = await _translateToEnglish(command, languageCode);
// // // // //       }

// // // // //       final String enhancedPrompt = _createEnhancedPrompt(processedCommand, languageCode);
// // // // //       final response = await _callGeminiAPI(enhancedPrompt);

// // // // //       if (response != null && response.isNotEmpty) {
// // // // //         final responseType = _analyzeResponseType(processedCommand, response);

// // // // //         // Translate response back to target language if needed
// // // // //         String finalResponse = response;
// // // // //         if (!_isEnglish(languageCode)) {
// // // // //           finalResponse = await _translateToLanguage(response, languageCode);
// // // // //         }

// // // // //         return {
// // // // //           'status': 'success',
// // // // //           'message': finalResponse,
// // // // //           'type': responseType,
// // // // //           'originalCommand': command,
// // // // //         };
// // // // //       } else {
// // // // //         print("Empty response from Gemini API, falling back to offline");
// // // // //         final offlineResponse = getOfflineResponse(command);
// // // // //         offlineResponse['message'] = await _translateToLanguage(
// // // // //           offlineResponse['message'],
// // // // //           languageCode
// // // // //         );
// // // // //         return offlineResponse;
// // // // //       }
// // // // //     } on TimeoutException catch (e) {
// // // // //       print("Gemini API timeout: $e");
// // // // //       return {
// // // // //         'status': 'timeout',
// // // // //         'message': await _translateToLanguage(
// // // // //           'Request timed out. Using offline response.',
// // // // //           languageCode
// // // // //         ),
// // // // //         'type': 'offline',
// // // // //         'fallback': getOfflineResponse(command),
// // // // //       };
// // // // //     } catch (e) {
// // // // //       print("Error in Gemini API call: $e");
// // // // //       final offlineResponse = getOfflineResponse(command);
// // // // //       offlineResponse['message'] = await _translateToLanguage(
// // // // //         offlineResponse['message'],
// // // // //         languageCode
// // // // //       );
// // // // //       return {
// // // // //         'status': 'error',
// // // // //         'message': await _translateToLanguage(
// // // // //           'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
// // // // //           languageCode
// // // // //         ),
// // // // //         'type': 'offline',
// // // // //         'fallback': offlineResponse,
// // // // //       };
// // // // //     }
// // // // //   }

// // // // //   /// Handle music requests with YouTube search and direct opening
// // // // //   static Future<Map<String, dynamic>> _handleMusicRequest(
// // // // //     String command,
// // // // //     String languageCode
// // // // //   ) async {
// // // // //     try {
// // // // //       print("🎵 Processing music request: $command");

// // // // //       // Extract song/artist name from command
// // // // //       String searchQuery = _extractMusicQuery(command);

// // // // //       if (searchQuery.isEmpty) {
// // // // //         // If no specific song mentioned, ask Gemini for popular songs
// // // // //         searchQuery = await _getPopularSongSuggestion(command);
// // // // //       }

// // // // //       // Search YouTube and get the first result
// // // // //       final youtubeUrl = await _searchYouTubeMusic(searchQuery);

// // // // //       if (youtubeUrl != null) {
// // // // //         // Open YouTube URL
// // // // //         await _openYouTubeUrl(youtubeUrl);

// // // // //         final successMessage = searchQuery.isNotEmpty
// // // // //             ? "Opening '$searchQuery' on YouTube Music!"
// // // // //             : "Opening music on YouTube!";

// // // // //         return {
// // // // //           'status': 'success',
// // // // //           'message': await _translateToLanguage(successMessage, languageCode),
// // // // //           'type': 'music',
// // // // //           'originalCommand': command,
// // // // //           'youtubeUrl': youtubeUrl,
// // // // //           'searchQuery': searchQuery,
// // // // //         };
// // // // //       } else {
// // // // //         return {
// // // // //           'status': 'error',
// // // // //           'message': await _translateToLanguage(
// // // // //             "Sorry, I couldn't find that song on YouTube. Try being more specific with the song name or artist.",
// // // // //             languageCode
// // // // //           ),
// // // // //           'type': 'music',
// // // // //           'originalCommand': command,
// // // // //         };
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("Music request error: $e");
// // // // //       return {
// // // // //         'status': 'error',
// // // // //         'message': await _translateToLanguage(
// // // // //           'Sorry, I cannot play music right now. Please try again later.',
// // // // //           languageCode
// // // // //         ),
// // // // //         'type': 'music',
// // // // //         'originalCommand': command,
// // // // //       };
// // // // //     }
// // // // //   }

// // // // //   /// Extract music query from voice command
// // // // //   static String _extractMusicQuery(String command) {
// // // // //     final lowerCommand = command.toLowerCase();

// // // // //     // Remove common music command words
// // // // //     String query = lowerCommand
// // // // //         .replaceAll('play', '')
// // // // //         .replaceAll('song', '')
// // // // //         .replaceAll('music', '')
// // // // //         .replaceAll('track', '')
// // // // //         .replaceAll('by', '')
// // // // //         .replaceAll('from', '')
// // // // //         .replaceAll('the', '')
// // // // //         .replaceAll('a', '')
// // // // //         .trim();

// // // // //     // Handle patterns like "play [song] by [artist]"
// // // // //     if (query.contains(' by ')) {
// // // // //       final parts = query.split(' by ');
// // // // //       if (parts.length >= 2) {
// // // // //         return "${parts[0].trim()} ${parts[1].trim()}";
// // // // //       }
// // // // //     }

// // // // //     return query;
// // // // //   }

// // // // //   /// Get popular song suggestion using Gemini when no specific song is mentioned
// // // // //   static Future<String> _getPopularSongSuggestion(String command) async {
// // // // //     try {
// // // // //       if (!_isInitialized) return "popular music";

// // // // //       final prompt = '''
// // // // // The user wants to listen to music but didn't specify a song. Command: "$command"
// // // // // Suggest ONE popular song name with artist that would be good to play.
// // // // // Return ONLY the song name and artist in this format: "Song Name Artist Name"
// // // // // Example: "Shape of You Ed Sheeran"
// // // // // Make it a currently popular or classic hit song.
// // // // // ''';

// // // // //       final response = await _callGeminiAPI(prompt);
// // // // //       return response?.trim() ?? "popular music";
// // // // //     } catch (e) {
// // // // //       print("Error getting song suggestion: $e");
// // // // //       return "popular music";
// // // // //     }
// // // // //   }

// // // // //   /// Search YouTube for music and return the first video URL
// // // // //   static Future<String?> _searchYouTubeMusic(String query) async {
// // // // //     try {
// // // // //       // Create YouTube search URL
// // // // //       final encodedQuery = Uri.encodeComponent("$query music video");
// // // // //       final searchUrl = "https://www.youtube.com/results?search_query=$encodedQuery";

// // // // //       print("🔍 Searching YouTube for: $query");

// // // // //       // Make HTTP request to YouTube search
// // // // //       final response = await http.get(
// // // // //         Uri.parse(searchUrl),
// // // // //         headers: {
// // // // //           'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
// // // // //         },
// // // // //       ).timeout(Duration(seconds: 10));

// // // // //       if (response.statusCode == 200) {
// // // // //         final body = response.body;

// // // // //         // Extract video ID from YouTube search results
// // // // //         final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
// // // // //         final match = videoIdRegex.firstMatch(body);

// // // // //         if (match != null) {
// // // // //           final videoId = match.group(1);
// // // // //           final youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
// // // // //           print("✅ Found YouTube URL: $youtubeUrl");
// // // // //           return youtubeUrl;
// // // // //         }
// // // // //       }

// // // // //       // Fallback: create a direct search URL that YouTube will handle
// // // // //       final fallbackUrl = "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // // // //       print("⚠️ Using fallback search URL: $fallbackUrl");
// // // // //       return fallbackUrl;

// // // // //     } catch (e) {
// // // // //       print("YouTube search error: $e");
// // // // //       // Return YouTube search URL as fallback
// // // // //       final fallbackUrl = "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // // // //       return fallbackUrl;
// // // // //     }
// // // // //   }

// // // // //   /// Open YouTube URL in the app or browser
// // // // //   static Future<void> _openYouTubeUrl(String url) async {
// // // // //     try {
// // // // //       final Uri uri = Uri.parse(url);

// // // // //       // Try to open in YouTube app first, then fallback to browser
// // // // //       final youtubeAppUrl = url.replaceFirst('https://www.youtube.com', 'youtube://');
// // // // //       final youtubeAppUri = Uri.parse(youtubeAppUrl);

// // // // //       bool opened = false;

// // // // //       // Try YouTube app first
// // // // //       try {
// // // // //         if (await canLaunchUrl(youtubeAppUri)) {
// // // // //           await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
// // // // //           opened = true;
// // // // //           print("✅ Opened in YouTube app");
// // // // //         }
// // // // //       } catch (e) {
// // // // //         print("YouTube app not available: $e");
// // // // //       }

// // // // //       // Fallback to browser if YouTube app failed
// // // // //       if (!opened) {
// // // // //         if (await canLaunchUrl(uri)) {
// // // // //           await launchUrl(uri, mode: LaunchMode.externalApplication);
// // // // //           print("✅ Opened in browser");
// // // // //         } else {
// // // // //           throw Exception("Cannot open YouTube URL");
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("Error opening YouTube URL: $e");
// // // // //       throw e;
// // // // //     }
// // // // //   }

// // // // //   /// Handle weather requests with location services
// // // // //   static Future<Map<String, dynamic>> _handleWeatherRequest(
// // // // //     String command,
// // // // //     String languageCode
// // // // //   ) async {
// // // // //     try {
// // // // //       double? lat, lon;
// // // // //       String location = "your location";

// // // // //       // Check if specific city is mentioned
// // // // //       String cityName = _extractCityFromCommand(command);

// // // // //       if (cityName.isNotEmpty) {
// // // // //         // Get coordinates for specific city using Gemini
// // // // //         final cityCoords = await _getCityCoordinates(cityName);
// // // // //         if (cityCoords != null) {
// // // // //           lat = cityCoords['lat'];
// // // // //           lon = cityCoords['lon'];
// // // // //           location = cityName;
// // // // //         }
// // // // //       } else {
// // // // //         // Use current location
// // // // //         final position = await _getCurrentPosition();
// // // // //         if (position != null) {
// // // // //           lat = position.latitude;
// // // // //           lon = position.longitude;
// // // // //         }
// // // // //       }

// // // // //       if (lat == null || lon == null) {
// // // // //         // Fallback to default location (Jaipur)
// // // // //         lat = 26.85;
// // // // //         lon = 75.78;
// // // // //         location = "Jaipur";
// // // // //       }

// // // // //       final weatherData = await _fetchWeatherData(lat, lon);
// // // // //       final weatherMessage = _formatWeatherMessage(weatherData, location);

// // // // //       return {
// // // // //         'status': 'success',
// // // // //         'message': await _translateToLanguage(weatherMessage, languageCode),
// // // // //         'type': 'weather',
// // // // //         'originalCommand': command,
// // // // //       };
// // // // //     } catch (e) {
// // // // //       print("Weather request error: $e");
// // // // //       return {
// // // // //         'status': 'error',
// // // // //         'message': await _translateToLanguage(
// // // // //           'Sorry, I cannot get weather information right now.',
// // // // //           languageCode
// // // // //         ),
// // // // //         'type': 'weather',
// // // // //         'originalCommand': command,
// // // // //       };
// // // // //     }
// // // // //   }

// // // // //   /// Get city coordinates using Gemini AI
// // // // //   static Future<Map<String, double>?> _getCityCoordinates(String cityName) async {
// // // // //     try {
// // // // //       if (!_isInitialized) return null;

// // // // //       final prompt = '''
// // // // // Please provide the latitude and longitude coordinates for the city: $cityName
// // // // // Return ONLY in this exact format: "lat:XX.XXXX,lon:XX.XXXX"
// // // // // Example: "lat:26.9124,lon:75.7873"
// // // // // ''';

// // // // //       final response = await _callGeminiAPI(prompt);
// // // // //       if (response != null) {
// // // // //         final regex = RegExp(r'lat:([-\d.]+),lon:([-\d.]+)');
// // // // //         final match = regex.firstMatch(response);
// // // // //         if (match != null) {
// // // // //           return {
// // // // //             'lat': double.parse(match.group(1)!),
// // // // //             'lon': double.parse(match.group(2)!),
// // // // //           };
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("Error getting city coordinates: $e");
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   /// Extract city name from weather command
// // // // //   static String _extractCityFromCommand(String command) {
// // // // //     final lowerCommand = command.toLowerCase();

// // // // //     // Common patterns for city mentions
// // // // //     final patterns = [
// // // // //       RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
// // // // //       RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
// // // // //       RegExp(r'([a-zA-Z\s]+) weather'),
// // // // //     ];

// // // // //     for (final pattern in patterns) {
// // // // //       final match = pattern.firstMatch(lowerCommand);
// // // // //       if (match != null) {
// // // // //         return match.group(1)!.trim();
// // // // //       }
// // // // //     }

// // // // //     return "";
// // // // //   }

// // // // //   /// Get current position with proper error handling
// // // // //   static Future<Position?> _getCurrentPosition() async {
// // // // //     try {
// // // // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // // // //       if (!serviceEnabled) {
// // // // //         print("Location services are disabled");
// // // // //         return null;
// // // // //       }

// // // // //       LocationPermission permission = await Geolocator.checkPermission();
// // // // //       if (permission == LocationPermission.denied) {
// // // // //         permission = await Geolocator.requestPermission();
// // // // //         if (permission == LocationPermission.denied) {
// // // // //           print("Location permissions are denied");
// // // // //           return null;
// // // // //         }
// // // // //       }

// // // // //       if (permission == LocationPermission.deniedForever) {
// // // // //         print("Location permissions are permanently denied");
// // // // //         return null;
// // // // //       }

// // // // //       return await Geolocator.getCurrentPosition(
// // // // //         desiredAccuracy: LocationAccuracy.low,
// // // // //         timeLimit: Duration(seconds: 10),
// // // // //       );
// // // // //     } catch (e) {
// // // // //       print("Error getting current position: $e");
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   /// Fetch weather data from Open-Meteo API
// // // // //   static Future<Map<String, dynamic>?> _fetchWeatherData(
// // // // //     double lat,
// // // // //     double lon
// // // // //   ) async {
// // // // //     try {
// // // // //       final url = 'https://api.open-meteo.com/v1/forecast?'
// // // // //           'latitude=$lat&longitude=$lon&'
// // // // //           'current_weather=true&'
// // // // //           'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
// // // // //           'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
// // // // //           'timezone=auto';

// // // // //       final response = await http.get(Uri.parse(url)).timeout(
// // // // //         Duration(seconds: 10),
// // // // //       );

// // // // //       if (response.statusCode == 200) {
// // // // //         return json.decode(response.body);
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("Error fetching weather data: $e");
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   /// Format weather message in a user-friendly way
// // // // //   static String _formatWeatherMessage(
// // // // //     Map<String, dynamic>? weatherData,
// // // // //     String location
// // // // //   ) {
// // // // //     if (weatherData == null || weatherData['current_weather'] == null) {
// // // // //       return "Sorry, I couldn't get weather information for $location right now.";
// // // // //     }

// // // // //     final current = weatherData['current_weather'];
// // // // //     final temp = current['temperature']?.round() ?? 0;
// // // // //     final windSpeed = current['windspeed']?.round() ?? 0;
// // // // //     final weatherCode = current['weathercode'] ?? 0;

// // // // //     String condition = _getWeatherCondition(weatherCode);

// // // // //     String message = "The weather in $location is currently $condition with a temperature of ${temp}°C";

// // // // //     if (windSpeed > 0) {
// // // // //       message += " and wind speed of ${windSpeed} km/h";
// // // // //     }

// // // // //     // Add daily forecast if available
// // // // //     if (weatherData['daily'] != null) {
// // // // //       final daily = weatherData['daily'];
// // // // //       final maxTemp = daily['temperature_2m_max']?[0]?.round();
// // // // //       final minTemp = daily['temperature_2m_min']?[0]?.round();

// // // // //       if (maxTemp != null && minTemp != null) {
// // // // //         message += ". Today's high will be ${maxTemp}°C and low ${minTemp}°C";
// // // // //       }
// // // // //     }

// // // // //     return message + ".";
// // // // //   }

// // // // //   /// Convert weather code to readable condition
// // // // //   static String _getWeatherCondition(int code) {
// // // // //     switch (code) {
// // // // //       case 0: return "clear sky";
// // // // //       case 1: case 2: case 3: return "partly cloudy";
// // // // //       case 45: case 48: return "foggy";
// // // // //       case 51: case 53: case 55: return "drizzly";
// // // // //       case 61: case 63: case 65: return "rainy";
// // // // //       case 71: case 73: case 75: return "snowy";
// // // // //       case 95: case 96: case 99: return "thunderstorms";
// // // // //       default: return "variable conditions";
// // // // //     }
// // // // //   }

// // // // //   /// Check if command is requesting time
// // // // //   static bool _isTimeRequest(String command) {
// // // // //     final lowerCommand = command.toLowerCase();
// // // // //     return lowerCommand.contains('time') ||
// // // // //            lowerCommand.contains('clock') ||
// // // // //            lowerCommand.contains('समय') ||
// // // // //            lowerCommand.contains('時間') ||
// // // // //            lowerCommand.contains('temps') ||
// // // // //            lowerCommand.contains('hora');
// // // // //   }

// // // // //   /// Check if command is requesting weather
// // // // //   static bool _isWeatherRequest(String command) {
// // // // //     final lowerCommand = command.toLowerCase();
// // // // //     return lowerCommand.contains('weather') ||
// // // // //            lowerCommand.contains('temperature') ||
// // // // //            lowerCommand.contains('मौसम') ||
// // // // //            lowerCommand.contains('天気') ||
// // // // //            lowerCommand.contains('temps') ||
// // // // //            lowerCommand.contains('clima');
// // // // //   }

// // // // //   /// Check if command is requesting music
// // // // //   static bool _isMusicRequest(String command) {
// // // // //     final lowerCommand = command.toLowerCase();
// // // // //     return lowerCommand.contains('play') ||
// // // // //            lowerCommand.contains('music') ||
// // // // //            lowerCommand.contains('song') ||
// // // // //            lowerCommand.contains('track') ||
// // // // //            lowerCommand.contains('गाना') ||
// // // // //            lowerCommand.contains('संगीत') ||
// // // // //            lowerCommand.contains('音楽') ||
// // // // //            lowerCommand.contains('música') ||
// // // // //            lowerCommand.contains('musique');
// // // // //   }

// // // // //   /// Check if language code is English
// // // // //   static bool _isEnglish(String languageCode) {
// // // // //     return languageCode.startsWith('en');
// // // // //   }

// // // // //   /// Translate text to English using Gemini
// // // // //   static Future<String> _translateToEnglish(String text, String fromLanguage) async {
// // // // //     try {
// // // // //       if (!_isInitialized) return text;

// // // // //       final prompt = '''
// // // // // Translate this text to English. Return ONLY the translation, no explanations:
// // // // // Text: "$text"
// // // // // From language: $fromLanguage
// // // // // ''';

// // // // //       final response = await _callGeminiAPI(prompt);
// // // // //       return response?.trim() ?? text;
// // // // //     } catch (e) {
// // // // //       print("Translation to English failed: $e");
// // // // //       return text;
// // // // //     }
// // // // //   }

// // // // //   /// Translate text to target language using Gemini
// // // // //   static Future<String> _translateToLanguage(String text, String languageCode) async {
// // // // //     if (_isEnglish(languageCode)) return text;

// // // // //     try {
// // // // //       if (!_isInitialized) return text;

// // // // //       final languageMap = {
// // // // //         'hi_IN': 'Hindi',
// // // // //         'ta_IN': 'Tamil',
// // // // //         'te_IN': 'Telugu',
// // // // //         'bn_IN': 'Bengali',
// // // // //         'mr_IN': 'Marathi',
// // // // //         'gu_IN': 'Gujarati',
// // // // //         'kn_IN': 'Kannada',
// // // // //         'ml_IN': 'Malayalam',
// // // // //         'pa_IN': 'Punjabi',
// // // // //         'es_ES': 'Spanish',
// // // // //         'fr_FR': 'French',
// // // // //         'de_DE': 'German',
// // // // //         'it_IT': 'Italian',
// // // // //         'pt_BR': 'Portuguese',
// // // // //         'zh_CN': 'Chinese',
// // // // //         'ja_JP': 'Japanese',
// // // // //         'ko_KR': 'Korean',
// // // // //         'ru_RU': 'Russian',
// // // // //         'ar_SA': 'Arabic',
// // // // //       };

// // // // //       final targetLanguage = languageMap[languageCode] ?? 'English';

// // // // //       final prompt = '''
// // // // // Translate this text to $targetLanguage. Return ONLY the translation, no explanations:
// // // // // Text: "$text"
// // // // // Keep the same tone and meaning. Make it natural and conversational.
// // // // // ''';

// // // // //       final response = await _callGeminiAPI(prompt);
// // // // //       return response?.trim() ?? text;
// // // // //     } catch (e) {
// // // // //       print("Translation to $languageCode failed: $e");
// // // // //       return text;
// // // // //     }
// // // // //   }

// // // // //   /// Create an enhanced prompt that provides context to Gemini
// // // // //   static String _createEnhancedPrompt(String userCommand, String languageCode) {
// // // // //     final targetLanguage = _getLanguageName(languageCode);

// // // // //     return '''
// // // // // You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

// // // // // Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// // // // // Guidelines:
// // // // // - Respond in $targetLanguage language
// // // // // - If asked about time, provide current time information
// // // // // - If asked about weather, explain that weather information is being fetched separately
// // // // // - If asked about music, explain that you're searching for the song on YouTube
// // // // // - If asked math questions, solve them clearly
// // // // // - If asked for jokes, tell a clean, family-friendly joke
// // // // // - If asked what you can do, list your main capabilities
// // // // // - For general questions, provide helpful information
// // // // // - Keep responses under 100 words for voice output
// // // // // - Be friendly and conversational

// // // // // User's request: $userCommand
// // // // // ''';
// // // // //   }

// // // // //   /// Get language name from code
// // // // //   static String _getLanguageName(String code) {
// // // // //     final languages = {
// // // // //       'en_US': 'English',
// // // // //       'en_GB': 'English',
// // // // //       'hi_IN': 'Hindi',
// // // // //       'ta_IN': 'Tamil',
// // // // //       'te_IN': 'Telugu',
// // // // //       'bn_IN': 'Bengali',
// // // // //       'mr_IN': 'Marathi',
// // // // //       'gu_IN': 'Gujarati',
// // // // //       'kn_IN': 'Kannada',
// // // // //       'ml_IN': 'Malayalam',
// // // // //       'pa_IN': 'Punjabi',
// // // // //       'es_ES': 'Spanish',
// // // // //       'fr_FR': 'French',
// // // // //       'de_DE': 'German',
// // // // //       'it_IT': 'Italian',
// // // // //       'pt_BR': 'Portuguese',
// // // // //       'zh_CN': 'Chinese',
// // // // //       'ja_JP': 'Japanese',
// // // // //       'ko_KR': 'Korean',
// // // // //       'ru_RU': 'Russian',
// // // // //       'ar_SA': 'Arabic',
// // // // //     };
// // // // //     return languages[code] ?? 'English';
// // // // //   }

// // // // //   /// Make the actual API call to Gemini using the flutter_gemini package
// // // // //   static Future<String?> _callGeminiAPI(String prompt) async {
// // // // //     try {
// // // // //       if (!_isInitialized) {
// // // // //         print("Gemini not initialized");
// // // // //         return null;
// // // // //       }

// // // // //       print("Sending request to Flutter Gemini...");
// // // // //       final gemini = Gemini.instance;

// // // // //       final response = await gemini
// // // // //           .prompt(parts: [Part.text(prompt)])
// // // // //           .timeout(timeoutDuration);

// // // // //       print("Flutter Gemini API Response received");

// // // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // // //         final outputText = response.output!;
// // // // //         print(
// // // // //           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
// // // // //         );
// // // // //         return outputText;
// // // // //       } else {
// // // // //         print("Empty response output");
// // // // //         return null;
// // // // //       }
// // // // //     } on TimeoutException {
// // // // //       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
// // // // //       rethrow;
// // // // //     } catch (e) {
// // // // //       print("Unexpected error in API call: $e");
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   /// Analyze the response to determine what type of response it is
// // // // //   static String _analyzeResponseType(String command, String response) {
// // // // //     final lowerCommand = command.toLowerCase();

// // // // //     if (_isTimeRequest(command)) {
// // // // //       return 'time';
// // // // //     } else if (_isWeatherRequest(command)) {
// // // // //       return 'weather';
// // // // //     } else if (_isMusicRequest(command)) {
// // // // //       return 'music';
// // // // //     } else if (lowerCommand.contains('calculate') ||
// // // // //         lowerCommand.contains('math') ||
// // // // //         lowerCommand.contains('+') ||
// // // // //         lowerCommand.contains('-') ||
// // // // //         lowerCommand.contains('*') ||
// // // // //         lowerCommand.contains('/')) {
// // // // //       return 'calculation';
// // // // //     } else if (lowerCommand.contains('joke') ||
// // // // //         lowerCommand.contains('funny')) {
// // // // //       return 'joke';
// // // // //     } else if (lowerCommand.contains('help') ||
// // // // //         lowerCommand.contains('what can you do')) {
// // // // //       return 'help';
// // // // //     } else {
// // // // //       return 'general';
// // // // //     }
// // // // //   }

// // // // //   /// Update assistant name
// // // // //   static Future<Map<String, dynamic>> updateAssistantName(
// // // // //     String newName,
// // // // //   ) async {
// // // // //     return {
// // // // //       'status': 'success',
// // // // //       'message': 'Assistant name updated to $newName',
// // // // //     };
// // // // //   }

// // // // //   /// Test the Gemini API connection
// // // // //   static Future<Map<String, dynamic>> testConnection() async {
// // // // //     try {
// // // // //       print("Testing connection to Flutter Gemini API...");

// // // // //       if (!_isInitialized) {
// // // // //         return {
// // // // //           'status': 'error',
// // // // //           'message': 'Gemini not initialized. Please check your API key.',
// // // // //         };
// // // // //       }

// // // // //       final gemini = Gemini.instance;
// // // // //       final response = await gemini
// // // // //           .prompt(
// // // // //             parts: [
// // // // //               Part.text(
// // // // //                 "Hello, respond with just 'Hello' to test the connection",
// // // // //               ),
// // // // //             ],
// // // // //           )
// // // // //           .timeout(Duration(seconds: 10));

// // // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // // //         return {
// // // // //           'status': 'success',
// // // // //           'message':
// // // // //               'Flutter Gemini API is working perfectly! Response: ${response.output}',
// // // // //         };
// // // // //       } else {
// // // // //         return {
// // // // //           'status': 'error',
// // // // //           'message': 'API responded but with empty content',
// // // // //         };
// // // // //       }
// // // // //     } on TimeoutException {
// // // // //       return {
// // // // //         'status': 'timeout',
// // // // //         'message': 'Connection test timed out. Check your internet connection.',
// // // // //       };
// // // // //     } catch (e) {
// // // // //       return {
// // // // //         'status': 'error',
// // // // //         'message': 'Connection test failed: ${e.toString()}',
// // // // //       };
// // // // //     }
// // // // //   }

// // // // //   /// Get current time (helper function)
// // // // //   static String getCurrentTime() {
// // // // //     final now = DateTime.now();
// // // // //     final hour = now.hour;
// // // // //     final minute = now.minute.toString().padLeft(2, '0');
// // // // //     final period = hour >= 12 ? 'PM' : 'AM';
// // // // //     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

// // // // //     return "The current time is $displayHour:$minute $period";
// // // // //   }

// // // // //   /// Get sample responses for offline mode
// // // // //   static Map<String, dynamic> getOfflineResponse(String command) {
// // // // //     final lowerCommand = command.toLowerCase();

// // // // //     if (_isTimeRequest(command)) {
// // // // //       return {'status': 'success', 'message': getCurrentTime(), 'type': 'time'};
// // // // //     } else if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
// // // // //       return {
// // // // //         'status': 'success',
// // // // //         'message':
// // // // //             'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// // // // //         'type': 'greeting',
// // // // //       };
// // // // //     } else if (lowerCommand.contains('joke') ||
// // // // //         lowerCommand.contains('funny')) {
// // // // //       final jokes = [
// // // // //         "Why don't scientists trust atoms? Because they make up everything!",
// // // // //         "Why did the scarecrow win an award? He was outstanding in his field!",
// // // // //         "Why don't eggs tell jokes? They'd crack each other up!",
// // // // //         "What do you call a bear with no teeth? A gummy bear!",
// // // // //         "Why don't programmers like nature? It has too many bugs!",
// // // // //       ];
// // // // //       final randomJoke = jokes[DateTime.now().millisecond % jokes.length];
// // // // //       return {'status': 'success', 'message': randomJoke, 'type': 'joke'};
// // // // //     } else if (_isWeatherRequest(command)) {
// // // // //       return {
// // // // //         'status': 'success',
// // // // //         'message':
// // // // //             'I can\'t check the weather in offline mode, but you can check your local weather app!',
// // // // //         'type': 'weather',
// // // // //       };
// // // // //     } else if (_isMusicRequest

// // // // import 'dart:async';
// // // // import 'dart:convert';
// // // // import 'package:flutter_gemini/flutter_gemini.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:geolocator/geolocator.dart';
// // // // import 'package:url_launcher/url_launcher.dart';
// // // // import 'joke_service.dart';

// // // // class GeminiService {
// // // //   static const String apiKey = 'AIzaSyCxCJoOU1A5JPDAwtmpt5nr-Q97jTqLNzg';
// // // //   static const Duration timeoutDuration = Duration(seconds: 15);
// // // //   static bool _isInitialized = false;

// // // //   /// Initialize the Gemini service
// // // //   static void init() {
// // // //     if (apiKey != 'gh') {
// // // //       try {
// // // //         Gemini.init(apiKey: apiKey);
// // // //         _isInitialized = true;
// // // //         print("✅ Flutter Gemini initialized successfully");
// // // //       } catch (e) {
// // // //         print("❌ Failed to initialize Gemini: $e");
// // // //         _isInitialized = false;
// // // //       }
// // // //     } else {
// // // //       print("⚠️ Gemini API key not set, using offline mode");
// // // //       _isInitialized = false;
// // // //     }
// // // //   }

// // // //   /// Check if Gemini is properly initialized
// // // //   static bool get isInitialized => _isInitialized;

// // // //   /// Process any voice command using Gemini API with language support
// // // //   static Future<Map<String, dynamic>> processCommand(
// // // //     String command,
// // // //     String languageCode,
// // // //   ) async {
// // // //     try {
// // // //       print(
// // // //         "Processing command with Flutter Gemini: $command in language: $languageCode",
// // // //       );

// // // //       // Handle time requests locally (faster and more accurate)
// // // //       if (_isTimeRequest(command)) {
// // // //         final timeResponse = getCurrentTime();
// // // //         return {
// // // //           'status': 'success',
// // // //           'message': await _translateToLanguage(timeResponse, languageCode),
// // // //           'type': 'time',
// // // //           'originalCommand': command,
// // // //         };
// // // //       }

// // // //       // Handle weather requests with API integration
// // // //       if (_isWeatherRequest(command)) {
// // // //         return await _handleWeatherRequest(command, languageCode);
// // // //       }

// // // //       // Handle music requests with YouTube search
// // // //       if (_isMusicRequest(command)) {
// // // //         return await _handleMusicRequest(command, languageCode);
// // // //       }

// // // //       // Handle joke requests with enhanced dynamic generation
// // // //       if (_isJokeRequest(command)) {
// // // //         return await _handleJokeRequest(command, languageCode, _isInitialized);
// // // //       }

// // // //       if (!_isInitialized) {
// // // //         print("⚠️ Gemini not initialized, using offline mode");
// // // //         final offlineResponse = getOfflineResponse(command);
// // // //         offlineResponse['message'] = await _translateToLanguage(
// // // //           offlineResponse['message'],
// // // //           languageCode,
// // // //         );
// // // //         return offlineResponse;
// // // //       }

// // // //       // Translate non-English commands to English for Gemini
// // // //       String processedCommand = command;
// // // //       if (!_isEnglish(languageCode)) {
// // // //         processedCommand = await _translateToEnglish(command, languageCode);
// // // //       }

// // // //       final String enhancedPrompt = _createEnhancedPrompt(
// // // //         processedCommand,
// // // //         languageCode,
// // // //       );
// // // //       final response = await _callGeminiAPI(enhancedPrompt);

// // // //       if (response != null && response.isNotEmpty) {
// // // //         final responseType = _analyzeResponseType(processedCommand, response);

// // // //         // Translate response back to target language if needed
// // // //         String finalResponse = response;
// // // //         if (!_isEnglish(languageCode)) {
// // // //           finalResponse = await _translateToLanguage(response, languageCode);
// // // //         }

// // // //         return {
// // // //           'status': 'success',
// // // //           'message': finalResponse,
// // // //           'type': responseType,
// // // //           'originalCommand': command,
// // // //         };
// // // //       } else {
// // // //         print("Empty response from Gemini API, falling back to offline");
// // // //         final offlineResponse = getOfflineResponse(command);
// // // //         offlineResponse['message'] = await _translateToLanguage(
// // // //           offlineResponse['message'],
// // // //           languageCode,
// // // //         );
// // // //         return offlineResponse;
// // // //       }
// // // //     } on TimeoutException catch (e) {
// // // //       print("Gemini API timeout: $e");
// // // //       return {
// // // //         'status': 'timeout',
// // // //         'message': await _translateToLanguage(
// // // //           'Request timed out. Using offline response.',
// // // //           languageCode,
// // // //         ),
// // // //         'type': 'offline',
// // // //         'fallback': getOfflineResponse(command),
// // // //       };
// // // //     } catch (e) {
// // // //       print("Error in Gemini API call: $e");
// // // //       final offlineResponse = getOfflineResponse(command);
// // // //       offlineResponse['message'] = await _translateToLanguage(
// // // //         offlineResponse['message'],
// // // //         languageCode,
// // // //       );
// // // //       return {
// // // //         'status': 'error',
// // // //         'message': await _translateToLanguage(
// // // //           'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
// // // //           languageCode,
// // // //         ),
// // // //         'type': 'offline',
// // // //         'fallback': offlineResponse,
// // // //       };
// // // //     }
// // // //   }

// // // //   /// Enhanced joke handling with dynamic generation
// // // //   // static Future<Map<String, dynamic>> _handleJokeRequest(
// // // //   //   String command,
// // // //   //   String languageCode,
// // // //   //   bool isOnlineMode,
// // // //   // ) async {
// // // //   //   try {
// // // //   //     print("😄 Processing joke request: $command");

// // // //   //     // Determine specific joke category if mentioned
// // // //   //     final category = JokeService.getSpecificJokeCategory(command);

// // // //   //     // Generate joke using the enhanced service
// // // //   //     final joke = await JokeService.generateJoke(
// // // //   //       languageCode,
// // // //   //       isOnlineMode,
// // // //   //       _callGeminiAPI, // Pass our Gemini API caller
// // // //   //     );

// // // //   //     return {
// // // //   //       'status': 'success',
// // // //   //       'message': joke,
// // // //   //       'type': 'joke',
// // // //   //       'originalCommand': command,
// // // //   //       'category': category,
// // // //   //     };
// // // //   //   } catch (e) {
// // // //   //     print("Joke request error: $e");
// // // //   //     // Fallback to offline joke
// // // //   //     final fallbackJoke = JokeService.getRandomFallbackJoke();
// // // //   //     return {
// // // //   //       'status': 'success',
// // // //   //       'message': fallbackJoke,
// // // //   //       'type': 'joke',
// // // //   //       'originalCommand': command,
// // // //   //       'fallback': true,
// // // //   //     };
// // // //   //   }
// // // //   // }
// // // //   static Future<Map<String, dynamic>> _handleJokeRequest(
// // // //     String command,
// // // //     String languageCode,
// // // //     bool isOnlineMode,
// // // //   ) async {
// // // //     try {
// // // //       print("😄 Processing joke request: $command");

// // // //       // Determine specific joke category if mentioned
// // // //       final category = JokeService.getSpecificJokeCategory(command);

// // // //       // Generate joke using the external API service
// // // //       final joke = await JokeService.generateJoke(languageCode, isOnlineMode);

// // // //       // If it's not English, translate the joke
// // // //       String finalJoke = joke;
// // // //       if (!_isEnglish(languageCode) && isOnlineMode && _isInitialized) {
// // // //         try {
// // // //           finalJoke = await _translateToLanguage(joke, languageCode);
// // // //         } catch (e) {
// // // //           print("Translation failed, using original joke: $e");
// // // //           finalJoke = joke; // Use original if translation fails
// // // //         }
// // // //       }

// // // //       return {
// // // //         'status': 'success',
// // // //         'message': finalJoke,
// // // //         'type': 'joke',
// // // //         'originalCommand': command,
// // // //         'category': category,
// // // //         'source': isOnlineMode ? 'external_api' : 'fallback',
// // // //       };
// // // //     } catch (e) {
// // // //       print("Joke request error: $e");
// // // //       // Fallback to offline joke
// // // //       final fallbackJoke = JokeService.getRandomFallbackJoke();
// // // //       return {
// // // //         'status': 'success',
// // // //         'message': fallbackJoke,
// // // //         'type': 'joke',
// // // //         'originalCommand': command,
// // // //         'fallback': true,
// // // //         'source': 'fallback',
// // // //       };
// // // //     }
// // // //   }

// // // //   // Update the offline response method for jokes
// // // //   static Map<String, dynamic> getOfflineResponse(String command) {
// // // //     final lowerCommand = command.toLowerCase();

// // // //     if (_isTimeRequest(command)) {
// // // //       return {'status': 'success', 'message': getCurrentTime(), 'type': 'time'};
// // // //     } else if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// // // //         'type': 'greeting',
// // // //       };
// // // //     } else if (_isJokeRequest(command)) {
// // // //       // Use external API even in offline mode will fall back to local jokes
// // // //       final joke = JokeService.getRandomFallbackJoke();
// // // //       return {
// // // //         'status': 'success',
// // // //         'message': joke,
// // // //         'type': 'joke',
// // // //         'offline': true,
// // // //         'source': 'fallback',
// // // //       };
// // // //     } else if (_isWeatherRequest(command)) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can\'t check the weather in offline mode, but you can check your local weather app!',
// // // //         'type': 'weather',
// // // //       };
// // // //     } else if (_isMusicRequest(command)) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can\'t search for music in offline mode, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
// // // //         'type': 'music',
// // // //       };
// // // //     } else if (lowerCommand.contains('calculate') ||
// // // //         lowerCommand.contains('math')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
// // // //         'type': 'calculation',
// // // //       };
// // // //     } else if (lowerCommand.contains('help') ||
// // // //         lowerCommand.contains('what can you do')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can tell you the time, check weather, play music from YouTube, tell fresh jokes from the internet, help with basic questions, and chat with you! For advanced features, try switching to online mode.',
// // // //         'type': 'help',
// // // //       };
// // // //     } else {
// // // //       final responses = [
// // // //         'I\'m currently in offline mode, but I can still help with basic tasks!',
// // // //         'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
// // // //         'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
// // // //         'Thanks for talking with me! I can do more when connected to the internet.',
// // // //       ];
// // // //       final randomResponse =
// // // //           responses[DateTime.now().millisecond % responses.length];
// // // //       return {
// // // //         'status': 'success',
// // // //         'message': randomResponse,
// // // //         'type': 'offline',
// // // //       };
// // // //     }
// // // //   }

// // // //   /// Handle music requests with YouTube search and direct opening
// // // //   static Future<Map<String, dynamic>> _handleMusicRequest(
// // // //     String command,
// // // //     String languageCode,
// // // //   ) async {
// // // //     try {
// // // //       print("🎵 Processing music request: $command");

// // // //       // Extract song/artist name from command
// // // //       String searchQuery = _extractMusicQuery(command);

// // // //       if (searchQuery.isEmpty) {
// // // //         // If no specific song mentioned, ask Gemini for popular songs
// // // //         searchQuery = await _getPopularSongSuggestion(command);
// // // //       }

// // // //       // Search YouTube and get the first result
// // // //       final youtubeUrl = await _searchYouTubeMusic(searchQuery);

// // // //       if (youtubeUrl != null) {
// // // //         // Open YouTube URL
// // // //         await _openYouTubeUrl(youtubeUrl);

// // // //         final successMessage = searchQuery.isNotEmpty
// // // //             ? "Opening '$searchQuery' on YouTube Music!"
// // // //             : "Opening music on YouTube!";

// // // //         return {
// // // //           'status': 'success',
// // // //           'message': await _translateToLanguage(successMessage, languageCode),
// // // //           'type': 'music',
// // // //           'originalCommand': command,
// // // //           'youtubeUrl': youtubeUrl,
// // // //           'searchQuery': searchQuery,
// // // //         };
// // // //       } else {
// // // //         return {
// // // //           'status': 'error',
// // // //           'message': await _translateToLanguage(
// // // //             "Sorry, I couldn't find that song on YouTube. Try being more specific with the song name or artist.",
// // // //             languageCode,
// // // //           ),
// // // //           'type': 'music',
// // // //           'originalCommand': command,
// // // //         };
// // // //       }
// // // //     } catch (e) {
// // // //       print("Music request error: $e");
// // // //       return {
// // // //         'status': 'error',
// // // //         'message': await _translateToLanguage(
// // // //           'Sorry, I cannot play music right now. Please try again later.',
// // // //           languageCode,
// // // //         ),
// // // //         'type': 'music',
// // // //         'originalCommand': command,
// // // //       };
// // // //     }
// // // //   }

// // // //   /// Extract music query from voice command
// // // //   static String _extractMusicQuery(String command) {
// // // //     final lowerCommand = command.toLowerCase();

// // // //     // Remove common music command words
// // // //     String query = lowerCommand
// // // //         .replaceAll('play', '')
// // // //         .replaceAll('song', '')
// // // //         .replaceAll('music', '')
// // // //         .replaceAll('track', '')
// // // //         .replaceAll('by', '')
// // // //         .replaceAll('from', '')
// // // //         .replaceAll('the', '')
// // // //         .replaceAll('a', '')
// // // //         .trim();

// // // //     // Handle patterns like "play [song] by [artist]"
// // // //     if (query.contains(' by ')) {
// // // //       final parts = query.split(' by ');
// // // //       if (parts.length >= 2) {
// // // //         return "${parts[0].trim()} ${parts[1].trim()}";
// // // //       }
// // // //     }

// // // //     return query;
// // // //   }

// // // //   /// Get popular song suggestion using Gemini when no specific song is mentioned
// // // //   static Future<String> _getPopularSongSuggestion(String command) async {
// // // //     try {
// // // //       if (!_isInitialized) return "popular music";

// // // //       final prompt =
// // // //           '''
// // // // The user wants to listen to music but didn't specify a song. Command: "$command"
// // // // Suggest ONE popular song name with artist that would be good to play.
// // // // Return ONLY the song name and artist in this format: "Song Name Artist Name"
// // // // Example: "Shape of You Ed Sheeran"
// // // // Make it a currently popular or classic hit song.
// // // // ''';

// // // //       final response = await _callGeminiAPI(prompt);
// // // //       return response?.trim() ?? "popular music";
// // // //     } catch (e) {
// // // //       print("Error getting song suggestion: $e");
// // // //       return "popular music";
// // // //     }
// // // //   }

// // // //   /// Search YouTube for music and return the first video URL
// // // //   static Future<String?> _searchYouTubeMusic(String query) async {
// // // //     try {
// // // //       // Create YouTube search URL
// // // //       final encodedQuery = Uri.encodeComponent("$query music video");
// // // //       final searchUrl =
// // // //           "https://www.youtube.com/results?search_query=$encodedQuery";

// // // //       print("🔍 Searching YouTube for: $query");

// // // //       // Make HTTP request to YouTube search
// // // //       final response = await http
// // // //           .get(
// // // //             Uri.parse(searchUrl),
// // // //             headers: {
// // // //               'User-Agent':
// // // //                   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
// // // //             },
// // // //           )
// // // //           .timeout(Duration(seconds: 10));

// // // //       if (response.statusCode == 200) {
// // // //         final body = response.body;

// // // //         // Extract video ID from YouTube search results
// // // //         final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
// // // //         final match = videoIdRegex.firstMatch(body);

// // // //         if (match != null) {
// // // //           final videoId = match.group(1);
// // // //           final youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
// // // //           print("✅ Found YouTube URL: $youtubeUrl");
// // // //           return youtubeUrl;
// // // //         }
// // // //       }

// // // //       // Fallback: create a direct search URL that YouTube will handle
// // // //       final fallbackUrl =
// // // //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // // //       print("⚠️ Using fallback search URL: $fallbackUrl");
// // // //       return fallbackUrl;
// // // //     } catch (e) {
// // // //       print("YouTube search error: $e");
// // // //       // Return YouTube search URL as fallback
// // // //       final fallbackUrl =
// // // //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // // //       return fallbackUrl;
// // // //     }
// // // //   }

// // // //   /// Open YouTube URL in the app or browser
// // // //   static Future<void> _openYouTubeUrl(String url) async {
// // // //     try {
// // // //       final Uri uri = Uri.parse(url);

// // // //       // Try to open in YouTube app first, then fallback to browser
// // // //       final youtubeAppUrl = url.replaceFirst(
// // // //         'https://www.youtube.com',
// // // //         'youtube://',
// // // //       );
// // // //       final youtubeAppUri = Uri.parse(youtubeAppUrl);

// // // //       bool opened = false;

// // // //       // Try YouTube app first
// // // //       try {
// // // //         if (await canLaunchUrl(youtubeAppUri)) {
// // // //           await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
// // // //           opened = true;
// // // //           print("✅ Opened in YouTube app");
// // // //         }
// // // //       } catch (e) {
// // // //         print("YouTube app not available: $e");
// // // //       }

// // // //       // Fallback to browser if YouTube app failed
// // // //       if (!opened) {
// // // //         if (await canLaunchUrl(uri)) {
// // // //           await launchUrl(uri, mode: LaunchMode.externalApplication);
// // // //           print("✅ Opened in browser");
// // // //         } else {
// // // //           throw Exception("Cannot open YouTube URL");
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error opening YouTube URL: $e");
// // // //       throw e;
// // // //     }
// // // //   }

// // // //   /// Handle weather requests with location services
// // // //   static Future<Map<String, dynamic>> _handleWeatherRequest(
// // // //     String command,
// // // //     String languageCode,
// // // //   ) async {
// // // //     try {
// // // //       double? lat, lon;
// // // //       String location = "your location";

// // // //       // Check if specific city is mentioned
// // // //       String cityName = _extractCityFromCommand(command);

// // // //       if (cityName.isNotEmpty) {
// // // //         // Get coordinates for specific city using Gemini
// // // //         final cityCoords = await _getCityCoordinates(cityName);
// // // //         if (cityCoords != null) {
// // // //           lat = cityCoords['lat'];
// // // //           lon = cityCoords['lon'];
// // // //           location = cityName;
// // // //         }
// // // //       } else {
// // // //         // Use current location
// // // //         final position = await _getCurrentPosition();
// // // //         if (position != null) {
// // // //           lat = position.latitude;
// // // //           lon = position.longitude;
// // // //         }
// // // //       }

// // // //       if (lat == null || lon == null) {
// // // //         // Fallback to default location (Jaipur)
// // // //         lat = 26.85;
// // // //         lon = 75.78;
// // // //         location = "Jaipur";
// // // //       }

// // // //       final weatherData = await _fetchWeatherData(lat, lon);
// // // //       final weatherMessage = _formatWeatherMessage(weatherData, location);

// // // //       return {
// // // //         'status': 'success',
// // // //         'message': await _translateToLanguage(weatherMessage, languageCode),
// // // //         'type': 'weather',
// // // //         'originalCommand': command,
// // // //       };
// // // //     } catch (e) {
// // // //       print("Weather request error: $e");
// // // //       return {
// // // //         'status': 'error',
// // // //         'message': await _translateToLanguage(
// // // //           'Sorry, I cannot get weather information right now.',
// // // //           languageCode,
// // // //         ),
// // // //         'type': 'weather',
// // // //         'originalCommand': command,
// // // //       };
// // // //     }
// // // //   }

// // // //   /// Get city coordinates using Gemini AI
// // // //   static Future<Map<String, double>?> _getCityCoordinates(
// // // //     String cityName,
// // // //   ) async {
// // // //     try {
// // // //       if (!_isInitialized) return null;

// // // //       final prompt =
// // // //           '''
// // // // Please provide the latitude and longitude coordinates for the city: $cityName
// // // // Return ONLY in this exact format: "lat:XX.XXXX,lon:XX.XXXX"
// // // // Example: "lat:26.9124,lon:75.7873"
// // // // ''';

// // // //       final response = await _callGeminiAPI(prompt);
// // // //       if (response != null) {
// // // //         final regex = RegExp(r'lat:([-\d.]+),lon:([-\d.]+)');
// // // //         final match = regex.firstMatch(response);
// // // //         if (match != null) {
// // // //           return {
// // // //             'lat': double.parse(match.group(1)!),
// // // //             'lon': double.parse(match.group(2)!),
// // // //           };
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error getting city coordinates: $e");
// // // //     }
// // // //     return null;
// // // //   }

// // // //   /// Extract city name from weather command
// // // //   static String _extractCityFromCommand(String command) {
// // // //     final lowerCommand = command.toLowerCase();

// // // //     // Common patterns for city mentions
// // // //     final patterns = [
// // // //       RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
// // // //       RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
// // // //       RegExp(r'([a-zA-Z\s]+) weather'),
// // // //     ];

// // // //     for (final pattern in patterns) {
// // // //       final match = pattern.firstMatch(lowerCommand);
// // // //       if (match != null) {
// // // //         return match.group(1)!.trim();
// // // //       }
// // // //     }

// // // //     return "";
// // // //   }

// // // //   /// Get current position with proper error handling
// // // //   static Future<Position?> _getCurrentPosition() async {
// // // //     try {
// // // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // // //       if (!serviceEnabled) {
// // // //         print("Location services are disabled");
// // // //         return null;
// // // //       }

// // // //       LocationPermission permission = await Geolocator.checkPermission();
// // // //       if (permission == LocationPermission.denied) {
// // // //         permission = await Geolocator.requestPermission();
// // // //         if (permission == LocationPermission.denied) {
// // // //           print("Location permissions are denied");
// // // //           return null;
// // // //         }
// // // //       }

// // // //       if (permission == LocationPermission.deniedForever) {
// // // //         print("Location permissions are permanently denied");
// // // //         return null;
// // // //       }

// // // //       return await Geolocator.getCurrentPosition(
// // // //         desiredAccuracy: LocationAccuracy.low,
// // // //         timeLimit: Duration(seconds: 10),
// // // //       );
// // // //     } catch (e) {
// // // //       print("Error getting current position: $e");
// // // //       return null;
// // // //     }
// // // //   }

// // // //   /// Fetch weather data from Open-Meteo API
// // // //   static Future<Map<String, dynamic>?> _fetchWeatherData(
// // // //     double lat,
// // // //     double lon,
// // // //   ) async {
// // // //     try {
// // // //       final url =
// // // //           'https://api.open-meteo.com/v1/forecast?'
// // // //           'latitude=$lat&longitude=$lon&'
// // // //           'current_weather=true&'
// // // //           'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
// // // //           'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
// // // //           'timezone=auto';

// // // //       final response = await http
// // // //           .get(Uri.parse(url))
// // // //           .timeout(Duration(seconds: 10));

// // // //       if (response.statusCode == 200) {
// // // //         return json.decode(response.body);
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error fetching weather data: $e");
// // // //     }
// // // //     return null;
// // // //   }

// // // //   /// Format weather message in a user-friendly way
// // // //   static String _formatWeatherMessage(
// // // //     Map<String, dynamic>? weatherData,
// // // //     String location,
// // // //   ) {
// // // //     if (weatherData == null || weatherData['current_weather'] == null) {
// // // //       return "Sorry, I couldn't get weather information for $location right now.";
// // // //     }

// // // //     final current = weatherData['current_weather'];
// // // //     final temp = current['temperature']?.round() ?? 0;
// // // //     final windSpeed = current['windspeed']?.round() ?? 0;
// // // //     final weatherCode = current['weathercode'] ?? 0;

// // // //     String condition = _getWeatherCondition(weatherCode);

// // // //     String message =
// // // //         "The weather in $location is currently $condition with a temperature of ${temp}°C";

// // // //     if (windSpeed > 0) {
// // // //       message += " and wind speed of ${windSpeed} km/h";
// // // //     }

// // // //     // Add daily forecast if available
// // // //     if (weatherData['daily'] != null) {
// // // //       final daily = weatherData['daily'];
// // // //       final maxTemp = daily['temperature_2m_max']?[0]?.round();
// // // //       final minTemp = daily['temperature_2m_min']?[0]?.round();

// // // //       if (maxTemp != null && minTemp != null) {
// // // //         message += ". Today's high will be ${maxTemp}°C and low ${minTemp}°C";
// // // //       }
// // // //     }

// // // //     return message + ".";
// // // //   }

// // // //   /// Convert weather code to readable condition
// // // //   static String _getWeatherCondition(int code) {
// // // //     switch (code) {
// // // //       case 0:
// // // //         return "clear sky";
// // // //       case 1:
// // // //       case 2:
// // // //       case 3:
// // // //         return "partly cloudy";
// // // //       case 45:
// // // //       case 48:
// // // //         return "foggy";
// // // //       case 51:
// // // //       case 53:
// // // //       case 55:
// // // //         return "drizzly";
// // // //       case 61:
// // // //       case 63:
// // // //       case 65:
// // // //         return "rainy";
// // // //       case 71:
// // // //       case 73:
// // // //       case 75:
// // // //         return "snowy";
// // // //       case 95:
// // // //       case 96:
// // // //       case 99:
// // // //         return "thunderstorms";
// // // //       default:
// // // //         return "variable conditions";
// // // //     }
// // // //   }

// // // //   // All the checking methods
// // // //   static bool _isTimeRequest(String command) {
// // // //     final lowerCommand = command.toLowerCase();
// // // //     return lowerCommand.contains('time') ||
// // // //         lowerCommand.contains('clock') ||
// // // //         lowerCommand.contains('समय') ||
// // // //         lowerCommand.contains('時間') ||
// // // //         lowerCommand.contains('temps') ||
// // // //         lowerCommand.contains('hora');
// // // //   }

// // // //   static bool _isWeatherRequest(String command) {
// // // //     final lowerCommand = command.toLowerCase();
// // // //     return lowerCommand.contains('weather') ||
// // // //         lowerCommand.contains('temperature') ||
// // // //         lowerCommand.contains('मौसम') ||
// // // //         lowerCommand.contains('天気') ||
// // // //         lowerCommand.contains('temps') ||
// // // //         lowerCommand.contains('clima');
// // // //   }

// // // //   static bool _isMusicRequest(String command) {
// // // //     final lowerCommand = command.toLowerCase();
// // // //     return lowerCommand.contains('play') ||
// // // //         lowerCommand.contains('music') ||
// // // //         lowerCommand.contains('song') ||
// // // //         lowerCommand.contains('track') ||
// // // //         lowerCommand.contains('गाना') ||
// // // //         lowerCommand.contains('संगीत') ||
// // // //         lowerCommand.contains('音楽') ||
// // // //         lowerCommand.contains('música') ||
// // // //         lowerCommand.contains('musique');
// // // //   }

// // // //   static bool _isJokeRequest(String command) {
// // // //     final lowerCommand = command.toLowerCase();
// // // //     return lowerCommand.contains('joke') ||
// // // //         lowerCommand.contains('funny') ||
// // // //         lowerCommand.contains('humor') ||
// // // //         lowerCommand.contains('laugh') ||
// // // //         lowerCommand.contains('comedy') ||
// // // //         lowerCommand.contains('हंसी') ||
// // // //         lowerCommand.contains('मजाक') ||
// // // //         lowerCommand.contains('笑话') ||
// // // //         lowerCommand.contains('冗談') ||
// // // //         lowerCommand.contains('broma') ||
// // // //         lowerCommand.contains('blague');
// // // //   }

// // // //   static bool _isEnglish(String languageCode) {
// // // //     return languageCode.startsWith('en');
// // // //   }

// // // //   // Translation methods
// // // //   static Future<String> _translateToEnglish(
// // // //     String text,
// // // //     String fromLanguage,
// // // //   ) async {
// // // //     try {
// // // //       if (!_isInitialized) return text;

// // // //       final prompt =
// // // //           '''
// // // // Translate this text to English. Return ONLY the translation, no explanations:
// // // // Text: "$text"
// // // // From language: $fromLanguage
// // // // ''';

// // // //       final response = await _callGeminiAPI(prompt);
// // // //       return response?.trim() ?? text;
// // // //     } catch (e) {
// // // //       print("Translation to English failed: $e");
// // // //       return text;
// // // //     }
// // // //   }

// // // //   static Future<String> _translateToLanguage(
// // // //     String text,
// // // //     String languageCode,
// // // //   ) async {
// // // //     if (_isEnglish(languageCode)) return text;

// // // //     try {
// // // //       if (!_isInitialized) return text;

// // // //       final languageMap = {
// // // //         'hi_IN': 'Hindi',
// // // //         'ta_IN': 'Tamil',
// // // //         'te_IN': 'Telugu',
// // // //         'bn_IN': 'Bengali',
// // // //         'mr_IN': 'Marathi',
// // // //         'gu_IN': 'Gujarati',
// // // //         'kn_IN': 'Kannada',
// // // //         'ml_IN': 'Malayalam',
// // // //         'pa_IN': 'Punjabi',
// // // //         'es_ES': 'Spanish',
// // // //         'fr_FR': 'French',
// // // //         'de_DE': 'German',
// // // //         'it_IT': 'Italian',
// // // //         'pt_BR': 'Portuguese',
// // // //         'zh_CN': 'Chinese',
// // // //         'ja_JP': 'Japanese',
// // // //         'ko_KR': 'Korean',
// // // //         'ru_RU': 'Russian',
// // // //         'ar_SA': 'Arabic',
// // // //       };

// // // //       final targetLanguage = languageMap[languageCode] ?? 'English';

// // // //       final prompt =
// // // //           '''
// // // // Translate this text to $targetLanguage. Return ONLY the translation, no explanations:
// // // // Text: "$text"
// // // // Keep the same tone and meaning. Make it natural and conversational.
// // // // ''';

// // // //       final response = await _callGeminiAPI(prompt);
// // // //       return response?.trim() ?? text;
// // // //     } catch (e) {
// // // //       print("Translation to $languageCode failed: $e");
// // // //       return text;
// // // //     }
// // // //   }

// // // //   static String _createEnhancedPrompt(String userCommand, String languageCode) {
// // // //     final targetLanguage = _getLanguageName(languageCode);

// // // //     return '''
// // // // You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

// // // // Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// // // // Guidelines:
// // // // - Respond in $targetLanguage language
// // // // - If asked about time, provide current time information
// // // // - If asked about weather, explain that weather information is being fetched separately
// // // // - If asked about music, explain that you're searching for the song on YouTube
// // // // - If asked math questions, solve them clearly
// // // // - If asked for jokes, tell a clean, family-friendly joke
// // // // - If asked what you can do, list your main capabilities
// // // // - For general questions, provide helpful information
// // // // - Keep responses under 100 words for voice output
// // // // - Be friendly and conversational

// // // // User's request: $userCommand
// // // // ''';
// // // //   }

// // // //   static String _getLanguageName(String code) {
// // // //     final languages = {
// // // //       'en_US': 'English',
// // // //       'en_GB': 'English',
// // // //       'hi_IN': 'Hindi',
// // // //       'ta_IN': 'Tamil',
// // // //       'te_IN': 'Telugu',
// // // //       'bn_IN': 'Bengali',
// // // //       'mr_IN': 'Marathi',
// // // //       'gu_IN': 'Gujarati',
// // // //       'kn_IN': 'Kannada',
// // // //       'ml_IN': 'Malayalam',
// // // //       'pa_IN': 'Punjabi',
// // // //       'es_ES': 'Spanish',
// // // //       'fr_FR': 'French',
// // // //       'de_DE': 'German',
// // // //       'it_IT': 'Italian',
// // // //       'pt_BR': 'Portuguese',
// // // //       'zh_CN': 'Chinese',
// // // //       'ja_JP': 'Japanese',
// // // //       'ko_KR': 'Korean',
// // // //       'ru_RU': 'Russian',
// // // //       'ar_SA': 'Arabic',
// // // //     };
// // // //     return languages[code] ?? 'English';
// // // //   }

// // // //   static Future<String?> _callGeminiAPI(String prompt) async {
// // // //     try {
// // // //       if (!_isInitialized) {
// // // //         print("Gemini not initialized");
// // // //         return null;
// // // //       }

// // // //       print("Sending request to Flutter Gemini...");
// // // //       final gemini = Gemini.instance;

// // // //       final response = await gemini
// // // //           .prompt(parts: [Part.text(prompt)])
// // // //           .timeout(timeoutDuration);

// // // //       print("Flutter Gemini API Response received");

// // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // //         final outputText = response.output!;
// // // //         print(
// // // //           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
// // // //         );
// // // //         return outputText;
// // // //       } else {
// // // //         print("Empty response output");
// // // //         return null;
// // // //       }
// // // //     } on TimeoutException {
// // // //       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
// // // //       rethrow;
// // // //     } catch (e) {
// // // //       print("Unexpected error in API call: $e");
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static String _analyzeResponseType(String command, String response) {
// // // //     final lowerCommand = command.toLowerCase();

// // // //     if (_isTimeRequest(command)) {
// // // //       return 'time';
// // // //     } else if (_isWeatherRequest(command)) {
// // // //       return 'weather';
// // // //     } else if (_isMusicRequest(command)) {
// // // //       return 'music';
// // // //     } else if (_isJokeRequest(command)) {
// // // //       return 'joke';
// // // //     } else if (lowerCommand.contains('calculate') ||
// // // //         lowerCommand.contains('math') ||
// // // //         lowerCommand.contains('+') ||
// // // //         lowerCommand.contains('-') ||
// // // //         lowerCommand.contains('*') ||
// // // //         lowerCommand.contains('/')) {
// // // //       return 'calculation';
// // // //     } else if (lowerCommand.contains('help') ||
// // // //         lowerCommand.contains('what can you do')) {
// // // //       return 'help';
// // // //     } else {
// // // //       return 'general';
// // // //     }
// // // //   }

// // // //   static Future<Map<String, dynamic>> updateAssistantName(
// // // //     String newName,
// // // //   ) async {
// // // //     return {
// // // //       'status': 'success',
// // // //       'message': 'Assistant name updated to $newName',
// // // //     };
// // // //   }

// // // //   static Future<Map<String, dynamic>> testConnection() async {
// // // //     try {
// // // //       print("Testing connection to Flutter Gemini API...");

// // // //       if (!_isInitialized) {
// // // //         return {
// // // //           'status': 'error',
// // // //           'message': 'Gemini not initialized. Please check your API key.',
// // // //         };
// // // //       }

// // // //       final gemini = Gemini.instance;
// // // //       final response = await gemini
// // // //           .prompt(
// // // //             parts: [
// // // //               Part.text(
// // // //                 "Hello, respond with just 'Hello' to test the connection",
// // // //               ),
// // // //             ],
// // // //           )
// // // //           .timeout(Duration(seconds: 10));

// // // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // // //         return {
// // // //           'status': 'success',
// // // //           'message':
// // // //               'Flutter Gemini API is working perfectly! Response: ${response.output}',
// // // //         };
// // // //       } else {
// // // //         return {
// // // //           'status': 'error',
// // // //           'message': 'API responded but with empty content',
// // // //         };
// // // //       }
// // // //     } on TimeoutException {
// // // //       return {
// // // //         'status': 'timeout',
// // // //         'message': 'Connection test timed out. Check your internet connection.',
// // // //       };
// // // //     } catch (e) {
// // // //       return {
// // // //         'status': 'error',
// // // //         'message': 'Connection test failed: ${e.toString()}',
// // // //       };
// // // //     }
// // // //   }

// // // //   static String getCurrentTime() {
// // // //     final now = DateTime.now();
// // // //     final hour = now.hour;
// // // //     final minute = now.minute.toString().padLeft(2, '0');
// // // //     final period = hour >= 12 ? 'PM' : 'AM';
// // // //     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

// // // //     return "The current time is $displayHour:$minute $period";
// // // //   }

// // // //   static Map<String, dynamic> getOfflineResponse(String command) {
// // // //     final lowerCommand = command.toLowerCase();

// // // //     if (_isTimeRequest(command)) {
// // // //       return {'status': 'success', 'message': getCurrentTime(), 'type': 'time'};
// // // //     } else if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// // // //         'type': 'greeting',
// // // //       };
// // // //     } else if (_isJokeRequest(command)) {
// // // //       final joke = JokeService.getRandomFallbackJoke();
// // // //       return {
// // // //         'status': 'success',
// // // //         'message': joke,
// // // //         'type': 'joke',
// // // //         'offline': true,
// // // //       };
// // // //     } else if (_isWeatherRequest(command)) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can\'t check the weather in offline mode, but you can check your local weather app!',
// // // //         'type': 'weather',
// // // //       };
// // // //     } else if (_isMusicRequest(command)) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can\'t search for music in offline mode, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
// // // //         'type': 'music',
// // // //       };
// // // //     } else if (lowerCommand.contains('calculate') ||
// // // //         lowerCommand.contains('math')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
// // // //         'type': 'calculation',
// // // //       };
// // // //     } else if (lowerCommand.contains('help') ||
// // // //         lowerCommand.contains('what can you do')) {
// // // //       return {
// // // //         'status': 'success',
// // // //         'message':
// // // //             'I can tell you the time, check weather, play music from YouTube, tell dynamic jokes, help with basic questions, and chat with you! For advanced features, try switching to online mode.',
// // // //         'type': 'help',
// // // //       };
// // // //     } else {
// // // //       final responses = [
// // // //         'I\'m currently in offline mode, but I can still help with basic tasks!',
// // // //         'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
// // // //         'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
// // // //         'Thanks for talking with me! I can do more when connected to the internet.',
// // // //       ];
// // // //       final randomResponse =
// // // //           responses[DateTime.now().millisecond % responses.length];
// // // //       return {
// // // //         'status': 'success',
// // // //         'message': randomResponse,
// // // //         'type': 'offline',
// // // //       };
// // // //     }
// // // //   }

// // // //   // Add these methods for joke management
// // // //   static Map<String, dynamic> getJokeStatistics() {
// // // //     return JokeService.getJokeStats();
// // // //   }

// // // //   static void clearJokeMemory() {
// // // //     JokeService.clearJokeMemory();
// // // //   }
// // // // }

// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'package:flutter_gemini/flutter_gemini.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:url_launcher/url_launcher.dart';
// // // import 'joke_service.dart';

// // // class GeminiService {
// // //   static const String apiKey = 'AIzaSyD9jv-vqO495MGI01Q8mhgbUhGkR5Qk0mM';
// // //   static const Duration timeoutDuration = Duration(seconds: 15);
// // //   static bool _isInitialized = false;

// // //   /// Initialize the Gemini service
// // //   static void init() {
// // //     if (apiKey != 'gh') {
// // //       try {
// // //         Gemini.init(apiKey: apiKey);
// // //         _isInitialized = true;
// // //         print("✅ Flutter Gemini initialized successfully");
// // //       } catch (e) {
// // //         print("❌ Failed to initialize Gemini: $e");
// // //         _isInitialized = false;
// // //       }
// // //     } else {
// // //       print("⚠️ Gemini API key not set, using offline mode");
// // //       _isInitialized = false;
// // //     }
// // //   }

// // //   /// Check if Gemini is properly initialized
// // //   static bool get isInitialized => _isInitialized;

// // //   /// Process any voice command using Gemini API with language support
// // //   static Future<Map<String, dynamic>> processCommand(
// // //     String command,
// // //     String languageCode,
// // //   ) async {
// // //     try {
// // //       print(
// // //         "Processing command with Flutter Gemini: $command in language: $languageCode",
// // //       );

// // //       // Handle time requests locally (faster and more accurate)
// // //       if (_isTimeRequest(command)) {
// // //         final timeResponse = getCurrentTime();
// // //         return {
// // //           'status': 'success',
// // //           'message': await _translateToLanguage(timeResponse, languageCode),
// // //           'type': 'time',
// // //           'originalCommand': command,
// // //         };
// // //       }

// // //       // Handle weather requests with API integration
// // //       if (_isWeatherRequest(command)) {
// // //         return await _handleWeatherRequest(command, languageCode);
// // //       }

// // //       // Handle music requests with YouTube search
// // //       if (_isMusicRequest(command)) {
// // //         return await _handleMusicRequest(command, languageCode);
// // //       }

// // //       // Handle joke requests with enhanced dynamic generation
// // //       if (_isJokeRequest(command)) {
// // //         return await _handleJokeRequest(command, languageCode, _isInitialized);
// // //       }

// // //       if (!_isInitialized) {
// // //         print("⚠️ Gemini not initialized, using offline mode");
// // //         final offlineResponse = getOfflineResponse(command);
// // //         offlineResponse['message'] = await _translateToLanguage(
// // //           offlineResponse['message'],
// // //           languageCode,
// // //         );
// // //         return offlineResponse;
// // //       }

// // //       // Translate non-English commands to English for Gemini
// // //       String processedCommand = command;
// // //       if (!_isEnglish(languageCode)) {
// // //         processedCommand = await _translateToEnglish(command, languageCode);
// // //       }

// // //       final String enhancedPrompt = _createEnhancedPrompt(
// // //         processedCommand,
// // //         languageCode,
// // //       );
// // //       final response = await _callGeminiAPI(enhancedPrompt);

// // //       if (response != null && response.isNotEmpty) {
// // //         final responseType = _analyzeResponseType(processedCommand, response);

// // //         // Translate response back to target language if needed
// // //         String finalResponse = response;
// // //         if (!_isEnglish(languageCode)) {
// // //           finalResponse = await _translateToLanguage(response, languageCode);
// // //         }

// // //         return {
// // //           'status': 'success',
// // //           'message': finalResponse,
// // //           'type': responseType,
// // //           'originalCommand': command,
// // //         };
// // //       } else {
// // //         print("Empty response from Gemini API, falling back to offline");
// // //         final offlineResponse = getOfflineResponse(command);
// // //         offlineResponse['message'] = await _translateToLanguage(
// // //           offlineResponse['message'],
// // //           languageCode,
// // //         );
// // //         return offlineResponse;
// // //       }
// // //     } on TimeoutException catch (e) {
// // //       print("Gemini API timeout: $e");
// // //       return {
// // //         'status': 'timeout',
// // //         'message': await _translateToLanguage(
// // //           'Request timed out. Using offline response.',
// // //           languageCode,
// // //         ),
// // //         'type': 'offline',
// // //         'fallback': getOfflineResponse(command),
// // //       };
// // //     } catch (e) {
// // //       print("Error in Gemini API call: $e");
// // //       final offlineResponse = getOfflineResponse(command);
// // //       offlineResponse['message'] = await _translateToLanguage(
// // //         offlineResponse['message'],
// // //         languageCode,
// // //       );
// // //       return {
// // //         'status': 'error',
// // //         'message': await _translateToLanguage(
// // //           'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
// // //           languageCode,
// // //         ),
// // //         'type': 'offline',
// // //         'fallback': offlineResponse,
// // //       };
// // //     }
// // //   }

// // //   /// Enhanced joke handling with external API
// // //   static Future<Map<String, dynamic>> _handleJokeRequest(
// // //     String command,
// // //     String languageCode,
// // //     bool isOnlineMode,
// // //   ) async {
// // //     try {
// // //       print("😄 Processing joke request: $command");

// // //       // Determine specific joke category if mentioned
// // //       final category = JokeService.getSpecificJokeCategory(command);

// // //       // Generate joke using the external API service
// // //       final joke = await JokeService.generateJoke(languageCode, isOnlineMode);

// // //       // If it's not English, translate the joke
// // //       String finalJoke = joke;
// // //       if (!_isEnglish(languageCode) && isOnlineMode && _isInitialized) {
// // //         try {
// // //           finalJoke = await _translateToLanguage(joke, languageCode);
// // //         } catch (e) {
// // //           print("Translation failed, using original joke: $e");
// // //           finalJoke = joke; // Use original if translation fails
// // //         }
// // //       }

// // //       return {
// // //         'status': 'success',
// // //         'message': finalJoke,
// // //         'type': 'joke',
// // //         'originalCommand': command,
// // //         'category': category,
// // //         'source': isOnlineMode ? 'external_api' : 'fallback',
// // //       };
// // //     } catch (e) {
// // //       print("Joke request error: $e");
// // //       // Fallback to offline joke
// // //       final fallbackJoke = JokeService.getRandomFallbackJoke();
// // //       return {
// // //         'status': 'success',
// // //         'message': fallbackJoke,
// // //         'type': 'joke',
// // //         'originalCommand': command,
// // //         'fallback': true,
// // //         'source': 'fallback',
// // //       };
// // //     }
// // //   }

// // //   /// Handle music requests with YouTube search and direct opening
// // //   static Future<Map<String, dynamic>> _handleMusicRequest(
// // //     String command,
// // //     String languageCode,
// // //   ) async {
// // //     try {
// // //       print("🎵 Processing music request: $command");

// // //       // Extract song/artist name from command
// // //       String searchQuery = _extractMusicQuery(command);

// // //       if (searchQuery.isEmpty) {
// // //         // If no specific song mentioned, ask Gemini for popular songs
// // //         searchQuery = await _getPopularSongSuggestion(command);
// // //       }

// // //       // Search YouTube and get the first result
// // //       final youtubeUrl = await _searchYouTubeMusic(searchQuery);

// // //       if (youtubeUrl != null) {
// // //         // Open YouTube URL
// // //         await _openYouTubeUrl(youtubeUrl);

// // //         final successMessage = searchQuery.isNotEmpty
// // //             ? "Opening '$searchQuery' on YouTube Music!"
// // //             : "Opening music on YouTube!";

// // //         return {
// // //           'status': 'success',
// // //           'message': await _translateToLanguage(successMessage, languageCode),
// // //           'type': 'music',
// // //           'originalCommand': command,
// // //           'youtubeUrl': youtubeUrl,
// // //           'searchQuery': searchQuery,
// // //         };
// // //       } else {
// // //         return {
// // //           'status': 'error',
// // //           'message': await _translateToLanguage(
// // //             "Sorry, I couldn't find that song on YouTube. Try being more specific with the song name or artist.",
// // //             languageCode,
// // //           ),
// // //           'type': 'music',
// // //           'originalCommand': command,
// // //         };
// // //       }
// // //     } catch (e) {
// // //       print("Music request error: $e");
// // //       return {
// // //         'status': 'error',
// // //         'message': await _translateToLanguage(
// // //           'Sorry, I cannot play music right now. Please try again later.',
// // //           languageCode,
// // //         ),
// // //         'type': 'music',
// // //         'originalCommand': command,
// // //       };
// // //     }
// // //   }

// // //   /// Extract music query from voice command
// // //   static String _extractMusicQuery(String command) {
// // //     final lowerCommand = command.toLowerCase();

// // //     // Remove common music command words
// // //     String query = lowerCommand
// // //         .replaceAll('play', '')
// // //         .replaceAll('song', '')
// // //         .replaceAll('music', '')
// // //         .replaceAll('track', '')
// // //         .replaceAll('by', '')
// // //         .replaceAll('from', '')
// // //         .replaceAll('the', '')
// // //         .replaceAll('a', '')
// // //         .trim();

// // //     // Handle patterns like "play [song] by [artist]"
// // //     if (query.contains(' by ')) {
// // //       final parts = query.split(' by ');
// // //       if (parts.length >= 2) {
// // //         return "${parts[0].trim()} ${parts[1].trim()}";
// // //       }
// // //     }

// // //     return query;
// // //   }

// // //   /// Get popular song suggestion using Gemini when no specific song is mentioned
// // //   static Future<String> _getPopularSongSuggestion(String command) async {
// // //     try {
// // //       if (!_isInitialized) return "popular music";

// // //       final prompt =
// // //           '''
// // // The user wants to listen to music but didn't specify a song. Command: "$command"
// // // Suggest ONE popular song name with artist that would be good to play.
// // // Return ONLY the song name and artist in this format: "Song Name Artist Name"
// // // Example: "Shape of You Ed Sheeran"
// // // Make it a currently popular or classic hit song.
// // // ''';

// // //       final response = await _callGeminiAPI(prompt);
// // //       return response?.trim() ?? "popular music";
// // //     } catch (e) {
// // //       print("Error getting song suggestion: $e");
// // //       return "popular music";
// // //     }
// // //   }

// // //   /// Search YouTube for music and return the first video URL
// // //   static Future<String?> _searchYouTubeMusic(String query) async {
// // //     try {
// // //       // Create YouTube search URL
// // //       final encodedQuery = Uri.encodeComponent("$query music video");
// // //       final searchUrl =
// // //           "https://www.youtube.com/results?search_query=$encodedQuery";

// // //       print("🔍 Searching YouTube for: $query");

// // //       // Make HTTP request to YouTube search
// // //       final response = await http
// // //           .get(
// // //             Uri.parse(searchUrl),
// // //             headers: {
// // //               'User-Agent':
// // //                   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
// // //             },
// // //           )
// // //           .timeout(Duration(seconds: 10));

// // //       if (response.statusCode == 200) {
// // //         final body = response.body;

// // //         // Extract video ID from YouTube search results
// // //         final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
// // //         final match = videoIdRegex.firstMatch(body);

// // //         if (match != null) {
// // //           final videoId = match.group(1);
// // //           final youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
// // //           print("✅ Found YouTube URL: $youtubeUrl");
// // //           return youtubeUrl;
// // //         }
// // //       }

// // //       // Fallback: create a direct search URL that YouTube will handle
// // //       final fallbackUrl =
// // //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // //       print("⚠️ Using fallback search URL: $fallbackUrl");
// // //       return fallbackUrl;
// // //     } catch (e) {
// // //       print("YouTube search error: $e");
// // //       // Return YouTube search URL as fallback
// // //       final fallbackUrl =
// // //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// // //       return fallbackUrl;
// // //     }
// // //   }

// // //   /// Open YouTube URL in the app or browser
// // //   static Future<void> _openYouTubeUrl(String url) async {
// // //     try {
// // //       final Uri uri = Uri.parse(url);

// // //       // Try to open in YouTube app first, then fallback to browser
// // //       final youtubeAppUrl = url.replaceFirst(
// // //         'https://www.youtube.com',
// // //         'youtube://',
// // //       );
// // //       final youtubeAppUri = Uri.parse(youtubeAppUrl);

// // //       bool opened = false;

// // //       // Try YouTube app first
// // //       try {
// // //         if (await canLaunchUrl(youtubeAppUri)) {
// // //           await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
// // //           opened = true;
// // //           print("✅ Opened in YouTube app");
// // //         }
// // //       } catch (e) {
// // //         print("YouTube app not available: $e");
// // //       }

// // //       // Fallback to browser if YouTube app failed
// // //       if (!opened) {
// // //         if (await canLaunchUrl(uri)) {
// // //           await launchUrl(uri, mode: LaunchMode.externalApplication);
// // //           print("✅ Opened in browser");
// // //         } else {
// // //           throw Exception("Cannot open YouTube URL");
// // //         }
// // //       }
// // //     } catch (e) {
// // //       print("Error opening YouTube URL: $e");
// // //       throw e;
// // //     }
// // //   }

// // //   /// Handle weather requests with location services
// // //   static Future<Map<String, dynamic>> _handleWeatherRequest(
// // //     String command,
// // //     String languageCode,
// // //   ) async {
// // //     try {
// // //       double? lat, lon;
// // //       String location = "your location";

// // //       // Check if specific city is mentioned
// // //       String cityName = _extractCityFromCommand(command);

// // //       if (cityName.isNotEmpty) {
// // //         // Get coordinates for specific city using Gemini
// // //         final cityCoords = await _getCityCoordinates(cityName);
// // //         if (cityCoords != null) {
// // //           lat = cityCoords['lat'];
// // //           lon = cityCoords['lon'];
// // //           location = cityName;
// // //         }
// // //       } else {
// // //         // Use current location
// // //         final position = await _getCurrentPosition();
// // //         if (position != null) {
// // //           lat = position.latitude;
// // //           lon = position.longitude;
// // //         }
// // //       }

// // //       if (lat == null || lon == null) {
// // //         // Fallback to default location (Jaipur)
// // //         lat = 26.85;
// // //         lon = 75.78;
// // //         location = "Jaipur";
// // //       }

// // //       final weatherData = await _fetchWeatherData(lat, lon);
// // //       final weatherMessage = _formatWeatherMessage(weatherData, location);

// // //       return {
// // //         'status': 'success',
// // //         'message': await _translateToLanguage(weatherMessage, languageCode),
// // //         'type': 'weather',
// // //         'originalCommand': command,
// // //       };
// // //     } catch (e) {
// // //       print("Weather request error: $e");
// // //       return {
// // //         'status': 'error',
// // //         'message': await _translateToLanguage(
// // //           'Sorry, I cannot get weather information right now.',
// // //           languageCode,
// // //         ),
// // //         'type': 'weather',
// // //         'originalCommand': command,
// // //       };
// // //     }
// // //   }

// // //   /// Get city coordinates using Gemini AI
// // //   static Future<Map<String, double>?> _getCityCoordinates(
// // //     String cityName,
// // //   ) async {
// // //     try {
// // //       if (!_isInitialized) return null;

// // //       final prompt =
// // //           '''
// // // Please provide the latitude and longitude coordinates for the city: $cityName
// // // Return ONLY in this exact format: "lat:XX.XXXX,lon:XX.XXXX"
// // // Example: "lat:26.9124,lon:75.7873"
// // // ''';

// // //       final response = await _callGeminiAPI(prompt);
// // //       if (response != null) {
// // //         final regex = RegExp(r'lat:([-\d.]+),lon:([-\d.]+)');
// // //         final match = regex.firstMatch(response);
// // //         if (match != null) {
// // //           return {
// // //             'lat': double.parse(match.group(1)!),
// // //             'lon': double.parse(match.group(2)!),
// // //           };
// // //         }
// // //       }
// // //     } catch (e) {
// // //       print("Error getting city coordinates: $e");
// // //     }
// // //     return null;
// // //   }

// // //   /// Extract city name from weather command
// // //   static String _extractCityFromCommand(String command) {
// // //     final lowerCommand = command.toLowerCase();

// // //     // Common patterns for city mentions
// // //     final patterns = [
// // //       RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
// // //       RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
// // //       RegExp(r'([a-zA-Z\s]+) weather'),
// // //     ];

// // //     for (final pattern in patterns) {
// // //       final match = pattern.firstMatch(lowerCommand);
// // //       if (match != null) {
// // //         return match.group(1)!.trim();
// // //       }
// // //     }

// // //     return "";
// // //   }

// // //   /// Get current position with proper error handling
// // //   static Future<Position?> _getCurrentPosition() async {
// // //     try {
// // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //       if (!serviceEnabled) {
// // //         print("Location services are disabled");
// // //         return null;
// // //       }

// // //       LocationPermission permission = await Geolocator.checkPermission();
// // //       if (permission == LocationPermission.denied) {
// // //         permission = await Geolocator.requestPermission();
// // //         if (permission == LocationPermission.denied) {
// // //           print("Location permissions are denied");
// // //           return null;
// // //         }
// // //       }

// // //       if (permission == LocationPermission.deniedForever) {
// // //         print("Location permissions are permanently denied");
// // //         return null;
// // //       }

// // //       return await Geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.low,
// // //         timeLimit: Duration(seconds: 10),
// // //       );
// // //     } catch (e) {
// // //       print("Error getting current position: $e");
// // //       return null;
// // //     }
// // //   }

// // //   /// Fetch weather data from Open-Meteo API
// // //   static Future<Map<String, dynamic>?> _fetchWeatherData(
// // //     double lat,
// // //     double lon,
// // //   ) async {
// // //     try {
// // //       final url =
// // //           'https://api.open-meteo.com/v1/forecast?'
// // //           'latitude=$lat&longitude=$lon&'
// // //           'current_weather=true&'
// // //           'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
// // //           'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
// // //           'timezone=auto';

// // //       final response = await http
// // //           .get(Uri.parse(url))
// // //           .timeout(Duration(seconds: 10));

// // //       if (response.statusCode == 200) {
// // //         return json.decode(response.body);
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching weather data: $e");
// // //     }
// // //     return null;
// // //   }

// // //   /// Format weather message in a user-friendly way
// // //   static String _formatWeatherMessage(
// // //     Map<String, dynamic>? weatherData,
// // //     String location,
// // //   ) {
// // //     if (weatherData == null || weatherData['current_weather'] == null) {
// // //       return "Sorry, I couldn't get weather information for $location right now.";
// // //     }

// // //     final current = weatherData['current_weather'];
// // //     final temp = current['temperature']?.round() ?? 0;
// // //     final windSpeed = current['windspeed']?.round() ?? 0;
// // //     final weatherCode = current['weathercode'] ?? 0;

// // //     String condition = _getWeatherCondition(weatherCode);

// // //     String message =
// // //         "The weather in $location is currently $condition with a temperature of ${temp}°C";

// // //     if (windSpeed > 0) {
// // //       message += " and wind speed of ${windSpeed} km/h";
// // //     }

// // //     // Add daily forecast if available
// // //     if (weatherData['daily'] != null) {
// // //       final daily = weatherData['daily'];
// // //       final maxTemp = daily['temperature_2m_max']?[0]?.round();
// // //       final minTemp = daily['temperature_2m_min']?[0]?.round();

// // //       if (maxTemp != null && minTemp != null) {
// // //         message += ". Today's high will be ${maxTemp}°C and low ${minTemp}°C";
// // //       }
// // //     }

// // //     return message + ".";
// // //   }

// // //   /// Convert weather code to readable condition
// // //   static String _getWeatherCondition(int code) {
// // //     switch (code) {
// // //       case 0:
// // //         return "clear sky";
// // //       case 1:
// // //       case 2:
// // //       case 3:
// // //         return "partly cloudy";
// // //       case 45:
// // //       case 48:
// // //         return "foggy";
// // //       case 51:
// // //       case 53:
// // //       case 55:
// // //         return "drizzly";
// // //       case 61:
// // //       case 63:
// // //       case 65:
// // //         return "rainy";
// // //       case 71:
// // //       case 73:
// // //       case 75:
// // //         return "snowy";
// // //       case 95:
// // //       case 96:
// // //       case 99:
// // //         return "thunderstorms";
// // //       default:
// // //         return "variable conditions";
// // //     }
// // //   }

// // //   // All the checking methods
// // //   static bool _isTimeRequest(String command) {
// // //     final lowerCommand = command.toLowerCase();
// // //     return lowerCommand.contains('time') ||
// // //         lowerCommand.contains('clock') ||
// // //         lowerCommand.contains('समय') ||
// // //         lowerCommand.contains('時間') ||
// // //         lowerCommand.contains('temps') ||
// // //         lowerCommand.contains('hora');
// // //   }

// // //   static bool _isWeatherRequest(String command) {
// // //     final lowerCommand = command.toLowerCase();
// // //     return lowerCommand.contains('weather') ||
// // //         lowerCommand.contains('temperature') ||
// // //         lowerCommand.contains('मौसम') ||
// // //         lowerCommand.contains('天気') ||
// // //         lowerCommand.contains('temps') ||
// // //         lowerCommand.contains('clima');
// // //   }

// // //   static bool _isMusicRequest(String command) {
// // //     final lowerCommand = command.toLowerCase();
// // //     return lowerCommand.contains('play') ||
// // //         lowerCommand.contains('music') ||
// // //         lowerCommand.contains('song') ||
// // //         lowerCommand.contains('track') ||
// // //         lowerCommand.contains('गाना') ||
// // //         lowerCommand.contains('संगीत') ||
// // //         lowerCommand.contains('音楽') ||
// // //         lowerCommand.contains('música') ||
// // //         lowerCommand.contains('musique');
// // //   }

// // //   static bool _isJokeRequest(String command) {
// // //     final lowerCommand = command.toLowerCase();
// // //     return lowerCommand.contains('joke') ||
// // //         lowerCommand.contains('funny') ||
// // //         lowerCommand.contains('humor') ||
// // //         lowerCommand.contains('laugh') ||
// // //         lowerCommand.contains('comedy') ||
// // //         lowerCommand.contains('हंसी') ||
// // //         lowerCommand.contains('मजाक') ||
// // //         lowerCommand.contains('笑话') ||
// // //         lowerCommand.contains('冗談') ||
// // //         lowerCommand.contains('broma') ||
// // //         lowerCommand.contains('blague');
// // //   }

// // //   static bool _isEnglish(String languageCode) {
// // //     return languageCode.startsWith('en');
// // //   }

// // //   // Translation methods
// // //   static Future<String> _translateToEnglish(
// // //     String text,
// // //     String fromLanguage,
// // //   ) async {
// // //     try {
// // //       if (!_isInitialized) return text;

// // //       final prompt =
// // //           '''
// // // Translate this text to English. Return ONLY the translation, no explanations:
// // // Text: "$text"
// // // From language: $fromLanguage
// // // ''';

// // //       final response = await _callGeminiAPI(prompt);
// // //       return response?.trim() ?? text;
// // //     } catch (e) {
// // //       print("Translation to English failed: $e");
// // //       return text;
// // //     }
// // //   }

// // //   static Future<String> _translateToLanguage(
// // //     String text,
// // //     String languageCode,
// // //   ) async {
// // //     if (_isEnglish(languageCode)) return text;

// // //     try {
// // //       if (!_isInitialized) return text;

// // //       final languageMap = {
// // //         'hi_IN': 'Hindi',
// // //         'ta_IN': 'Tamil',
// // //         'te_IN': 'Telugu',
// // //         'bn_IN': 'Bengali',
// // //         'mr_IN': 'Marathi',
// // //         'gu_IN': 'Gujarati',
// // //         'kn_IN': 'Kannada',
// // //         'ml_IN': 'Malayalam',
// // //         'pa_IN': 'Punjabi',
// // //         'es_ES': 'Spanish',
// // //         'fr_FR': 'French',
// // //         'de_DE': 'German',
// // //         'it_IT': 'Italian',
// // //         'pt_BR': 'Portuguese',
// // //         'zh_CN': 'Chinese',
// // //         'ja_JP': 'Japanese',
// // //         'ko_KR': 'Korean',
// // //         'ru_RU': 'Russian',
// // //         'ar_SA': 'Arabic',
// // //       };

// // //       final targetLanguage = languageMap[languageCode] ?? 'English';

// // //       final prompt =
// // //           '''
// // // Translate this text to $targetLanguage. Return ONLY the translation, no explanations:
// // // Text: "$text"
// // // Keep the same tone and meaning. Make it natural and conversational.
// // // ''';

// // //       final response = await _callGeminiAPI(prompt);
// // //       return response?.trim() ?? text;
// // //     } catch (e) {
// // //       print("Translation to $languageCode failed: $e");
// // //       return text;
// // //     }
// // //   }

// // //   static String _createEnhancedPrompt(String userCommand, String languageCode) {
// // //     final targetLanguage = _getLanguageName(languageCode);

// // //     return '''
// // // You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

// // // Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// // // Guidelines:
// // // - Respond in $targetLanguage language
// // // - If asked about time, provide current time information
// // // - If asked about weather, explain that weather information is being fetched separately
// // // - If asked about music, explain that you're searching for the song on YouTube
// // // - If asked math questions, solve them clearly
// // // - If asked for jokes, tell a clean, family-friendly joke
// // // - If asked what you can do, list your main capabilities
// // // - For general questions, provide helpful information
// // // - Keep responses under 100 words for voice output
// // // - Be friendly and conversational

// // // User's request: $userCommand
// // // ''';
// // //   }

// // //   static String _getLanguageName(String code) {
// // //     final languages = {
// // //       'en_US': 'English',
// // //       'en_GB': 'English',
// // //       'hi_IN': 'Hindi',
// // //       'ta_IN': 'Tamil',
// // //       'te_IN': 'Telugu',
// // //       'bn_IN': 'Bengali',
// // //       'mr_IN': 'Marathi',
// // //       'gu_IN': 'Gujarati',
// // //       'kn_IN': 'Kannada',
// // //       'ml_IN': 'Malayalam',
// // //       'pa_IN': 'Punjabi',
// // //       'es_ES': 'Spanish',
// // //       'fr_FR': 'French',
// // //       'de_DE': 'German',
// // //       'it_IT': 'Italian',
// // //       'pt_BR': 'Portuguese',
// // //       'zh_CN': 'Chinese',
// // //       'ja_JP': 'Japanese',
// // //       'ko_KR': 'Korean',
// // //       'ru_RU': 'Russian',
// // //       'ar_SA': 'Arabic',
// // //     };
// // //     return languages[code] ?? 'English';
// // //   }

// // //   static Future<String?> _callGeminiAPI(String prompt) async {
// // //     try {
// // //       if (!_isInitialized) {
// // //         print("Gemini not initialized");
// // //         return null;
// // //       }

// // //       print("Sending request to Flutter Gemini...");
// // //       final gemini = Gemini.instance;

// // //       final response = await gemini
// // //           .prompt(parts: [Part.text(prompt)])
// // //           .timeout(timeoutDuration);

// // //       print("Flutter Gemini API Response received");

// // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // //         final outputText = response.output!;
// // //         print(
// // //           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
// // //         );
// // //         return outputText;
// // //       } else {
// // //         print("Empty response output");
// // //         return null;
// // //       }
// // //     } on TimeoutException {
// // //       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
// // //       rethrow;
// // //     } catch (e) {
// // //       print("Unexpected error in API call: $e");
// // //       rethrow;
// // //     }
// // //   }

// // //   static String _analyzeResponseType(String command, String response) {
// // //     final lowerCommand = command.toLowerCase();

// // //     if (_isTimeRequest(command)) {
// // //       return 'time';
// // //     } else if (_isWeatherRequest(command)) {
// // //       return 'weather';
// // //     } else if (_isMusicRequest(command)) {
// // //       return 'music';
// // //     } else if (_isJokeRequest(command)) {
// // //       return 'joke';
// // //     } else if (lowerCommand.contains('calculate') ||
// // //         lowerCommand.contains('math') ||
// // //         lowerCommand.contains('+') ||
// // //         lowerCommand.contains('-') ||
// // //         lowerCommand.contains('*') ||
// // //         lowerCommand.contains('/')) {
// // //       return 'calculation';
// // //     } else if (lowerCommand.contains('help') ||
// // //         lowerCommand.contains('what can you do')) {
// // //       return 'help';
// // //     } else {
// // //       return 'general';
// // //     }
// // //   }

// // //   static Future<Map<String, dynamic>> updateAssistantName(
// // //     String newName,
// // //   ) async {
// // //     return {
// // //       'status': 'success',
// // //       'message': 'Assistant name updated to $newName',
// // //     };
// // //   }

// // //   static Future<Map<String, dynamic>> testConnection() async {
// // //     try {
// // //       print("Testing connection to Flutter Gemini API...");

// // //       if (!_isInitialized) {
// // //         return {
// // //           'status': 'error',
// // //           'message': 'Gemini not initialized. Please check your API key.',
// // //         };
// // //       }

// // //       final gemini = Gemini.instance;
// // //       final response = await gemini
// // //           .prompt(
// // //             parts: [
// // //               Part.text(
// // //                 "Hello, respond with just 'Hello' to test the connection",
// // //               ),
// // //             ],
// // //           )
// // //           .timeout(Duration(seconds: 10));

// // //       if (response?.output != null && response!.output!.isNotEmpty) {
// // //         return {
// // //           'status': 'success',
// // //           'message':
// // //               'Flutter Gemini API is working perfectly! Response: ${response.output}',
// // //         };
// // //       } else {
// // //         return {
// // //           'status': 'error',
// // //           'message': 'API responded but with empty content',
// // //         };
// // //       }
// // //     } on TimeoutException {
// // //       return {
// // //         'status': 'timeout',
// // //         'message': 'Connection test timed out. Check your internet connection.',
// // //       };
// // //     } catch (e) {
// // //       return {
// // //         'status': 'error',
// // //         'message': 'Connection test failed: ${e.toString()}',
// // //       };
// // //     }
// // //   }

// // //   static String getCurrentTime() {
// // //     final now = DateTime.now();
// // //     final hour = now.hour;
// // //     final minute = now.minute.toString().padLeft(2, '0');
// // //     final period = hour >= 12 ? 'PM' : 'AM';
// // //     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

// // //     return "The current time is $displayHour:$minute $period";
// // //   }

// // //   // KEEP ONLY THIS VERSION - Remove the duplicate one
// // //   static Map<String, dynamic> getOfflineResponse(String command) {
// // //     final lowerCommand = command.toLowerCase();

// // //     if (_isTimeRequest(command)) {
// // //       return {'status': 'success', 'message': getCurrentTime(), 'type': 'time'};
// // //     } else if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
// // //       return {
// // //         'status': 'success',
// // //         'message':
// // //             'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// // //         'type': 'greeting',
// // //       };
// // //     } else if (_isJokeRequest(command)) {
// // //       // Use external API even in offline mode will fall back to local jokes
// // //       final joke = JokeService.getRandomFallbackJoke();
// // //       return {
// // //         'status': 'success',
// // //         'message': joke,
// // //         'type': 'joke',
// // //         'offline': true,
// // //         'source': 'fallback',
// // //       };
// // //     } else if (_isWeatherRequest(command)) {
// // //       return {
// // //         'status': 'success',
// // //         'message':
// // //             'I can\'t check the weather in offline mode, but you can check your local weather app!',
// // //         'type': 'weather',
// // //       };
// // //     } else if (_isMusicRequest(command)) {
// // //       return {
// // //         'status': 'success',
// // //         'message':
// // //             'I can\'t search for music in offline mode, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
// // //         'type': 'music',
// // //       };
// // //     } else if (lowerCommand.contains('calculate') ||
// // //         lowerCommand.contains('math')) {
// // //       return {
// // //         'status': 'success',
// // //         'message':
// // //             'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
// // //         'type': 'calculation',
// // //       };
// // //     } else if (lowerCommand.contains('help') ||
// // //         lowerCommand.contains('what can you do')) {
// // //       return {
// // //         'status': 'success',
// // //         'message':
// // //             'I can tell you the time, check weather, play music from YouTube, tell fresh jokes from the internet, help with basic questions, and chat with you! For advanced features, try switching to online mode.',
// // //         'type': 'help',
// // //       };
// // //     } else {
// // //       final responses = [
// // //         'I\'m currently in offline mode, but I can still help with basic tasks!',
// // //         'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
// // //         'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
// // //         'Thanks for talking with me! I can do more when connected to the internet.',
// // //       ];
// // //       final randomResponse =
// // //           responses[DateTime.now().millisecond % responses.length];
// // //       return {
// // //         'status': 'success',
// // //         'message': randomResponse,
// // //         'type': 'offline',
// // //       };
// // //     }
// // //   }

// // //   // Add method to test joke API
// // //   static Future<Map<String, dynamic>> testJokeApi() async {
// // //     try {
// // //       final isWorking = await JokeService.testApiConnection();
// // //       if (isWorking) {
// // //         return {
// // //           'status': 'success',
// // //           'message': 'Joke API is working perfectly!',
// // //         };
// // //       } else {
// // //         return {
// // //           'status': 'error',
// // //           'message': 'Joke API is not responding, using fallback jokes.',
// // //         };
// // //       }
// // //     } catch (e) {
// // //       return {'status': 'error', 'message': 'Joke API test failed: $e'};
// // //     }
// // //   }

// // //   // Add these methods for joke management
// // //   static Map<String, dynamic> getJokeStatistics() {
// // //     return JokeService.getJokeStats();
// // //   }

// // //   static void clearJokeMemory() {
// // //     JokeService.clearJokeMemory();
// // //   }
// // // }
// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:flutter_gemini/flutter_gemini.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:geolocator/geolocator.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'joke_service.dart';

// // class GeminiService {
// //   static const String apiKey = 'AIzaSyD9jv-vqO495MGI01Q8mhgbUhGkR5Qk0mM';
// //   static const Duration timeoutDuration = Duration(seconds: 15);
// //   static bool _isInitialized = false;

// //   /// Initialize the Gemini service
// //   static void init() {
// //     if (apiKey != 'gh') {
// //       try {
// //         Gemini.init(apiKey: apiKey);
// //         _isInitialized = true;
// //         print("✅ Flutter Gemini initialized successfully");
// //       } catch (e) {
// //         print("❌ Failed to initialize Gemini: $e");
// //         _isInitialized = false;
// //       }
// //     } else {
// //       print("⚠️ Gemini API key not set, using offline mode");
// //       _isInitialized = false;
// //     }
// //   }

// //   /// Check if Gemini is properly initialized
// //   static bool get isInitialized => _isInitialized;

// //   /// Process any voice command - Gemini ONLY for general questions
// //   static Future<Map<String, dynamic>> processCommand(
// //     String command,
// //     String languageCode,
// //   ) async {
// //     try {
// //       print("Processing command: $command in language: $languageCode");

// //       // Handle time requests locally (NO GEMINI)
// //       if (_isTimeRequest(command)) {
// //         print("⏰ Processing TIME request locally");
// //         final timeResponse = getCurrentTime();
// //         return {
// //           'status': 'success',
// //           'message': timeResponse,
// //           'type': 'time',
// //           'originalCommand': command,
// //           'source': 'local',
// //         };
// //       }

// //       // Handle weather requests with API (NO GEMINI)
// //       if (_isWeatherRequest(command)) {
// //         print("🌤️ Processing WEATHER request with API");
// //         return await _handleWeatherRequest(command, languageCode);
// //       }

// //       // Handle music requests with YouTube (NO GEMINI)
// //       if (_isMusicRequest(command)) {
// //         print("🎵 Processing MUSIC request with YouTube API");
// //         return await _handleMusicRequest(command, languageCode);
// //       }

// //       // Handle joke requests with external API (NO GEMINI)
// //       if (_isJokeRequest(command)) {
// //         print("😄 Processing JOKE request with external API");
// //         return await _handleJokeRequest(command, languageCode);
// //       }

// //       // Handle math/calculation locally (NO GEMINI)
// //       if (_isMathRequest(command)) {
// //         print("🔢 Processing MATH request locally");
// //         return _handleMathRequest(command);
// //       }

// //       // Handle help requests locally (NO GEMINI)
// //       if (_isHelpRequest(command)) {
// //         print("❓ Processing HELP request locally");
// //         return _handleHelpRequest();
// //       }

// //       // Handle greetings locally (NO GEMINI)
// //       if (_isGreetingRequest(command)) {
// //         print("👋 Processing GREETING request locally");
// //         return _handleGreetingRequest();
// //       }

// //       // ONLY general questions go to Gemini
// //       print("💬 Processing GENERAL question with Gemini");
// //       return await _handleGeneralQuestionWithGemini(command);
// //     } catch (e) {
// //       print("Error in processCommand: $e");
// //       return {
// //         'status': 'error',
// //         'message': 'Sorry, I encountered an error processing your request.',
// //         'type': 'error',
// //         'originalCommand': command,
// //       };
// //     }
// //   }

// //   /// Handle ONLY general questions with Gemini (your original working code)
// //   static Future<Map<String, dynamic>> _handleGeneralQuestionWithGemini(
// //     String command,
// //   ) async {
// //     try {
// //       if (!_isInitialized) {
// //         print("⚠️ Gemini not initialized, using offline response");
// //         return {
// //           'status': 'success',
// //           'message':
// //               'I\'m currently in offline mode. I can help with time, weather, music, jokes, and basic math. For detailed answers, please check online sources.',
// //           'type': 'general',
// //           'source': 'offline',
// //         };
// //       }

// //       // Your original working prompt for general questions only
// //       final String enhancedPrompt =
// //           '''
// // You are JARVIS, a helpful voice assistant. The user said: "$command"

// // Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// // Guidelines:
// // - For general questions, provide helpful information
// // - Keep responses under 100 words for voice output
// // - Be friendly and conversational
// // - If you don't know something, suggest checking reliable sources

// // User's request: $command
// // ''';

// //       final response = await _callGeminiAPI(enhancedPrompt);

// //       if (response != null && response.isNotEmpty) {
// //         return {
// //           'status': 'success',
// //           'message': response,
// //           'type': 'general',
// //           'originalCommand': command,
// //           'source': 'gemini',
// //         };
// //       } else {
// //         throw Exception("Empty response from Gemini");
// //       }
// //     } catch (e) {
// //       print("Gemini API failed for general question: $e");
// //       return {
// //         'status': 'success',
// //         'message':
// //             'I\'m having trouble with detailed responses right now, but I can still help with time, weather, music, jokes, and math!',
// //         'type': 'general',
// //         'source': 'offline',
// //       };
// //     }
// //   }

// //   /// Handle time requests locally (NO GEMINI)
// //   static String getCurrentTime() {
// //     final now = DateTime.now();
// //     final hour = now.hour;
// //     final minute = now.minute.toString().padLeft(2, '0');
// //     final period = hour >= 12 ? 'PM' : 'AM';
// //     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

// //     return "The current time is $displayHour:$minute $period";
// //   }

// //   /// Handle joke requests with external API (NO GEMINI)
// //   static Future<Map<String, dynamic>> _handleJokeRequest(
// //     String command,
// //     String languageCode,
// //   ) async {
// //     try {
// //       final category = JokeService.getSpecificJokeCategory(command);
// //       final joke = await JokeService.generateJoke(
// //         languageCode,
// //         true,
// //       ); // Always try online first

// //       return {
// //         'status': 'success',
// //         'message': joke,
// //         'type': 'joke',
// //         'originalCommand': command,
// //         'category': category,
// //         'source': 'external_api',
// //       };
// //     } catch (e) {
// //       print("External joke API failed, using fallback: $e");
// //       final fallbackJoke = JokeService.getRandomFallbackJoke();
// //       return {
// //         'status': 'success',
// //         'message': fallbackJoke,
// //         'type': 'joke',
// //         'originalCommand': command,
// //         'source': 'fallback',
// //       };
// //     }
// //   }

// //   /// Handle music requests with YouTube (NO GEMINI)
// //   static Future<Map<String, dynamic>> _handleMusicRequest(
// //     String command,
// //     String languageCode,
// //   ) async {
// //     try {
// //       String searchQuery = _extractMusicQuery(command);

// //       if (searchQuery.isEmpty) {
// //         searchQuery = _getPopularSongFallback();
// //       }

// //       final youtubeUrl = await _searchYouTubeMusic(searchQuery);

// //       if (youtubeUrl != null) {
// //         await _openYouTubeUrl(youtubeUrl);

// //         final successMessage = "Opening '$searchQuery' on YouTube!";

// //         return {
// //           'status': 'success',
// //           'message': successMessage,
// //           'type': 'music',
// //           'originalCommand': command,
// //           'youtubeUrl': youtubeUrl,
// //           'searchQuery': searchQuery,
// //           'source': 'youtube_api',
// //         };
// //       } else {
// //         return {
// //           'status': 'error',
// //           'message': "Sorry, I couldn't find that song on YouTube.",
// //           'type': 'music',
// //           'originalCommand': command,
// //         };
// //       }
// //     } catch (e) {
// //       print("Music request error: $e");
// //       return {
// //         'status': 'error',
// //         'message': 'Sorry, I cannot play music right now.',
// //         'type': 'music',
// //         'originalCommand': command,
// //       };
// //     }
// //   }

// //   /// Handle weather requests with API (NO GEMINI)
// //   static Future<Map<String, dynamic>> _handleWeatherRequest(
// //     String command,
// //     String languageCode,
// //   ) async {
// //     try {
// //       double? lat, lon;
// //       String location = "your location";

// //       String cityName = _extractCityFromCommand(command);

// //       if (cityName.isNotEmpty) {
// //         final cityCoords = _getKnownCityCoordinates(cityName);
// //         if (cityCoords != null) {
// //           lat = cityCoords['lat'];
// //           lon = cityCoords['lon'];
// //           location = cityName;
// //         }
// //       } else {
// //         final position = await _getCurrentPosition();
// //         if (position != null) {
// //           lat = position.latitude;
// //           lon = position.longitude;
// //         }
// //       }

// //       if (lat == null || lon == null) {
// //         lat = 26.85;
// //         lon = 75.78;
// //         location = "Jaipur";
// //       }

// //       final weatherData = await _fetchWeatherData(lat, lon);
// //       final weatherMessage = _formatWeatherMessage(weatherData, location);

// //       return {
// //         'status': 'success',
// //         'message': weatherMessage,
// //         'type': 'weather',
// //         'originalCommand': command,
// //         'source': 'weather_api',
// //       };
// //     } catch (e) {
// //       print("Weather request error: $e");
// //       return {
// //         'status': 'error',
// //         'message': 'Sorry, I cannot get weather information right now.',
// //         'type': 'weather',
// //         'originalCommand': command,
// //       };
// //     }
// //   }

// //   /// Handle math requests locally (NO GEMINI)
// //   static Map<String, dynamic> _handleMathRequest(String command) {
// //     // Simple math parser for basic operations
// //     final lowerCommand = command.toLowerCase();

// //     try {
// //       // Extract numbers and operation
// //       final numberRegex = RegExp(r'\d+\.?\d*');
// //       final numbers = numberRegex
// //           .allMatches(command)
// //           .map((match) => double.parse(match.group(0)!))
// //           .toList();

// //       if (numbers.length >= 2) {
// //         double result = 0;
// //         String operation = '';

// //         if (lowerCommand.contains('plus') ||
// //             lowerCommand.contains('+') ||
// //             lowerCommand.contains('add')) {
// //           result = numbers[0] + numbers[1];
// //           operation = 'addition';
// //         } else if (lowerCommand.contains('minus') ||
// //             lowerCommand.contains('-') ||
// //             lowerCommand.contains('subtract')) {
// //           result = numbers[0] - numbers[1];
// //           operation = 'subtraction';
// //         } else if (lowerCommand.contains('times') ||
// //             lowerCommand.contains('*') ||
// //             lowerCommand.contains('multiply')) {
// //           result = numbers[0] * numbers[1];
// //           operation = 'multiplication';
// //         } else if (lowerCommand.contains('divided') ||
// //             lowerCommand.contains('/') ||
// //             lowerCommand.contains('divide')) {
// //           if (numbers[1] != 0) {
// //             result = numbers[0] / numbers[1];
// //             operation = 'division';
// //           } else {
// //             return {
// //               'status': 'error',
// //               'message': 'Cannot divide by zero!',
// //               'type': 'calculation',
// //               'source': 'local',
// //             };
// //           }
// //         }

// //         if (operation.isNotEmpty) {
// //           return {
// //             'status': 'success',
// //             'message':
// //                 'The result of $operation is ${result.toStringAsFixed(2)}',
// //             'type': 'calculation',
// //             'source': 'local',
// //           };
// //         }
// //       }
// //     } catch (e) {
// //       print("Math calculation error: $e");
// //     }

// //     return {
// //       'status': 'success',
// //       'message':
// //           'I can help with basic math! Try asking something like "what is 25 plus 17" or "calculate 50 times 2".',
// //       'type': 'calculation',
// //       'source': 'local',
// //     };
// //   }

// //   /// Handle help requests locally (NO GEMINI)
// //   static Map<String, dynamic> _handleHelpRequest() {
// //     return {
// //       'status': 'success',
// //       'message':
// //           'I can help you with: telling time, checking weather, playing music from YouTube, sharing fresh jokes from the internet, basic math calculations, and answering general questions. What would you like to try?',
// //       'type': 'help',
// //       'source': 'local',
// //     };
// //   }

// //   /// Handle greetings locally (NO GEMINI)
// //   static Map<String, dynamic> _handleGreetingRequest() {
// //     final greetings = [
// //       'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
// //       'Hi there! I\'m ready to assist you with time, weather, music, jokes, and more!',
// //       'Greetings! What can I do for you today?',
// //       'Hello! I\'m here to help with your questions and tasks.',
// //     ];

// //     final greeting = greetings[DateTime.now().millisecond % greetings.length];

// //     return {
// //       'status': 'success',
// //       'message': greeting,
// //       'type': 'greeting',
// //       'source': 'local',
// //     };
// //   }

// //   /// Get popular song fallback without using Gemini
// //   static String _getPopularSongFallback() {
// //     final popularSongs = [
// //       'Shape of You Ed Sheeran',
// //       'Blinding Lights The Weeknd',
// //       'Levitating Dua Lipa',
// //       'Watermelon Sugar Harry Styles',
// //       'Bad Habits Ed Sheeran',
// //       'Stay The Kid LAROI',
// //       'Heat Waves Glass Animals',
// //       'Good 4 U Olivia Rodrigo',
// //       'As It Was Harry Styles',
// //       'Anti-Hero Taylor Swift',
// //     ];

// //     return popularSongs[DateTime.now().millisecond % popularSongs.length];
// //   }

// //   /// Extract music query from voice command
// //   static String _extractMusicQuery(String command) {
// //     final lowerCommand = command.toLowerCase();

// //     String query = lowerCommand
// //         .replaceAll('play', '')
// //         .replaceAll('song', '')
// //         .replaceAll('music', '')
// //         .replaceAll('track', '')
// //         .replaceAll('by', '')
// //         .replaceAll('from', '')
// //         .replaceAll('the', '')
// //         .replaceAll('a', '')
// //         .trim();

// //     if (query.contains(' by ')) {
// //       final parts = query.split(' by ');
// //       if (parts.length >= 2) {
// //         return "${parts[0].trim()} ${parts[1].trim()}";
// //       }
// //     }

// //     return query;
// //   }

// //   /// Search YouTube for music and return the first video URL
// //   static Future<String?> _searchYouTubeMusic(String query) async {
// //     try {
// //       final encodedQuery = Uri.encodeComponent("$query music video");
// //       final searchUrl =
// //           "https://www.youtube.com/results?search_query=$encodedQuery";

// //       print("🔍 Searching YouTube for: $query");

// //       final response = await http
// //           .get(
// //             Uri.parse(searchUrl),
// //             headers: {
// //               'User-Agent':
// //                   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
// //             },
// //           )
// //           .timeout(Duration(seconds: 10));

// //       if (response.statusCode == 200) {
// //         final body = response.body;
// //         final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
// //         final match = videoIdRegex.firstMatch(body);

// //         if (match != null) {
// //           final videoId = match.group(1);
// //           final youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
// //           print("✅ Found YouTube URL: $youtubeUrl");
// //           return youtubeUrl;
// //         }
// //       }

// //       final fallbackUrl =
// //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// //       return fallbackUrl;
// //     } catch (e) {
// //       print("YouTube search error: $e");
// //       final fallbackUrl =
// //           "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
// //       return fallbackUrl;
// //     }
// //   }

// //   /// Open YouTube URL in the app or browser
// //   static Future<void> _openYouTubeUrl(String url) async {
// //     try {
// //       final Uri uri = Uri.parse(url);
// //       final youtubeAppUrl = url.replaceFirst(
// //         'https://www.youtube.com',
// //         'youtube://',
// //       );
// //       final youtubeAppUri = Uri.parse(youtubeAppUrl);

// //       bool opened = false;

// //       try {
// //         if (await canLaunchUrl(youtubeAppUri)) {
// //           await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
// //           opened = true;
// //           print("✅ Opened in YouTube app");
// //         }
// //       } catch (e) {
// //         print("YouTube app not available: $e");
// //       }

// //       if (!opened) {
// //         if (await canLaunchUrl(uri)) {
// //           await launchUrl(uri, mode: LaunchMode.externalApplication);
// //           print("✅ Opened in browser");
// //         } else {
// //           throw Exception("Cannot open YouTube URL");
// //         }
// //       }
// //     } catch (e) {
// //       print("Error opening YouTube URL: $e");
// //       throw e;
// //     }
// //   }

// //   /// Get coordinates for known major cities (NO GEMINI)
// //   static Map<String, double>? _getKnownCityCoordinates(String cityName) {
// //     final cities = {
// //       'delhi': {'lat': 28.6139, 'lon': 77.2090},
// //       'mumbai': {'lat': 19.0760, 'lon': 72.8777},
// //       'bangalore': {'lat': 12.9716, 'lon': 77.5946},
// //       'jaipur': {'lat': 26.9124, 'lon': 75.7873},
// //       'pune': {'lat': 18.5204, 'lon': 73.8567},
// //       'chennai': {'lat': 13.0827, 'lon': 80.2707},
// //       'hyderabad': {'lat': 17.3850, 'lon': 78.4867},
// //       'kolkata': {'lat': 22.5726, 'lon': 88.3639},
// //       'new york': {'lat': 40.7128, 'lon': -74.0060},
// //       'london': {'lat': 51.5074, 'lon': -0.1278},
// //       'tokyo': {'lat': 35.6762, 'lon': 139.6503},
// //       'paris': {'lat': 48.8566, 'lon': 2.3522},
// //     };

// //     return cities[cityName.toLowerCase()];
// //   }

// //   /// Extract city name from weather command
// //   static String _extractCityFromCommand(String command) {
// //     final lowerCommand = command.toLowerCase();

// //     final patterns = [
// //       RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
// //       RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
// //       RegExp(r'([a-zA-Z\s]+) weather'),
// //     ];

// //     for (final pattern in patterns) {
// //       final match = pattern.firstMatch(lowerCommand);
// //       if (match != null) {
// //         return match.group(1)!.trim();
// //       }
// //     }

// //     return "";
// //   }

// //   /// Get current position with proper error handling
// //   static Future<Position?> _getCurrentPosition() async {
// //     try {
// //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //       if (!serviceEnabled) {
// //         print("Location services are disabled");
// //         return null;
// //       }

// //       LocationPermission permission = await Geolocator.checkPermission();
// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //         if (permission == LocationPermission.denied) {
// //           print("Location permissions are denied");
// //           return null;
// //         }
// //       }

// //       if (permission == LocationPermission.deniedForever) {
// //         print("Location permissions are permanently denied");
// //         return null;
// //       }

// //       return await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.low,
// //         timeLimit: Duration(seconds: 10),
// //       );
// //     } catch (e) {
// //       print("Error getting current position: $e");
// //       return null;
// //     }
// //   }

// //   /// Fetch weather data from Open-Meteo API
// //   static Future<Map<String, dynamic>?> _fetchWeatherData(
// //     double lat,
// //     double lon,
// //   ) async {
// //     try {
// //       final url =
// //           'https://api.open-meteo.com/v1/forecast?'
// //           'latitude=$lat&longitude=$lon&'
// //           'current_weather=true&'
// //           'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
// //           'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
// //           'timezone=auto';

// //       final response = await http
// //           .get(Uri.parse(url))
// //           .timeout(Duration(seconds: 10));

// //       if (response.statusCode == 200) {
// //         return json.decode(response.body);
// //       }
// //     } catch (e) {
// //       print("Error fetching weather data: $e");
// //     }
// //     return null;
// //   }

// //   /// Format weather message in a user-friendly way
// //   static String _formatWeatherMessage(
// //     Map<String, dynamic>? weatherData,
// //     String location,
// //   ) {
// //     if (weatherData == null || weatherData['current_weather'] == null) {
// //       return "Sorry, I couldn't get weather information for $location right now.";
// //     }

// //     final current = weatherData['current_weather'];
// //     final temp = current['temperature']?.round() ?? 0;
// //     final windSpeed = current['windspeed']?.round() ?? 0;
// //     final weatherCode = current['weathercode'] ?? 0;

// //     String condition = _getWeatherCondition(weatherCode);
// //     String message =
// //         "The weather in $location is currently $condition with a temperature of ${temp}°C";

// //     if (windSpeed > 0) {
// //       message += " and wind speed of ${windSpeed} km/h";
// //     }

// //     if (weatherData['daily'] != null) {
// //       final daily = weatherData['daily'];
// //       final maxTemp = daily['temperature_2m_max']?[0]?.round();
// //       final minTemp = daily['temperature_2m_min']?[0]?.round();

// //       if (maxTemp != null && minTemp != null) {
// //         message += ". Today's high will be ${maxTemp}°C and low ${minTemp}°C";
// //       }
// //     }

// //     return message + ".";
// //   }

// //   /// Convert weather code to readable condition
// //   static String _getWeatherCondition(int code) {
// //     switch (code) {
// //       case 0:
// //         return "clear sky";
// //       case 1:
// //       case 2:
// //       case 3:
// //         return "partly cloudy";
// //       case 45:
// //       case 48:
// //         return "foggy";
// //       case 51:
// //       case 53:
// //       case 55:
// //         return "drizzly";
// //       case 61:
// //       case 63:
// //       case 65:
// //         return "rainy";
// //       case 71:
// //       case 73:
// //       case 75:
// //         return "snowy";
// //       case 95:
// //       case 96:
// //       case 99:
// //         return "thunderstorms";
// //       default:
// //         return "variable conditions";
// //     }
// //   }

// //   // Request type checking methods
// //   static bool _isTimeRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('time') ||
// //         lowerCommand.contains('clock') ||
// //         lowerCommand.contains('समय') ||
// //         lowerCommand.contains('時間') ||
// //         lowerCommand.contains('temps') ||
// //         lowerCommand.contains('hora');
// //   }

// //   static bool _isWeatherRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('weather') ||
// //         lowerCommand.contains('temperature') ||
// //         lowerCommand.contains('मौसम') ||
// //         lowerCommand.contains('天気') ||
// //         lowerCommand.contains('temps') ||
// //         lowerCommand.contains('clima');
// //   }

// //   static bool _isMusicRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('play') ||
// //         lowerCommand.contains('music') ||
// //         lowerCommand.contains('song') ||
// //         lowerCommand.contains('track') ||
// //         lowerCommand.contains('गाना') ||
// //         lowerCommand.contains('संगीत') ||
// //         lowerCommand.contains('音楽') ||
// //         lowerCommand.contains('música') ||
// //         lowerCommand.contains('musique');
// //   }

// //   static bool _isJokeRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('joke') ||
// //         lowerCommand.contains('funny') ||
// //         lowerCommand.contains('humor') ||
// //         lowerCommand.contains('laugh') ||
// //         lowerCommand.contains('comedy') ||
// //         lowerCommand.contains('हंसी') ||
// //         lowerCommand.contains('मजाक') ||
// //         lowerCommand.contains('笑话') ||
// //         lowerCommand.contains('冗談') ||
// //         lowerCommand.contains('broma') ||
// //         lowerCommand.contains('blague');
// //   }

// //   static bool _isMathRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('calculate') ||
// //         lowerCommand.contains('math') ||
// //         lowerCommand.contains('plus') ||
// //         lowerCommand.contains('minus') ||
// //         lowerCommand.contains('times') ||
// //         lowerCommand.contains('divided') ||
// //         lowerCommand.contains('+') ||
// //         lowerCommand.contains('-') ||
// //         lowerCommand.contains('*') ||
// //         lowerCommand.contains('/') ||
// //         lowerCommand.contains('add') ||
// //         lowerCommand.contains('subtract') ||
// //         lowerCommand.contains('multiply') ||
// //         lowerCommand.contains('divide');
// //   }

// //   static bool _isHelpRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('help') ||
// //         lowerCommand.contains('what can you do') ||
// //         lowerCommand.contains('what do you do') ||
// //         lowerCommand.contains('capabilities') ||
// //         lowerCommand.contains('features');
// //   }

// //   static bool _isGreetingRequest(String command) {
// //     final lowerCommand = command.toLowerCase();
// //     return lowerCommand.contains('hello') ||
// //         lowerCommand.contains('hi') ||
// //         lowerCommand.contains('hey') ||
// //         lowerCommand.contains('good morning') ||
// //         lowerCommand.contains('good evening') ||
// //         lowerCommand.contains('good afternoon') ||
// //         lowerCommand.contains('नमस्ते') ||
// //         lowerCommand.contains('हैलो');
// //   }

// //   /// Your original working API call method - ONLY for general questions
// //   static Future<String?> _callGeminiAPI(String prompt) async {
// //     try {
// //       if (!_isInitialized) {
// //         print("Gemini not initialized");
// //         return null;
// //       }

// //       print("Sending request to Flutter Gemini...");
// //       final gemini = Gemini.instance;

// //       final response = await gemini
// //           .prompt(parts: [Part.text(prompt)])
// //           .timeout(timeoutDuration);

// //       print("Flutter Gemini API Response received");

// //       if (response?.output != null && response!.output!.isNotEmpty) {
// //         final outputText = response.output!;
// //         print(
// //           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
// //         );
// //         return outputText;
// //       } else {
// //         print("Empty response output");
// //         return null;
// //       }
// //     } on TimeoutException {
// //       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
// //       rethrow;
// //     } catch (e) {
// //       print("Unexpected error in API call: $e");
// //       rethrow;
// //     }
// //   }

// //   static Future<Map<String, dynamic>> updateAssistantName(
// //     String newName,
// //   ) async {
// //     return {
// //       'status': 'success',
// //       'message': 'Assistant name updated to $newName',
// //     };
// //   }

// //   static Future<Map<String, dynamic>> testConnection() async {
// //     try {
// //       print("Testing connection to Flutter Gemini API...");

// //       if (!_isInitialized) {
// //         return {
// //           'status': 'error',
// //           'message': 'Gemini not initialized. Please check your API key.',
// //         };
// //       }

// //       final gemini = Gemini.instance;
// //       final response = await gemini
// //           .prompt(
// //             parts: [
// //               Part.text(
// //                 "Hello, respond with just 'Hello' to test the connection",
// //               ),
// //             ],
// //           )
// //           .timeout(Duration(seconds: 10));

// //       if (response?.output != null && response!.output!.isNotEmpty) {
// //         return {
// //           'status': 'success',
// //           'message':
// //               'Flutter Gemini API is working perfectly! Response: ${response.output}',
// //         };
// //       } else {
// //         return {
// //           'status': 'error',
// //           'message': 'API responded but with empty content',
// //         };
// //       }
// //     } on TimeoutException {
// //       return {
// //         'status': 'timeout',
// //         'message': 'Connection test timed out. Check your internet connection.',
// //       };
// //     } catch (e) {
// //       return {
// //         'status': 'error',
// //         'message': 'Connection test failed: ${e.toString()}',
// //       };
// //     }
// //   }

// //   // Legacy method for compatibility
// //   static Map<String, dynamic> getOfflineResponse(String command) {
// //     // This method is no longer used since we handle everything directly
// //     return {
// //       'status': 'success',
// //       'message':
// //           'I can help with time, weather, music, jokes, math, and general questions!',
// //       'type': 'help',
// //       'source': 'local',
// //     };
// //   }

// //   // Joke API methods
// //   static Future<Map<String, dynamic>> testJokeApi() async {
// //     try {
// //       final isWorking = await JokeService.testApiConnection();
// //       if (isWorking) {
// //         return {
// //           'status': 'success',
// //           'message': 'Joke API is working perfectly!',
// //         };
// //       } else {
// //         return {
// //           'status': 'error',
// //           'message': 'Joke API is not responding, using fallback jokes.',
// //         };
// //       }
// //     } catch (e) {
// //       return {'status': 'error', 'message': 'Joke API test failed: $e'};
// //     }
// //   }

// //   static Map<String, dynamic> getJokeStatistics() {
// //     return JokeService.getJokeStats();
// //   }

// //   static void clearJokeMemory() {
// //     JokeService.clearJokeMemory();
// //   }
// // }
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'joke_service.dart';

// class GeminiService {
//   static const String apiKey =
//       'AIzaSyD9jv-vqO495MGI01Q8mhgbUhGkR5Qk0mM'; // Replace with your actual API key
//   static const Duration timeoutDuration = Duration(seconds: 15);
//   static bool _isInitialized = false;

//   /// Initialize the Gemini service
//   static void init() {
//     if (apiKey != 'YOUR_NEW_API_KEY_HERE') {
//       try {
//         Gemini.init(apiKey: apiKey);
//         _isInitialized = true;
//         print(
//           "✅ Flutter Gemini initialized successfully with model: gemini-pro",
//         );
//       } catch (e) {
//         print("❌ Failed to initialize Gemini: $e");
//         _isInitialized = false;
//       }
//     } else {
//       print("⚠️ Gemini API key not set, using offline mode");
//       _isInitialized = false;
//     }
//   }

//   /// Check if Gemini is properly initialized
//   static bool get isInitialized => _isInitialized;

//   /// Process any voice command - Local handlers for specific features, Gemini for general/math
//   static Future<Map<String, dynamic>> processCommand(
//     String command,
//     String languageCode,
//   ) async {
//     try {
//       print("Processing command: $command in language: $languageCode");

//       // Handle time requests locally (NO GEMINI)
//       if (_isTimeRequest(command)) {
//         print("⏰ Processing TIME request locally");
//         final timeResponse = getCurrentTime();
//         return {
//           'status': 'success',
//           'message': timeResponse,
//           'type': 'time',
//           'originalCommand': command,
//           'source': 'local',
//         };
//       }

//       // Handle weather requests locally (NO GEMINI)
//       if (_isWeatherRequest(command)) {
//         print("🌤️ Processing WEATHER request locally");
//         return await _handleWeatherRequestLocal(command, languageCode);
//       }

//       // Handle music requests locally (NO GEMINI)
//       if (_isMusicRequest(command)) {
//         print("🎵 Processing MUSIC request locally");
//         return await _handleMusicRequestLocal(command, languageCode);
//       }

//       // Handle joke requests locally (NO GEMINI)
//       if (_isJokeRequest(command)) {
//         print("😄 Processing JOKE request locally");
//         return await _handleJokeRequestLocal(command, languageCode);
//       }

//       // Handle help and greetings locally (NO GEMINI)
//       if (_isHelpRequest(command)) {
//         print("❓ Processing HELP request locally");
//         return _handleHelpRequestLocal();
//       }

//       if (_isGreetingRequest(command)) {
//         print("👋 Processing GREETING request locally");
//         return _handleGreetingRequestLocal();
//       }

//       // MATH and GENERAL questions go to Gemini (your original working approach)
//       print("💬 Processing with Gemini (Math/General)");
//       return await _processWithGemini(command);
//     } catch (e) {
//       print("Error in processCommand: $e");
//       return {
//         'status': 'error',
//         'message': 'Sorry, I encountered an error processing your request.',
//         'type': 'error',
//         'originalCommand': command,
//       };
//     }
//   }

//   /// Use your original working Gemini approach for math and general questions
//   static Future<Map<String, dynamic>> _processWithGemini(String command) async {
//     try {
//       print("Processing command with Flutter Gemini: $command");

//       if (!_isInitialized) {
//         print("⚠️ Gemini not initialized, using offline mode");
//         return getOfflineResponse(command);
//       }

//       final String enhancedPrompt = _createEnhancedPrompt(command);
//       final response = await _callGeminiAPI(enhancedPrompt);

//       if (response != null && response.isNotEmpty) {
//         final responseType = _analyzeResponseType(command, response);

//         return {
//           'status': 'success',
//           'message': response,
//           'type': responseType,
//           'originalCommand': command,
//           'source': 'gemini',
//         };
//       } else {
//         print("Empty response from Gemini API, falling back to offline");
//         return getOfflineResponse(command);
//       }
//     } on TimeoutException catch (e) {
//       print("Gemini API timeout: $e");
//       return {
//         'status': 'timeout',
//         'message': 'Request timed out. Using offline response.',
//         'type': 'offline',
//         'fallback': getOfflineResponse(command),
//       };
//     } catch (e) {
//       print("Error in Gemini API call: $e");
//       return {
//         'status': 'error',
//         'message':
//             'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
//         'type': 'offline',
//         'fallback': getOfflineResponse(command),
//       };
//     }
//   }

//   /// Your original working prompt creation
//   static String _createEnhancedPrompt(String userCommand) {
//     return '''
// You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

// Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

// Guidelines:
// - For math questions, solve them clearly and show the result
// - For general questions, provide helpful information
// - Respond in the same language the user used
// - Keep responses under 100 words for voice output
// - Be friendly and conversational
// - If you don't know something, suggest checking reliable sources

// User's request: $userCommand
// ''';
//   }

//   /// Your original working API call method
//   static Future<String?> _callGeminiAPI(String prompt) async {
//     try {
//       if (!_isInitialized) {
//         print("Gemini not initialized");
//         return null;
//       }

//       print("Sending request to Flutter Gemini...");
//       final gemini = Gemini.instance;

//       // You can specify model in individual requests (if supported by the package)
//       final response = await gemini
//           .prompt(
//             parts: [Part.text(prompt)],
//             // Note: flutter_gemini package may not support model parameter here
//             // It uses the default model set during initialization
//           )
//           .timeout(timeoutDuration);

//       print("Flutter Gemini API Response received");

//       if (response?.output != null && response!.output!.isNotEmpty) {
//         final outputText = response.output!;
//         print(
//           "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
//         );
//         return outputText;
//       } else {
//         print("Empty response output");
//         return null;
//       }
//     } on TimeoutException {
//       print("Request timed out after ${timeoutDuration.inSeconds} seconds");
//       rethrow;
//     } catch (e) {
//       print("Unexpected error in API call: $e");
//       rethrow;
//     }
//   }

//   /// Your original response type analyzer
//   static String _analyzeResponseType(String command, String response) {
//     final lowerCommand = command.toLowerCase();

//     if (lowerCommand.contains('calculate') ||
//         lowerCommand.contains('math') ||
//         lowerCommand.contains('+') ||
//         lowerCommand.contains('-') ||
//         lowerCommand.contains('*') ||
//         lowerCommand.contains('/') ||
//         lowerCommand.contains('plus') ||
//         lowerCommand.contains('minus') ||
//         lowerCommand.contains('times') ||
//         lowerCommand.contains('divided')) {
//       return 'calculation';
//     } else {
//       return 'general';
//     }
//   }

//   // LOCAL HANDLERS (NO GEMINI)

//   /// Handle time requests locally
//   static String getCurrentTime() {
//     final now = DateTime.now();
//     final hour = now.hour;
//     final minute = now.minute.toString().padLeft(2, '0');
//     final period = hour >= 12 ? 'PM' : 'AM';
//     final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

//     return "The current time is $displayHour:$minute $period";
//   }

//   /// Handle weather requests locally with API
//   static Future<Map<String, dynamic>> _handleWeatherRequestLocal(
//     String command,
//     String languageCode,
//   ) async {
//     try {
//       double? lat, lon;
//       String location = "your location";

//       String cityName = _extractCityFromCommand(command);

//       if (cityName.isNotEmpty) {
//         final cityCoords = _getKnownCityCoordinates(cityName);
//         if (cityCoords != null) {
//           lat = cityCoords['lat'];
//           lon = cityCoords['lon'];
//           location = cityName;
//         }
//       } else {
//         final position = await _getCurrentPosition();
//         if (position != null) {
//           lat = position.latitude;
//           lon = position.longitude;
//         }
//       }

//       if (lat == null || lon == null) {
//         lat = 26.85;
//         lon = 75.78;
//         location = "Jaipur";
//       }

//       final weatherData = await _fetchWeatherData(lat, lon);
//       final weatherMessage = _formatWeatherMessage(weatherData, location);

//       return {
//         'status': 'success',
//         'message': weatherMessage,
//         'type': 'weather',
//         'originalCommand': command,
//         'source': 'weather_api',
//       };
//     } catch (e) {
//       print("Weather request error: $e");
//       return {
//         'status': 'success',
//         'message':
//             'I can\'t check the weather right now, but you can check your local weather app!',
//         'type': 'weather',
//         'originalCommand': command,
//         'source': 'fallback',
//       };
//     }
//   }

//   /// Handle music requests locally
//   static Future<Map<String, dynamic>> _handleMusicRequestLocal(
//     String command,
//     String languageCode,
//   ) async {
//     try {
//       String searchQuery = _extractMusicQuery(command);

//       if (searchQuery.isEmpty) {
//         searchQuery = _getPopularSongFallback();
//       }

//       final youtubeUrl = await _searchYouTubeMusic(searchQuery);

//       if (youtubeUrl != null) {
//         await _openYouTubeUrl(youtubeUrl);

//         final successMessage = "Opening '$searchQuery' on YouTube!";

//         return {
//           'status': 'success',
//           'message': successMessage,
//           'type': 'music',
//           'originalCommand': command,
//           'youtubeUrl': youtubeUrl,
//           'searchQuery': searchQuery,
//           'source': 'youtube_api',
//         };
//       } else {
//         return {
//           'status': 'success',
//           'message':
//               'I can\'t play music directly, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
//           'type': 'music',
//           'originalCommand': command,
//           'source': 'fallback',
//         };
//       }
//     } catch (e) {
//       print("Music request error: $e");
//       return {
//         'status': 'success',
//         'message':
//             'I can\'t play music directly, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
//         'type': 'music',
//         'originalCommand': command,
//         'source': 'fallback',
//       };
//     }
//   }

//   /// Handle joke requests locally
//   static Future<Map<String, dynamic>> _handleJokeRequestLocal(
//     String command,
//     String languageCode,
//   ) async {
//     try {
//       final joke = await JokeService.generateJoke(languageCode, true);
//       return {
//         'status': 'success',
//         'message': joke,
//         'type': 'joke',
//         'originalCommand': command,
//         'source': 'external_api',
//       };
//     } catch (e) {
//       print("External joke API failed, using fallback: $e");
//       final jokes = [
//         "Why don't scientists trust atoms? Because they make up everything!",
//         "Why did the scarecrow win an award? He was outstanding in his field!",
//         "Why don't eggs tell jokes? They'd crack each other up!",
//         "What do you call a bear with no teeth? A gummy bear!",
//         "Why don't programmers like nature? It has too many bugs!",
//       ];
//       final randomJoke = jokes[DateTime.now().millisecond % jokes.length];
//       return {
//         'status': 'success',
//         'message': randomJoke,
//         'type': 'joke',
//         'originalCommand': command,
//         'source': 'fallback',
//       };
//     }
//   }

//   /// Handle help requests locally
//   static Map<String, dynamic> _handleHelpRequestLocal() {
//     return {
//       'status': 'success',
//       'message':
//           'I can help you with: telling time, checking weather, playing music from YouTube, sharing jokes, math calculations, and answering general questions. What would you like to try?',
//       'type': 'help',
//       'source': 'local',
//     };
//   }

//   /// Handle greetings locally
//   static Map<String, dynamic> _handleGreetingRequestLocal() {
//     final greetings = [
//       'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
//       'Hi there! I\'m ready to assist you with time, weather, music, jokes, and more!',
//       'Greetings! What can I do for you today?',
//       'Hello! I\'m here to help with your questions and tasks.',
//     ];

//     final greeting = greetings[DateTime.now().millisecond % greetings.length];

//     return {
//       'status': 'success',
//       'message': greeting,
//       'type': 'greeting',
//       'source': 'local',
//     };
//   }

//   // UTILITY METHODS FOR LOCAL FEATURES

//   static String _getPopularSongFallback() {
//     final popularSongs = [
//       'Shape of You Ed Sheeran',
//       'Blinding Lights The Weeknd',
//       'Levitating Dua Lipa',
//       'Watermelon Sugar Harry Styles',
//       'Bad Habits Ed Sheeran',
//     ];
//     return popularSongs[DateTime.now().millisecond % popularSongs.length];
//   }

//   static String _extractMusicQuery(String command) {
//     final lowerCommand = command.toLowerCase();
//     String query = lowerCommand
//         .replaceAll('play', '')
//         .replaceAll('song', '')
//         .replaceAll('music', '')
//         .replaceAll('track', '')
//         .replaceAll('by', '')
//         .replaceAll('from', '')
//         .replaceAll('the', '')
//         .replaceAll('a', '')
//         .trim();

//     if (query.contains(' by ')) {
//       final parts = query.split(' by ');
//       if (parts.length >= 2) {
//         return "${parts[0].trim()} ${parts[1].trim()}";
//       }
//     }
//     return query;
//   }

//   static Future<String?> _searchYouTubeMusic(String query) async {
//     try {
//       final encodedQuery = Uri.encodeComponent("$query music video");
//       final searchUrl =
//           "https://www.youtube.com/results?search_query=$encodedQuery";

//       final response = await http
//           .get(
//             Uri.parse(searchUrl),
//             headers: {
//               'User-Agent':
//                   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
//             },
//           )
//           .timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final body = response.body;
//         final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
//         final match = videoIdRegex.firstMatch(body);

//         if (match != null) {
//           final videoId = match.group(1);
//           return "https://www.youtube.com/watch?v=$videoId";
//         }
//       }
//       return "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
//     } catch (e) {
//       print("YouTube search error: $e");
//       return "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
//     }
//   }

//   static Future<void> _openYouTubeUrl(String url) async {
//     try {
//       final Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       }
//     } catch (e) {
//       print("Error opening YouTube URL: $e");
//     }
//   }

//   static Map<String, double>? _getKnownCityCoordinates(String cityName) {
//     final cities = {
//       'delhi': {'lat': 28.6139, 'lon': 77.2090},
//       'mumbai': {'lat': 19.0760, 'lon': 72.8777},
//       'bangalore': {'lat': 12.9716, 'lon': 77.5946},
//       'jaipur': {'lat': 26.9124, 'lon': 75.7873},
//       'pune': {'lat': 18.5204, 'lon': 73.8567},
//       'chennai': {'lat': 13.0827, 'lon': 80.2707},
//     };
//     return cities[cityName.toLowerCase()];
//   }

//   static String _extractCityFromCommand(String command) {
//     final lowerCommand = command.toLowerCase();
//     final patterns = [
//       RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
//       RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
//       RegExp(r'([a-zA-Z\s]+) weather'),
//     ];

//     for (final pattern in patterns) {
//       final match = pattern.firstMatch(lowerCommand);
//       if (match != null) {
//         return match.group(1)!.trim();
//       }
//     }
//     return "";
//   }

//   static Future<Position?> _getCurrentPosition() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return null;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return null;
//       }

//       if (permission == LocationPermission.deniedForever) return null;

//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.low,
//         timeLimit: Duration(seconds: 10),
//       );
//     } catch (e) {
//       print("Error getting current position: $e");
//       return null;
//     }
//   }

//   static Future<Map<String, dynamic>?> _fetchWeatherData(
//     double lat,
//     double lon,
//   ) async {
//     try {
//       final url =
//           'https://api.open-meteo.com/v1/forecast?'
//           'latitude=$lat&longitude=$lon&'
//           'current_weather=true&'
//           'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
//           'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
//           'timezone=auto';

//       final response = await http
//           .get(Uri.parse(url))
//           .timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//     } catch (e) {
//       print("Error fetching weather data: $e");
//     }
//     return null;
//   }

//   static String _formatWeatherMessage(
//     Map<String, dynamic>? weatherData,
//     String location,
//   ) {
//     if (weatherData == null || weatherData['current_weather'] == null) {
//       return "Sorry, I couldn't get weather information for $location right now.";
//     }

//     final current = weatherData['current_weather'];
//     final temp = current['temperature']?.round() ?? 0;
//     final windSpeed = current['windspeed']?.round() ?? 0;
//     final weatherCode = current['weathercode'] ?? 0;

//     String condition = _getWeatherCondition(weatherCode);
//     String message =
//         "The weather in $location is currently $condition with a temperature of ${temp}°C";

//     if (windSpeed > 0) {
//       message += " and wind speed of ${windSpeed} km/h";
//     }

//     return message + ".";
//   }

//   static String _getWeatherCondition(int code) {
//     switch (code) {
//       case 0:
//         return "clear sky";
//       case 1:
//       case 2:
//       case 3:
//         return "partly cloudy";
//       case 45:
//       case 48:
//         return "foggy";
//       case 51:
//       case 53:
//       case 55:
//         return "drizzly";
//       case 61:
//       case 63:
//       case 65:
//         return "rainy";
//       case 71:
//       case 73:
//       case 75:
//         return "snowy";
//       case 95:
//       case 96:
//       case 99:
//         return "thunderstorms";
//       default:
//         return "variable conditions";
//     }
//   }

//   // REQUEST TYPE CHECKING METHODS
//   static bool _isTimeRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('time') || lowerCommand.contains('clock');
//   }

//   static bool _isWeatherRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('weather') ||
//         lowerCommand.contains('temperature');
//   }

//   static bool _isMusicRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('play') ||
//         lowerCommand.contains('music') ||
//         lowerCommand.contains('song');
//   }

//   static bool _isJokeRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('joke') || lowerCommand.contains('funny');
//   }

//   static bool _isHelpRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('help') ||
//         lowerCommand.contains('what can you do');
//   }

//   static bool _isGreetingRequest(String command) {
//     final lowerCommand = command.toLowerCase();
//     return lowerCommand.contains('hello') ||
//         lowerCommand.contains('hi') ||
//         lowerCommand.contains('hey');
//   }

//   // ORIGINAL METHODS FOR COMPATIBILITY

//   /// Update assistant name (placeholder for consistency)
//   static Future<Map<String, dynamic>> updateAssistantName(
//     String newName,
//   ) async {
//     return {
//       'status': 'success',
//       'message': 'Assistant name updated to $newName',
//     };
//   }

//   /// Test the Gemini API connection
//   static Future<Map<String, dynamic>> testConnection() async {
//     try {
//       print("Testing connection to Flutter Gemini API...");

//       if (!_isInitialized) {
//         return {
//           'status': 'error',
//           'message': 'Gemini not initialized. Please check your API key.',
//         };
//       }

//       final gemini = Gemini.instance;
//       final response = await gemini
//           .prompt(
//             parts: [
//               Part.text(
//                 "Hello, respond with just 'Hello' to test the connection",
//               ),
//             ],
//           )
//           .timeout(Duration(seconds: 10));

//       if (response?.output != null && response!.output!.isNotEmpty) {
//         return {
//           'status': 'success',
//           'message':
//               'Flutter Gemini API is working perfectly! Response: ${response.output}',
//         };
//       } else {
//         return {
//           'status': 'error',
//           'message': 'API responded but with empty content',
//         };
//       }
//     } on TimeoutException {
//       return {
//         'status': 'timeout',
//         'message': 'Connection test timed out. Check your internet connection.',
//       };
//     } catch (e) {
//       return {
//         'status': 'error',
//         'message': 'Connection test failed: ${e.toString()}',
//       };
//     }
//   }

//   /// Your original offline response method
//   static Map<String, dynamic> getOfflineResponse(String command) {
//     final lowerCommand = command.toLowerCase();

//     if (lowerCommand.contains('calculate') || lowerCommand.contains('math')) {
//       return {
//         'status': 'success',
//         'message':
//             'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
//         'type': 'calculation',
//       };
//     } else {
//       final responses = [
//         'I\'m currently in offline mode, but I can still help with basic tasks!',
//         'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
//         'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
//         'Thanks for talking with me! I can do more when connected to the internet.',
//       ];
//       final randomResponse =
//           responses[DateTime.now().millisecond % responses.length];
//       return {
//         'status': 'success',
//         'message': randomResponse,
//         'type': 'offline',
//       };
//     }
//   }

//   // Additional methods for joke service compatibility
//   static Future<Map<String, dynamic>> testJokeApi() async {
//     try {
//       final isWorking = await JokeService.testApiConnection();
//       if (isWorking) {
//         return {
//           'status': 'success',
//           'message': 'Joke API is working perfectly!',
//         };
//       } else {
//         return {
//           'status': 'error',
//           'message': 'Joke API is not responding, using fallback jokes.',
//         };
//       }
//     } catch (e) {
//       return {'status': 'error', 'message': 'Joke API test failed: $e'};
//     }
//   }

//   static Map<String, dynamic> getJokeStatistics() {
//     return JokeService.getJokeStats();
//   }

//   static void clearJokeMemory() {
//     JokeService.clearJokeMemory();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'joke_service.dart';

class GeminiService {
  // ✅ SOLUTION 1: Multiple API Keys with rotation
  static const List<String> apiKeys = [
    'AIzaSyD-KFd9q9SL2E75hC2AQjYhhHYII2Vg1KQ',
    'AIzaSyAZ_E3n3EviNGTmvc4kabfvWfkXKDIAT2E',
    'AIzaSyD-deGO4C2vJZ8KBD0rc0M-En9aXLuu15o',
    'AIzaSyD9jv-vqO495MGI01Q8mhgbUhGkR5Qk0mM',
    'AIzaSyDC6SEQcIg6cIE9mkeqHr3LOzPRoxBEZcw',
  ];

  static int _currentKeyIndex = 0;
  static const Duration timeoutDuration = Duration(seconds: 15);
  static bool _isInitialized = false;

  // ✅ SOLUTION 2: Rate limiting variables
  static DateTime? _lastRequest;
  static int _requestCount = 0;
  static const int maxRequestsPerMinute = 5; // Conservative limit
  static const Duration rateLimitWindow = Duration(minutes: 1);
  static const Duration minimumDelay = Duration(
    seconds: 3,
  ); // Minimum delay between requests

  /// Initialize the Gemini service with API key rotation
  static void init() {
    if (apiKeys.first != 'YOUR_API_KEY_1_HERE') {
      try {
        // Start with the first API key
        Gemini.init(apiKey: apiKeys[_currentKeyIndex]);
        _isInitialized = true;
        print(
          "✅ Flutter Gemini initialized successfully with API key ${_currentKeyIndex + 1}",
        );
      } catch (e) {
        print("❌ Failed to initialize Gemini: $e");
        _isInitialized = false;
      }
    } else {
      print("⚠️ Gemini API keys not set, using offline mode");
      _isInitialized = false;
    }
  }

  /// Rotate to next API key if current one fails
  static Future<void> _rotateApiKey() async {
    _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length;
    try {
      Gemini.init(apiKey: apiKeys[_currentKeyIndex]);
      print("🔄 Rotated to API key ${_currentKeyIndex + 1}");
      await Future.delayed(Duration(seconds: 2)); // Wait before using new key
    } catch (e) {
      print("❌ Failed to rotate API key: $e");
    }
  }

  /// Check and enforce rate limiting
  static Future<bool> _checkRateLimit() async {
    final now = DateTime.now();

    // Reset counter if window has passed
    if (_lastRequest != null &&
        now.difference(_lastRequest!) > rateLimitWindow) {
      _requestCount = 0;
    }

    // Check if we've exceeded rate limit
    if (_requestCount >= maxRequestsPerMinute) {
      print("⚠️ Rate limit exceeded. Waiting 60 seconds...");
      await Future.delayed(Duration(seconds: 60));
      _requestCount = 0;
    }

    // Enforce minimum delay between requests
    if (_lastRequest != null) {
      final timeSinceLastRequest = now.difference(_lastRequest!);
      if (timeSinceLastRequest < minimumDelay) {
        final waitTime = minimumDelay - timeSinceLastRequest;
        print("⏳ Waiting ${waitTime.inSeconds} seconds before next request...");
        await Future.delayed(waitTime);
      }
    }

    _lastRequest = DateTime.now();
    _requestCount++;
    return true;
  }

  /// Check if Gemini is properly initialized
  static bool get isInitialized => _isInitialized;

  /// Process any voice command - Local handlers for specific features, Gemini for general/math
  static Future<Map<String, dynamic>> processCommand(
    String command,
    String languageCode,
  ) async {
    try {
      print("Processing command: $command in language: $languageCode");

      // Handle time requests locally (NO GEMINI)
      if (_isTimeRequest(command)) {
        print("⏰ Processing TIME request locally");
        final timeResponse = getCurrentTime();
        return {
          'status': 'success',
          'message': timeResponse,
          'type': 'time',
          'originalCommand': command,
          'source': 'local',
        };
      }

      // Handle weather requests locally (NO GEMINI)
      if (_isWeatherRequest(command)) {
        print("🌤️ Processing WEATHER request locally");
        return await _handleWeatherRequestLocal(command, languageCode);
      }

      // Handle music requests locally (NO GEMINI)
      if (_isMusicRequest(command)) {
        print("🎵 Processing MUSIC request locally");
        return await _handleMusicRequestLocal(command, languageCode);
      }

      // Handle joke requests locally (NO GEMINI)
      if (_isJokeRequest(command)) {
        print("😄 Processing JOKE request locally");
        return await _handleJokeRequestLocal(command, languageCode);
      }

      // Handle help and greetings locally (NO GEMINI)
      if (_isHelpRequest(command)) {
        print("❓ Processing HELP request locally");
        return _handleHelpRequestLocal();
      }

      if (_isGreetingRequest(command)) {
        print("👋 Processing GREETING request locally");
        return _handleGreetingRequestLocal();
      }

      // MATH and GENERAL questions go to Gemini with rate limiting
      print("💬 Processing with Gemini (Math/General)");
      return await _processWithGeminiSafely(command);
    } catch (e) {
      print("Error in processCommand: $e");
      return {
        'status': 'error',
        'message': 'Sorry, I encountered an error processing your request.',
        'type': 'error',
        'originalCommand': command,
      };
    }
  }

  /// Safe Gemini processing with rate limiting and API key rotation
  static Future<Map<String, dynamic>> _processWithGeminiSafely(
    String command,
  ) async {
    try {
      if (!_isInitialized) {
        print("⚠️ Gemini not initialized, using offline mode");
        return getOfflineResponse(command);
      }

      // ✅ SOLUTION 3: Check rate limit before making request
      await _checkRateLimit();

      print("Processing command with Flutter Gemini: $command");

      final String enhancedPrompt = _createEnhancedPrompt(command);

      // Try with current API key
      var response = await _callGeminiAPISafely(enhancedPrompt);

      if (response != null && response.isNotEmpty) {
        final responseType = _analyzeResponseType(command, response);
        return {
          'status': 'success',
          'message': response,
          'type': responseType,
          'originalCommand': command,
          'source': 'gemini',
          'apiKeyUsed': _currentKeyIndex + 1,
        };
      } else {
        print("Empty response from Gemini API, falling back to offline");
        return getOfflineResponse(command);
      }
    } on TimeoutException catch (e) {
      print("Gemini API timeout: $e");
      return {
        'status': 'timeout',
        'message': 'Request timed out. Using offline response.',
        'type': 'offline',
        'fallback': getOfflineResponse(command),
      };
    } catch (e) {
      print("Error in Gemini API call: $e");

      // If error contains "429" or "quota", try rotating API key
      if (e.toString().contains('429') || e.toString().contains('quota')) {
        print("🔄 429 error detected, rotating API key...");
        await _rotateApiKey();

        // Try once more with new key after a delay
        try {
          await Future.delayed(Duration(seconds: 5));
          final response = await _callGeminiAPISafely(
            _createEnhancedPrompt(command),
          );
          if (response != null && response.isNotEmpty) {
            return {
              'status': 'success',
              'message': response,
              'type': _analyzeResponseType(command, response),
              'originalCommand': command,
              'source': 'gemini',
              'apiKeyUsed': _currentKeyIndex + 1,
              'note': 'Used backup API key',
            };
          }
        } catch (e2) {
          print("Backup API key also failed: $e2");
        }
      }

      return {
        'status': 'error',
        'message':
            'Sorry, I\'m having trouble right now. Here\'s what I can tell you offline.',
        'type': 'offline',
        'fallback': getOfflineResponse(command),
      };
    }
  }

  /// Safe API call with better error handling
  static Future<String?> _callGeminiAPISafely(String prompt) async {
    try {
      if (!_isInitialized) {
        print("Gemini not initialized");
        return null;
      }

      print(
        "Sending request to Flutter Gemini with API key ${_currentKeyIndex + 1}...",
      );
      final gemini = Gemini.instance;

      final response = await gemini
          .prompt(parts: [Part.text(prompt)])
          .timeout(timeoutDuration);

      print("Flutter Gemini API Response received");

      if (response?.output != null && response!.output!.isNotEmpty) {
        final outputText = response.output!;
        print(
          "Response text: ${outputText.length > 100 ? outputText.substring(0, 100) : outputText}...",
        );
        return outputText;
      } else {
        print("Empty response output");
        return null;
      }
    } on TimeoutException {
      print("Request timed out after ${timeoutDuration.inSeconds} seconds");
      rethrow;
    } catch (e) {
      print("Unexpected error in API call: $e");
      rethrow;
    }
  }

  /// Your original working prompt creation
  static String _createEnhancedPrompt(String userCommand) {
    return '''
You are JARVIS, a helpful voice assistant. The user said: "$userCommand"

Please respond in a conversational, helpful manner. Keep your response concise and natural for text-to-speech.

Guidelines:
- For math questions, solve them clearly and show the result
- For general questions, provide helpful information
- Respond in the same language the user used
- Keep responses under 80 words for voice output
- Be friendly and conversational
- If you don't know something, suggest checking reliable sources

User's request: $userCommand
''';
  }

  /// Your original response type analyzer
  static String _analyzeResponseType(String command, String response) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('calculate') ||
        lowerCommand.contains('math') ||
        lowerCommand.contains('+') ||
        lowerCommand.contains('-') ||
        lowerCommand.contains('*') ||
        lowerCommand.contains('/') ||
        lowerCommand.contains('plus') ||
        lowerCommand.contains('minus') ||
        lowerCommand.contains('times') ||
        lowerCommand.contains('divided')) {
      return 'calculation';
    } else {
      return 'general';
    }
  }

  // LOCAL HANDLERS (NO GEMINI) - Keep all your existing local methods

  static String getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return "The current time is $displayHour:$minute $period";
  }

  static Future<Map<String, dynamic>> _handleWeatherRequestLocal(
    String command,
    String languageCode,
  ) async {
    try {
      double? lat, lon;
      String location = "your location";

      String cityName = _extractCityFromCommand(command);

      if (cityName.isNotEmpty) {
        final cityCoords = _getKnownCityCoordinates(cityName);
        if (cityCoords != null) {
          lat = cityCoords['lat'];
          lon = cityCoords['lon'];
          location = cityName;
        }
      } else {
        final position = await _getCurrentPosition();
        if (position != null) {
          lat = position.latitude;
          lon = position.longitude;
        }
      }

      if (lat == null || lon == null) {
        lat = 26.85;
        lon = 75.78;
        location = "Jaipur";
      }

      final weatherData = await _fetchWeatherData(lat, lon);
      final weatherMessage = _formatWeatherMessage(weatherData, location);

      return {
        'status': 'success',
        'message': weatherMessage,
        'type': 'weather',
        'originalCommand': command,
        'source': 'weather_api',
      };
    } catch (e) {
      print("Weather request error: $e");
      return {
        'status': 'success',
        'message':
            'I can\'t check the weather right now, but you can check your local weather app!',
        'type': 'weather',
        'originalCommand': command,
        'source': 'fallback',
      };
    }
  }

  static Future<Map<String, dynamic>> _handleMusicRequestLocal(
    String command,
    String languageCode,
  ) async {
    try {
      String searchQuery = _extractMusicQuery(command);

      if (searchQuery.isEmpty) {
        searchQuery = _getPopularSongFallback();
      }

      final youtubeUrl = await _searchYouTubeMusic(searchQuery);

      if (youtubeUrl != null) {
        await _openYouTubeUrl(youtubeUrl);

        final successMessage = "Opening '$searchQuery' on YouTube!";

        return {
          'status': 'success',
          'message': successMessage,
          'type': 'music',
          'originalCommand': command,
          'youtubeUrl': youtubeUrl,
          'searchQuery': searchQuery,
          'source': 'youtube_api',
        };
      } else {
        return {
          'status': 'success',
          'message':
              'I can\'t play music directly, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
          'type': 'music',
          'originalCommand': command,
          'source': 'fallback',
        };
      }
    } catch (e) {
      print("Music request error: $e");
      return {
        'status': 'success',
        'message':
            'I can\'t play music directly, but you can try asking me to open Spotify, YouTube Music, or your favorite music app!',
        'type': 'music',
        'originalCommand': command,
        'source': 'fallback',
      };
    }
  }

  static Future<Map<String, dynamic>> _handleJokeRequestLocal(
    String command,
    String languageCode,
  ) async {
    try {
      final joke = await JokeService.generateJoke(languageCode, true);
      return {
        'status': 'success',
        'message': joke,
        'type': 'joke',
        'originalCommand': command,
        'source': 'external_api',
      };
    } catch (e) {
      print("External joke API failed, using fallback: $e");
      final jokes = [
        "Why don't scientists trust atoms? Because they make up everything!",
        "Why did the scarecrow win an award? He was outstanding in his field!",
        "Why don't eggs tell jokes? They'd crack each other up!",
        "What do you call a bear with no teeth? A gummy bear!",
        "Why don't programmers like nature? It has too many bugs!",
      ];
      final randomJoke = jokes[DateTime.now().millisecond % jokes.length];
      return {
        'status': 'success',
        'message': randomJoke,
        'type': 'joke',
        'originalCommand': command,
        'source': 'fallback',
      };
    }
  }

  static Map<String, dynamic> _handleHelpRequestLocal() {
    return {
      'status': 'success',
      'message':
          'I can help you with: telling time, checking weather, playing music from YouTube, sharing jokes, math calculations, and answering general questions. What would you like to try?',
      'type': 'help',
      'source': 'local',
    };
  }

  static Map<String, dynamic> _handleGreetingRequestLocal() {
    final greetings = [
      'Hello! I\'m JARVIS, your voice assistant. How can I help you today?',
      'Hi there! I\'m ready to assist you with time, weather, music, jokes, and more!',
      'Greetings! What can I do for you today?',
      'Hello! I\'m here to help with your questions and tasks.',
    ];

    final greeting = greetings[DateTime.now().millisecond % greetings.length];

    return {
      'status': 'success',
      'message': greeting,
      'type': 'greeting',
      'source': 'local',
    };
  }

  // Keep all your existing utility methods...
  static String _getPopularSongFallback() {
    final popularSongs = [
      'Shape of You Ed Sheeran',
      'Blinding Lights The Weeknd',
      'Levitating Dua Lipa',
      'Watermelon Sugar Harry Styles',
      'Bad Habits Ed Sheeran',
    ];
    return popularSongs[DateTime.now().millisecond % popularSongs.length];
  }

  static String _extractMusicQuery(String command) {
    final lowerCommand = command.toLowerCase();
    String query = lowerCommand
        .replaceAll('play', '')
        .replaceAll('song', '')
        .replaceAll('music', '')
        .replaceAll('track', '')
        .replaceAll('by', '')
        .replaceAll('from', '')
        .replaceAll('the', '')
        .replaceAll('a', '')
        .trim();

    if (query.contains(' by ')) {
      final parts = query.split(' by ');
      if (parts.length >= 2) {
        return "${parts[0].trim()} ${parts[1].trim()}";
      }
    }
    return query;
  }

  static Future<String?> _searchYouTubeMusic(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent("$query music video");
      final searchUrl =
          "https://www.youtube.com/results?search_query=$encodedQuery";

      final response = await http
          .get(
            Uri.parse(searchUrl),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = response.body;
        final videoIdRegex = RegExp(r'"videoId":"([^"]+)"');
        final match = videoIdRegex.firstMatch(body);

        if (match != null) {
          final videoId = match.group(1);
          return "https://www.youtube.com/watch?v=$videoId";
        }
      }
      return "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
    } catch (e) {
      print("YouTube search error: $e");
      return "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
    }
  }

  static Future<void> _openYouTubeUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("Error opening YouTube URL: $e");
    }
  }

  static Map<String, double>? _getKnownCityCoordinates(String cityName) {
    final cities = {
      'delhi': {'lat': 28.6139, 'lon': 77.2090},
      'mumbai': {'lat': 19.0760, 'lon': 72.8777},
      'bangalore': {'lat': 12.9716, 'lon': 77.5946},
      'jaipur': {'lat': 26.9124, 'lon': 75.7873},
      'pune': {'lat': 18.5204, 'lon': 73.8567},
      'chennai': {'lat': 13.0827, 'lon': 80.2707},
    };
    return cities[cityName.toLowerCase()];
  }

  static String _extractCityFromCommand(String command) {
    final lowerCommand = command.toLowerCase();
    final patterns = [
      RegExp(r'weather (?:in|for|at) ([a-zA-Z\s]+)'),
      RegExp(r'(?:in|for|at) ([a-zA-Z\s]+) weather'),
      RegExp(r'([a-zA-Z\s]+) weather'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(lowerCommand);
      if (match != null) {
        return match.group(1)!.trim();
      }
    }
    return "";
  }

  static Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      print("Error getting current position: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _fetchWeatherData(
    double lat,
    double lon,
  ) async {
    try {
      final url =
          'https://api.open-meteo.com/v1/forecast?'
          'latitude=$lat&longitude=$lon&'
          'current_weather=true&'
          'hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&'
          'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
          'timezone=auto';

      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
    return null;
  }

  static String _formatWeatherMessage(
    Map<String, dynamic>? weatherData,
    String location,
  ) {
    if (weatherData == null || weatherData['current_weather'] == null) {
      return "Sorry, I couldn't get weather information for $location right now.";
    }

    final current = weatherData['current_weather'];
    final temp = current['temperature']?.round() ?? 0;
    final windSpeed = current['windspeed']?.round() ?? 0;
    final weatherCode = current['weathercode'] ?? 0;

    String condition = _getWeatherCondition(weatherCode);
    String message =
        "The weather in $location is currently $condition with a temperature of ${temp}°C";

    if (windSpeed > 0) {
      message += " and wind speed of ${windSpeed} km/h";
    }

    return message + ".";
  }

  static String _getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return "clear sky";
      case 1:
      case 2:
      case 3:
        return "partly cloudy";
      case 45:
      case 48:
        return "foggy";
      case 51:
      case 53:
      case 55:
        return "drizzly";
      case 61:
      case 63:
      case 65:
        return "rainy";
      case 71:
      case 73:
      case 75:
        return "snowy";
      case 95:
      case 96:
      case 99:
        return "thunderstorms";
      default:
        return "variable conditions";
    }
  }

  // REQUEST TYPE CHECKING METHODS
  static bool _isTimeRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('time') || lowerCommand.contains('clock');
  }

  static bool _isWeatherRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('weather') ||
        lowerCommand.contains('temperature');
  }

  static bool _isMusicRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('play') ||
        lowerCommand.contains('music') ||
        lowerCommand.contains('song');
  }

  static bool _isJokeRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('joke') || lowerCommand.contains('funny');
  }

  static bool _isHelpRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('help') ||
        lowerCommand.contains('what can you do');
  }

  static bool _isGreetingRequest(String command) {
    final lowerCommand = command.toLowerCase();
    return lowerCommand.contains('hello') ||
        lowerCommand.contains('hi') ||
        lowerCommand.contains('hey');
  }

  // ORIGINAL METHODS FOR COMPATIBILITY
  static Future<Map<String, dynamic>> updateAssistantName(
    String newName,
  ) async {
    return {
      'status': 'success',
      'message': 'Assistant name updated to $newName',
    };
  }

  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print("Testing connection to Flutter Gemini API...");

      if (!_isInitialized) {
        return {
          'status': 'error',
          'message': 'Gemini not initialized. Please check your API key.',
        };
      }

      await _checkRateLimit(); // Apply rate limiting to test too

      final gemini = Gemini.instance;
      final response = await gemini
          .prompt(
            parts: [
              Part.text(
                "Hello, respond with just 'Hello' to test the connection",
              ),
            ],
          )
          .timeout(Duration(seconds: 10));

      if (response?.output != null && response!.output!.isNotEmpty) {
        return {
          'status': 'success',
          'message':
              'Flutter Gemini API is working perfectly! Response: ${response.output}',
        };
      } else {
        return {
          'status': 'error',
          'message': 'API responded but with empty content',
        };
      }
    } on TimeoutException {
      return {
        'status': 'timeout',
        'message': 'Connection test timed out. Check your internet connection.',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection test failed: ${e.toString()}',
      };
    }
  }

  static Map<String, dynamic> getOfflineResponse(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('calculate') || lowerCommand.contains('math')) {
      return {
        'status': 'success',
        'message':
            'I can help with basic math! Try asking me something like "what is 25 plus 17" or "calculate 50 times 2".',
        'type': 'calculation',
      };
    } else {
      final responses = [
        'I\'m currently in offline mode, but I can still help with basic tasks!',
        'That\'s interesting! In offline mode, I have limited capabilities, but I\'m here to help.',
        'I\'d love to help you with that! Try switching to online mode for more advanced responses.',
        'Thanks for talking with me! I can do more when connected to the internet.',
      ];
      final randomResponse =
          responses[DateTime.now().millisecond % responses.length];
      return {
        'status': 'success',
        'message': randomResponse,
        'type': 'offline',
      };
    }
  }

  // Additional methods for joke service compatibility
  static Future<Map<String, dynamic>> testJokeApi() async {
    try {
      final isWorking = await JokeService.testApiConnection();
      if (isWorking) {
        return {
          'status': 'success',
          'message': 'Joke API is working perfectly!',
        };
      } else {
        return {
          'status': 'error',
          'message': 'Joke API is not responding, using fallback jokes.',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Joke API test failed: $e'};
    }
  }

  static Map<String, dynamic> getJokeStatistics() {
    return JokeService.getJokeStats();
  }

  static void clearJokeMemory() {
    JokeService.clearJokeMemory();
  }

  // ✅ SOLUTION 4: Get API usage statistics
  static Map<String, dynamic> getApiUsageStats() {
    return {
      'currentApiKey': _currentKeyIndex + 1,
      'totalApiKeys': apiKeys.length,
      'requestsThisMinute': _requestCount,
      'lastRequestTime': _lastRequest?.toIso8601String(),
      'maxRequestsPerMinute': maxRequestsPerMinute,
    };
  }
}
