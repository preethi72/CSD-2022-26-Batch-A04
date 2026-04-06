import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JokeService {
  static final Set<String> _usedJokes = <String>{};

  static final List<String> _fallbackJokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't programmers like nature? It has too many bugs!",
    "Why did the math book look so sad? Because it was full of problems!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why don't some couples go to the gym? Because some relationships don't work out!",
    "What do you call a fake noodle? An impasta!",
    "Why did the coffee file a police report? It got mugged!",
    "What do you call a dinosaur that crashes his car? Tyrannosaurus Wrecks!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a fish wearing a bowtie? Sofishticated!",
    "Why did the bicycle fall over? Because it was two tired!",
    "What do you call a cow with no legs? Ground beef!",
    "Why don't scientists trust stairs? Because they're always up to something!",
    "Why did the tomato turn red? Because it saw the salad dressing!",
    "What do you call a belt made of watches? A waist of time!",
    "Why don't oysters donate? Because they are shellfish!",
    "What do you call a group of disorganized cats? A cat-astrophe!",
    "What do you call a dinosaur that loves to sleep? A dino-snore!",
    "Why did the golfer bring two pairs of pants? In case he got a hole in one!",
    "What do you call a factory that makes okay products? A satisfactory!",
    "Why don't scientists trust the ocean? Because it's too salty!",
    "What do you call a bee that can't make up its mind? A maybe!",
    "Why did the cookie go to the doctor? Because it felt crumbly!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't elephants use computers? They're afraid of the mouse!",
    "What do you call a sleeping bull in a library? A bull-dozer!",
    "Why don't scientists trust pencils? Because they have too many points!",
    "What do you call a fish that wears a crown? A king-fish!",
    "Why did the banana go to the doctor? It wasn't peeling well!",
    "Why don't clouds ever get speeding tickets? They're always drifting!",
    "What do you call a fake stone? A shamrock!",
    "Why did the computer go to the doctor? It had a virus!",
    "What do you call a bear in the rain? A drizzly bear!",
    "Why don't scientists trust the stairs? They're always up to something!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the math teacher break up with the biology teacher? There was no chemistry!",
    "What do you call a cat that works for the Red Cross? A first-aid kit!",
  ];

  /// Generate a new joke using external API with fallback
  static Future<String> generateJoke(
    String languageCode,
    bool isOnlineMode,
  ) async {
    try {
      if (!isOnlineMode) {
        return getRandomFallbackJoke();
      }

      // Try to fetch from external API first
      String? apiJoke = await _fetchExternalJoke();

      if (apiJoke != null && apiJoke.isNotEmpty) {
        // Check if this joke was used before
        if (_usedJokes.contains(apiJoke.toLowerCase())) {
          print("🔄 API joke already used, trying again...");

          // Try one more time
          apiJoke = await _fetchExternalJoke();
          if (apiJoke != null &&
              apiJoke.isNotEmpty &&
              !_usedJokes.contains(apiJoke.toLowerCase())) {
            _usedJokes.add(apiJoke.toLowerCase());
            _manageLimitedMemory();
            return apiJoke;
          }
        } else {
          // New joke from API, add to memory
          _usedJokes.add(apiJoke.toLowerCase());
          _manageLimitedMemory();
          return apiJoke;
        }
      }

      // If API fails, use fallback
      print("⚠️ External API failed, using fallback jokes");
      return getRandomFallbackJoke();
    } catch (e) {
      print("❌ Error generating joke: $e");
      return getRandomFallbackJoke();
    }
  }

  /// Fetch joke from external API
  static Future<String?> _fetchExternalJoke() async {
    try {
      print("🌐 Fetching joke from external API...");

      final response = await http
          .get(
            Uri.parse("https://official-joke-api.appspot.com/random_joke"),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'JARVIS-Voice-Assistant/1.0',
            },
          )
          .timeout(Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final setup = data["setup"]?.toString().trim() ?? "";
        final punchline = data["punchline"]?.toString().trim() ?? "";

        if (setup.isNotEmpty && punchline.isNotEmpty) {
          final joke = "$setup $punchline";
          print("✅ External API joke fetched successfully");
          return joke;
        } else {
          print("❌ Invalid joke format from API");
        }
      } else {
        print("❌ External API returned status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ External API error: $e");
    }
    return null;
  }

  /// Fetch multiple jokes for batch loading
  static Future<List<String>> fetchMultipleJokes(
    int count,
    bool isOnlineMode,
  ) async {
    final jokes = <String>[];

    if (!isOnlineMode) {
      // Return multiple fallback jokes
      for (int i = 0; i < count; i++) {
        jokes.add(getRandomFallbackJoke());
      }
      return jokes;
    }

    print("🌐 Fetching $count jokes from external API...");

    for (int i = 0; i < count; i++) {
      try {
        final joke = await _fetchExternalJoke();
        if (joke != null && joke.isNotEmpty) {
          // Check for duplicates
          if (!jokes.any(
            (existingJoke) => existingJoke.toLowerCase() == joke.toLowerCase(),
          )) {
            jokes.add(joke);
            _usedJokes.add(joke.toLowerCase());
          }
        }

        // Small delay between requests to be respectful to the API
        if (i < count - 1) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      } catch (e) {
        print("❌ Error fetching joke $i: $e");
        // Add fallback joke if API fails
        jokes.add(getRandomFallbackJoke());
      }
    }

    _manageLimitedMemory();
    print("✅ Fetched ${jokes.length} jokes successfully");
    return jokes;
  }

  /// Get a random fallback joke that hasn't been used recently
  static String getRandomFallbackJoke() {
    // Filter out recently used jokes
    final availableJokes = _fallbackJokes
        .where((joke) => !_usedJokes.contains(joke.toLowerCase()))
        .toList();

    String selectedJoke;
    if (availableJokes.isNotEmpty) {
      selectedJoke = availableJokes[Random().nextInt(availableJokes.length)];
    } else {
      // If all jokes have been used, clear memory and start fresh
      print("🔄 All fallback jokes used, clearing memory...");
      _usedJokes.clear();
      selectedJoke = _fallbackJokes[Random().nextInt(_fallbackJokes.length)];
    }

    _usedJokes.add(selectedJoke.toLowerCase());
    _manageLimitedMemory();
    return selectedJoke;
  }

  /// Check what type of joke the user wants (for future categorization)
  static String getSpecificJokeCategory(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('dad joke') ||
        lowerCommand.contains('dad humor')) {
      return 'dad jokes';
    } else if (lowerCommand.contains('programming') ||
        lowerCommand.contains('coding') ||
        lowerCommand.contains('developer')) {
      return 'programming';
    } else if (lowerCommand.contains('science')) {
      return 'science';
    } else if (lowerCommand.contains('animal')) {
      return 'animals';
    } else if (lowerCommand.contains('food')) {
      return 'food';
    } else if (lowerCommand.contains('pun')) {
      return 'puns';
    } else if (lowerCommand.contains('clean') ||
        lowerCommand.contains('family')) {
      return 'clean';
    } else {
      return 'general';
    }
  }

  /// Manage memory to prevent unlimited growth
  static void _manageLimitedMemory() {
    // Keep only the last 100 jokes in memory to prevent unlimited growth
    if (_usedJokes.length > 100) {
      final jokesList = _usedJokes.toList();
      _usedJokes.clear();
      // Keep the most recent 50 jokes
      _usedJokes.addAll(jokesList.skip(jokesList.length - 50));
      print("🧹 Joke memory cleaned - keeping last 50 jokes");
    }
  }

  /// Get statistics about joke usage
  static Map<String, dynamic> getJokeStats() {
    return {
      'totalJokesGenerated': _usedJokes.length,
      'memorySize': _usedJokes.length,
      'availableFallbackJokes': _fallbackJokes.length,
      'unusedFallbackJokes': _fallbackJokes
          .where((joke) => !_usedJokes.contains(joke.toLowerCase()))
          .length,
    };
  }

  /// Clear joke memory (useful for testing or reset)
  static void clearJokeMemory() {
    _usedJokes.clear();
    print("🔄 Joke memory cleared");
  }

  /// Test the external API connection
  static Future<bool> testApiConnection() async {
    try {
      print("🧪 Testing external joke API connection...");
      final joke = await _fetchExternalJoke();
      if (joke != null && joke.isNotEmpty) {
        print("✅ External joke API is working!");
        return true;
      } else {
        print("❌ External joke API test failed");
        return false;
      }
    } catch (e) {
      print("❌ External joke API test error: $e");
      return false;
    }
  }

  /// Get a specific type of joke (if the API supports categories in the future)
  static Future<String?> getSpecificJoke(String type, bool isOnlineMode) async {
    // For now, the free API doesn't support categories, so we just return a random joke
    // But we can extend this in the future
    return await generateJoke('en_US', isOnlineMode);
  }

  /// Preload jokes for better performance
  static Future<void> preloadJokes({int count = 5}) async {
    try {
      print("🚀 Preloading $count jokes...");
      final jokes = await fetchMultipleJokes(count, true);
      print("✅ Preloaded ${jokes.length} jokes successfully");
    } catch (e) {
      print("❌ Error preloading jokes: $e");
    }
  }
}
