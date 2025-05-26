import 'package:flutter/material.dart';

class FavoriteNutrition extends StatefulWidget {
  final dynamic filteredElement;
  const FavoriteNutrition({super.key,this.filteredElement});

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
/*               title: Text(
                widget.filteredElement['title'].toString().toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ), */
/*               content: Text(
                'Instructions:\n${widget.filteredElement['instructions'] ?? 'No instructions available.'}',
                style: const TextStyle(color: Colors.white70),
              ), */
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'DONE',
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
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image.network('https://spoonacular.com/recipeImages/${widget.filteredElement['image']}'),
                    Text(
                      widget.filteredElement['title'].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
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