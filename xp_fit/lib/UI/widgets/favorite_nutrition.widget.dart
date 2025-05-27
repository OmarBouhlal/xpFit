import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xp_fit/UI/pages/nutrition.page.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';

class FavoriteNutrition extends StatefulWidget {
  final dynamic filteredElement;
  const FavoriteNutrition({super.key, this.filteredElement});
  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  State<FavoriteNutrition> createState() => _FavoriteNutritionState();
}

class _FavoriteNutritionState extends State<FavoriteNutrition> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF121E3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                widget.filteredElement['title'].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              content: XPFitButton(
                text: 'See MORE',
                onPressed:
                    () => {
                      widget._launchURL(
                        'https://spoonacular.com/recipes/${widget.filteredElement['image'].split('.')[0]}',
                      ),
                    },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFF0A1D37),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF0A1D37), Color(0xFF1E3C72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 140,
                        height: 125,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: Image.network(
                              'https://spoonacular.com/recipeImages/${widget.filteredElement['image']}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      widget.filteredElement['title'].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              //heart
            ],
          ),
        ),
      ),
    );
  }
}
