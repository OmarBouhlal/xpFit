import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../API/nutrition.api.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);
  late Future<Map<String, dynamic>> _mealPlanFuture;
  late Future<Duration?> _cacheAgeFuture;
  final Set<int> _favoriteMealIds = {};
  final Map<String, bool> _isExpandedMap = {};

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  void _showNutritionLabelImage(BuildContext context, int idRecipe) async {
    final nutritionLabelURL = NutritionAPI.getNutritionLabelUrl(idRecipe);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(nutritionLabelURL),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: themeColor)),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(int mealId) {
    setState(() {
      if (_favoriteMealIds.contains(mealId)) {
        _favoriteMealIds.remove(mealId);
      } else {
        _favoriteMealIds.add(mealId);
      }
    });
  }

  Future<Map<String, dynamic>> _loadMealPlanWithAutoRefresh() async {
    final cacheAge = await NutritionAPI.getCacheAge();
    final bool shouldRefresh = cacheAge == null || cacheAge.inDays >= 7;
    return await NutritionAPI.getWeeklyMealPlan(forceRefresh: shouldRefresh);
  }

  @override
  void initState() {
    super.initState();
    _mealPlanFuture = _loadMealPlanWithAutoRefresh();
    _cacheAgeFuture = NutritionAPI.getCacheAge();
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
          title: Text(
            "Weekly Meal Plan",
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'RaleWay',
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 5,
          foregroundColor: themeColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _mealPlanFuture,
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
                    // ça veut dire que snapshot contient la donnée (snapshot.hasData)
                    final weekData = snapshot.data!;

                    // ! explanation :  "I’m sure this value is NOT null, even though Dart’s type system can’t guarantee it. Trust me, and proceed without null checks."
                    return ListView(
                      children:
                          weekData.entries.map((entry) {
                            final day = entry.key;
                            final meals = entry.value['meals'] as List<dynamic>;
                            final nutrients =
                                entry.value['nutrients'] as dynamic;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide.none,
                              ),
                              elevation: 5,
                              color: Colors.black87,
                              margin: EdgeInsets.all(10),
                              child: ExpansionTile(
                                onExpansionChanged:
                                    (expanded) => setState(
                                      () => _isExpandedMap[day] = expanded,
                                    ),
                                trailing: Icon(
                                  _isExpandedMap[day] ?? false
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color:
                                      _isExpandedMap[day] ?? false
                                          ? Colors.red.shade400
                                          : Colors.blue,
                                ),
                                title: Text(
                                  day.toUpperCase(),
                                  style: TextStyle(
                                    color: themeColor,
                                    shadows: [
                                      Shadow(
                                        color: Colors.blue.shade900,
                                        blurRadius: 15.0,
                                      ),
                                      Shadow(
                                        color: Colors.blueAccent.withOpacity(
                                          0.3,
                                        ),
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
                                      'calories: ${nutrients['calories'].floor()}',
                                    ),
                                    const SizedBox(width: 5),
                                    Image.asset(
                                      'assets/protein.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(
                                      'proteins: ${nutrients['protein'].floor()}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Image.asset(
                                      'assets/butter.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(
                                      'fat: ${nutrients['fat'].floor()}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                expansionAnimationStyle: AnimationStyle(
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(milliseconds: 350),
                                  reverseDuration: const Duration(
                                    milliseconds: 200,
                                  ),
                                ),
                                children:
                                    meals.map((meal) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0.0,
                                            ),
                                            child: Text(
                                              meal['title'],
                                              style: GoogleFonts.salsa(
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          subtitle: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Ready in ',
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${meal['readyInMinutes']} min',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ), // the dynamic value will look slightly bolder in terms of font weight
                                                ),
                                              ],
                                              style: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          leading: GestureDetector(
                                            onTap:
                                                () => _showNutritionLabelImage(
                                                  context,
                                                  meal['id'],
                                                ),
                                            child: Image.network(
                                              'https://spoonacular.com/recipeImages/${meal['image']}',
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              filterQuality:
                                                  FilterQuality.medium,
                                              errorBuilder:
                                                  (_, __, ___) => Icon(
                                                    Icons.image_not_supported,
                                                    color: themeColor,
                                                  ),
                                            ),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                child: IconButton(
                                                  onPressed:
                                                      () => _launchURL(
                                                        'https://spoonacular.com/recipes/${meal['image'].split('.')[0]}',
                                                      ),
                                                  icon: Icon(
                                                    Icons.arrow_outward,
                                                    color: Colors.blue.shade300,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: IconButton(
                                                  onPressed:
                                                      () => _toggleFavorite(
                                                        meal['id'],
                                                      ),
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color:
                                                        _favoriteMealIds
                                                                .contains(
                                                                  meal['id'],
                                                                )
                                                            ? Color.fromARGB(
                                                              255,
                                                              82,
                                                              229,
                                                              255,
                                                            )
                                                            : null,
                                                  ),
                                                ),
                                              ),
                                            ],
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
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: themeColor),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
                IconButton(
                  icon: Icon(Icons.restaurant, color: themeColor),
                  onPressed: (){
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercice');
                  },
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
