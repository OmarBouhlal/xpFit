import 'package:flutter/material.dart';

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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121E3C),
          title: const Text(
            'Add More Exercises',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: remainingExercises.length,
              itemBuilder: (context, index) {
                final exercise = remainingExercises[index];
                return ListTile(
                  title: Text(
                    exercise,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      displayedExercises.add(exercise);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

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
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.greenAccent : Colors.white54,
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
          const Text("Common Exercises:", style: TextStyle(color: Colors.white70)),
          ...displayedExercises.map(_buildQuestTile),

          const SizedBox(height: 16),
          Center(
            child: Text(
              "Tap the '+' icon to add more exercises.",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}