import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionAPI {
  static const String _baseUrl = 'https://api.spoonacular.com';
  static const String _apiKey = 'c8b24334f7274ced82a6ffa308d0f197';

  static Future<Map<String, dynamic>> getWeeklyMealPlan() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${_baseUrl}/mealplanner/generate?timeFrame=week'
          '&apiKey=${_apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['week'];
      } else {
        throw Exception('Failed to load meal plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static String getNutritionLabelUrl(int recipeId) {
    return 'https://api.spoonacular.com/recipes/$recipeId/nutritionLabel.png?apiKey=$_apiKey';
  }
}
