import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:xp_fit/main.dart';

class DailyQuestSelectorWidget extends StatefulWidget {
  const DailyQuestSelectorWidget({super.key});

  @override
  State<DailyQuestSelectorWidget> createState() =>
      _DailyQuestSelectorWidgetState();
}

class _DailyQuestSelectorWidgetState extends State<DailyQuestSelectorWidget> {
  final List<String> allExercises = [
    'Pushups',
    'Squats',
    'Running',
    'Plank',
    'Stretching',
    'Jump Rope',
    'Yoga',
    'Cycling',
    'Burpees',
    'Lunges',
    'Mountain Climbers',
    'Pull-ups',
  ];

  List<String> displayedExercises = [
    'Pushups',
    'Squats',
    'Running',
    'Plank',
  ]; // Initially displayed exercises

  List<String> selectedQuests = [];

  void _showRemainingExercises() {
    final List<String> remainingExercises = allExercises
        .where((exercise) => !displayedExercises.contains(exercise))
        .toList();

    // Check if there are any remaining exercises
    if (remainingExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All exercises are already displayed!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121E3C),
          title: const Text(
            'Add More Exercises',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: remainingExercises.length,
              itemBuilder: (BuildContext context, int index) {
                final exercise = remainingExercises[index];
                return Card(
                  color: const Color(0xFF1E2A4A),
                  child: ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      exercise,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.add,
                      color: Colors.greenAccent,
                    ),
                    onTap: () {
                      print('Tapped on: $exercise'); // Debug print
                      print('Before adding - displayedExercises: $displayedExercises'); // Debug print
                      
                      Navigator.of(dialogContext).pop();
                      
                      // Use a post-frame callback to ensure the dialog is closed first
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            displayedExercises.add(exercise);
                            print('After adding - displayedExercises: $displayedExercises'); // Debug print
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$exercise added to your exercises!'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }


  //current daily quests check handling
  Widget _buildQuestTile(String title) {
    final bool isSelected = selectedQuests.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedQuests.remove(title);
          } else {
            selectedQuests.add(title);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add remove button for displayed exercises (except the initial 4)
                if (!['Pushups', 'Squats', 'Running', 'Plank'].contains(title))
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        displayedExercises.remove(title);
                        selectedQuests.remove(title); // Also remove from selected if it was selected
                      });
                    },
                  ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.greenAccent : Colors.white54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121E3C),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.fitness_center, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "DAILY QUEST SELECTOR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: _showRemainingExercises,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Displayed exercises
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Available Exercises:", style: TextStyle(color: Colors.white70)),
              Text(
                "${displayedExercises.length}/${allExercises.length}",
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...displayedExercises.map(_buildQuestTile),

          const SizedBox(height: 16),
          Center(
            child: Text(
              selectedQuests.isEmpty 
                ? "Select exercises for your daily quest. Tap '+' to add more."
                : "Selected: ${selectedQuests.length} exercise${selectedQuests.length == 1 ? '' : 's'}",
              style: TextStyle(
                color: selectedQuests.isEmpty ? Colors.white60 : Colors.greenAccent,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}