import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NutritionAPI {
  static const String _baseUrl = 'https://api.spoonacular.com';
  static const String _apiKey = 'fe09bfe53b5b428ea00e0a87bd3b8207';
  static const String _cacheKey = 'weekly_meal_plan_cache';
  static const Duration _cacheDuration = Duration(days: 7);

  static Future<Map<String, dynamic>> getWeeklyMealPlan({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Return cached data if valid and not forcing refresh
    if (!forceRefresh && prefs.containsKey(_cacheKey)) {
      final cachedData = json.decode(prefs.getString(_cacheKey)!);
      final cachedTime = DateTime.parse(cachedData['timestamp']);

      if (DateTime.now().difference(cachedTime) < _cacheDuration) {
        return cachedData['data'];
      }
    }

    // Fetch fresh data from API
    try {
      final response = await http.get(
        Uri.parse(
          '${_baseUrl}/mealplanner/generate?timeFrame=week&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final freshData = json.decode(response.body)['week'];

        // Cache the new data
        await prefs.setString(
          _cacheKey,
          json.encode({
            'timestamp': DateTime.now().toIso8601String(),
            'data': freshData,
          }),
        );

        return freshData;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cached data if available
      if (prefs.containsKey(_cacheKey)) {
        final cachedData = json.decode(prefs.getString(_cacheKey)!);
        return cachedData['data'];
      }
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  static String getNutritionLabelUrl(int recipeId) {
    return '$_baseUrl/recipes/$recipeId/nutritionLabel.png?apiKey=$_apiKey';
  }

  // Optional: Get cache age info
  static Future<Duration?> getCacheAge() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_cacheKey)) {
      final cachedData = json.decode(prefs.getString(_cacheKey)!);
      return DateTime.now().difference(DateTime.parse(cachedData['timestamp']));
    }
    return null;
  }
}
