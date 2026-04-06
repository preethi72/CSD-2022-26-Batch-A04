import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  // Launch URL in external browser
  static Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
      throw e;
    }
  }

  // Show snackbar message
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor ?? Colors.cyan,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Save data to SharedPreferences
  static Future<void> saveData(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Get data from SharedPreferences
  static Future<String?> getData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print('Error getting data: $e');
      return null;
    }
  }

  // Format time for display
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  // Format date for display
  static String formatDate(DateTime dateTime) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = days[dateTime.weekday - 1];
    final monthName = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;

    return '$dayName, $monthName $day, $year';
  }

  // Validate URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Extract command keywords
  static List<String> extractKeywords(String command) {
    final stopWords = {
      'the',
      'a',
      'an',
      'and',
      'or',
      'but',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'from',
      'about',
      'into',
      'through',
      'during',
      'before',
      'after',
      'above',
      'below',
      'up',
      'down',
      'out',
      'off',
      'over',
      'under',
      'again',
      'further',
      'then',
      'once',
      'can',
      'could',
      'should',
      'would',
      'will',
      'shall',
      'may',
      'might',
      'must',
      'ought',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'get',
      'got',
      'make',
      'made',
      'take',
      'took',
      'give',
      'gave',
      'go',
      'went',
      'come',
      'came',
      'see',
      'saw',
      'know',
      'knew',
      'think',
      'thought',
      'say',
      'said',
      'tell',
      'told',
    };

    return command
        .toLowerCase()
        .split(RegExp(r'\W+'))
        .where((word) => word.isNotEmpty && !stopWords.contains(word))
        .toList();
  }

  // Generate color from string (for user avatars, etc.)
  static Color generateColorFromString(String text) {
    int hash = text.hashCode;
    return Color((hash & 0xFFFFFF) | 0xFF000000);
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  // Check if string contains any of the keywords
  static bool containsAnyKeyword(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword.toLowerCase()));
  }

  // Convert temperature units
  static String convertTemperature(
    double celsius, {
    bool toFahrenheit = false,
  }) {
    if (toFahrenheit) {
      final fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
    return '${celsius.toStringAsFixed(1)}°C';
  }

  // Parse command type from text
  static String getCommandType(String command) {
    final lowerCommand = command.toLowerCase();

    if (containsAnyKeyword(lowerCommand, [
      'weather',
      'temperature',
      'rain',
      'sunny',
      'cloudy',
      'forecast',
    ])) {
      return 'weather';
    } else if (containsAnyKeyword(lowerCommand, [
      'time',
      'clock',
      'hour',
      'minute',
      'date',
      'today',
      'day',
    ])) {
      return 'time';
    } else if (containsAnyKeyword(lowerCommand, [
      'play',
      'music',
      'song',
      'youtube',
      'video',
    ])) {
      return 'youtube';
    } else if (containsAnyKeyword(lowerCommand, [
      'find',
      'search',
      'open',
      'file',
      'folder',
      'document',
    ])) {
      return 'file_search';
    } else if (containsAnyKeyword(lowerCommand, [
      'joke',
      'funny',
      'laugh',
      'humor',
    ])) {
      return 'joke';
    } else if (containsAnyKeyword(lowerCommand, [
      'hello',
      'hi',
      'hey',
      'good morning',
      'good evening',
    ])) {
      return 'greeting';
    } else if (containsAnyKeyword(lowerCommand, [
      'thank',
      'thanks',
      'bye',
      'goodbye',
      'see you',
    ])) {
      return 'farewell';
    }

    return 'general';
  }
}
