import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  loadInitialData(); // <--- THIS IS THE MISSING CALL
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Explorer'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Row(
              children: [
                const Text("Target: ", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedMuscle,
                    isExpanded: true,
                    items: targets.map((muscle) {
                      return DropdownMenuItem<String>(
                        value: muscle,
                        child: Text(muscle.toUpperCase()),
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
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
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
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final dynamic exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              exercise['gifUrl'],
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  exercise['name'].toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Equipment: ${exercise['equipment']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
