import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xp_fit/AUTH/authservice.page.dart';
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
    final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A1D37), Color(0xFF1E3C72)],
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
                  const SizedBox(width: 20),
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
                          items:
                              targets.map((muscle) {
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

                            final newExercises =
                                await ExerciceAPI.fetchExercises(
                                  selectedMuscle,
                                );

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
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return ExerciseCard(exercise: exercise);
                        },
                      ),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(
            context,
          ).copyWith(canvasColor: const Color.fromARGB(0, 0, 0, 0)),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/nutrition');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.sports_gymnastics, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/favorites');
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

  const ExerciseCard({super.key, required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isFavorite = false;

  void addToFavoriteExercices() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userEmail = authProvider.loggedInEmail;

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save favorites')),
      );
      return;
    }

    try {
      final exerciseId = int.tryParse(widget.exercise['id'].toString()) ?? 0;
      print("i am here");
      await DBHelper.addExercice(
        userEmail,
        exerciseId,
        widget.exercise['name'].toString(), 
        widget.exercise['gifUrl']?.toString(),
        widget.exercise['instructions'].toString(),
      );

      setState(() => isFavorite = !isFavorite);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving exercise: ${e.toString()}')),
      );
    }
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
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
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    addToFavoriteExercices();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite
                              ? const Color.fromARGB(255, 82, 160, 255)
                              : Colors.white,
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
