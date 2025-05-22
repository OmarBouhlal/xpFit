import 'package:flutter/material.dart';
import '../../API/nutrition.api.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  void _showImagePopup(BuildContext context, int idRecipe) async {
    try {
      final imageUrl = NutritionAPI.getNutritionLabelUrl(idRecipe);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.network(imageUrl),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load image: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 53, 174, 255),
          ],
          begin: Alignment.topCenter,
          end: Alignment(0.0, 5.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Weekly Meal Plan"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: themeColor,
        ),
        body: Stack(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: NutritionAPI.getWeeklyMealPlan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: themeColor),
                    ),
                  );
                } else {
                  final weekData = snapshot.data!;
                  return ListView(
                    children:
                        weekData.entries.map((entry) {
                          final day = entry.key;
                          final meals = entry.value['meals'] as List<dynamic>;
                          final nutrients = entry.value['nutrients'] as dynamic;
                          return Card(
                            color: Colors.black.withOpacity(0.3),
                            margin: const EdgeInsets.all(8),
                            child: ExpansionTile(
                              title: Text(
                                day.toUpperCase(),
                                style: TextStyle(
                                  color: themeColor,
                                  shadows: [
                                    Shadow(
                                      color: Colors.blue.shade900.withOpacity(
                                        0.8,
                                      ), // Deep shadow
                                      blurRadius: 15.0,
                                    ),
                                    Shadow(
                                      color: Colors.blueAccent.withOpacity(
                                        0.3,
                                      ), // Subtle glow
                                      blurRadius: 30.0,
                                    ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'RaleWay',
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'calories : ${nutrients['calories'].floor()}',
                                  ),
                                  SizedBox(width: 5),
                                  Image.asset(
                                    'assets/protein.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    'proteins: ${nutrients['protein'].floor()}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  SizedBox(width: 5),
                                  Image.asset(
                                    'assets/butter.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    'fat : ${nutrients['fat'].floor()}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              children:
                                  meals.map((meal) {
                                    return ListTile(
                                      // onTap:
                                      //     () => _launchURL(
                                      //       'https://spoonacular.com/recipes/${meal['image'].split('.')[0]}',
                                      //     ),
                                      title: Text(
                                        meal['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Ready in ${meal['readyInMinutes']} min',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      leading: GestureDetector(
                                        onTap: () {
                                          _showImagePopup(context, meal['id']);
                                        },
                                        child: Image.network(
                                          'https://spoonacular.com/recipeImages/${meal['image']}',
                                          width: 60,
                                          height: 60,
                                          filterQuality: FilterQuality.medium,
                                          errorBuilder:
                                              (_, __, ___) => Icon(
                                                Icons.image_not_supported,
                                                color: themeColor,
                                              ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed:
                                            () => _launchURL(
                                              'https://spoonacular.com/recipes/${meal['image'].split('.')[0]}',
                                            ),
                                        icon: Icon(
                                          Icons.arrow_outward,
                                          color: Colors.blue.shade300,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          );
                        }).toList(),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.restaurant, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.sports_gymnastics, color: themeColor),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
