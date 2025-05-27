import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xp_fit/DB/db_helper.dart';
import '../../API/exercice.api.dart';



class ExercicePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercicePage> {

  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  String selectedMuscle = 'biceps';
  List<dynamic> targets = [];

  Future<void> loadInitialData() async {
  try {

    final targetList = await ExerciceAPI.fetchTargets();
    final exerciseList = await ExerciceAPI.fetchExercises(selectedMuscle);

    setState(() {
      targets = targetList;
      exercises = exerciseList;
      isLoading = false;
    });
  } catch (e) {
    print('Error: $e');
  }
}


@override
void initState() {
  super.initState();
  loadInitialData();
}
  @override
  Widget build(BuildContext context) {

    //user email that enable us to identify the user to send it back as argument to the home or loved page
    final emailRetrieve = ModalRoute.of(context)!.settings.arguments as String;

    final Color themeColor =  const Color.fromARGB(232, 163, 218, 246);

    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0A1D37),
                    Color(0xFF1E3C72),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Target:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132A47),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF132A47),
                          iconEnabledColor: Colors.blueAccent,
                          value: selectedMuscle,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white),
                          items: targets.map((muscle) {
                            return DropdownMenuItem<String>(
                              value: muscle,
                              child: Text(
                                muscle.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              selectedMuscle = newValue!;
                              isLoading = true;
                            });

                            final newExercises = await ExerciceAPI.fetchExercises(selectedMuscle);

                            setState(() {
                              exercises = newExercises;
                              isLoading = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return ExerciseCard(exercise: exercise, email :emailRetrieve);
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(context).copyWith(canvasColor: const Color.fromARGB(0, 0, 0, 0)),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home',arguments: emailRetrieve);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.restaurant, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/nutrition',arguments:emailRetrieve);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercice',arguments: emailRetrieve);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/favourite',arguments: emailRetrieve);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ExerciseCard extends StatefulWidget {
  final dynamic exercise;
  final String email;

  const ExerciseCard({super.key, required this.exercise , required this.email});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isFavorite = false;

  void toggleFavorite() {
    DBHelper.addExercice(widget.email , widget.exercise["id"].toString() , widget.exercise["name"].toString(), widget.exercise["gifUrl"].toString(), widget.exercise["instructions"]);
    setState(() {
      isFavorite = !isFavorite;
      //print("itouuuuuub");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF121E3C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                widget.exercise['name'].toString().toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              content: Text(
                'Instructions:\n${widget.exercise['instructions'] ?? 'No instructions available.'}',
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('DONE', style: TextStyle(color: Colors.blueAccent)),
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
              colors: [
                Color(0xFF0A1D37),
                Color(0xFF1E3C72),
              ],
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.exercise['name'].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Equipment: ${widget.exercise['equipment']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              //heart
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: toggleFavorite,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color.fromARGB(255, 82, 160, 255) : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
