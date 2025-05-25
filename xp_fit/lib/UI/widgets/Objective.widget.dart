import 'package:flutter/material.dart';

class PersonalQuestsWidget extends StatefulWidget {
  const PersonalQuestsWidget({super.key});

  @override
  State<PersonalQuestsWidget> createState() => _PersonalQuestsWidgetState();
}

class _PersonalQuestsWidgetState extends State<PersonalQuestsWidget> {
  double currentWeight = 75.0; // in kg
  double targetWeight = 68.0; // in kg

  final Color backgroundColor = const Color(0xFF121E3C);
  final Color borderColor = Colors.blueAccent;
  final TextStyle labelStyle = const TextStyle(color: Colors.white, fontSize: 16);
  final TextStyle valueStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

  void _editWeights() {
    final currentController = TextEditingController(text: currentWeight.toString());
    final targetController = TextEditingController(text: targetWeight.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Weights', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Current Weight (kg)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                ),
              ),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Target Weight (kg)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  currentWeight = double.tryParse(currentController.text) ?? currentWeight;
                  targetWeight = double.tryParse(targetController.text) ?? targetWeight;
                });
                Navigator.of(context).pop();
              },
              child: const Text('SAVE', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
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
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "MAIN QUEST",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _editWeights,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main weight quest
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Current Weight:", style: labelStyle),
              Text("${currentWeight.toStringAsFixed(1)} kg", style: valueStyle),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Target Weight:", style: labelStyle),
              Text("${targetWeight.toStringAsFixed(1)} kg", style: valueStyle),
            ],
          ),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              "TRACK YOUR WEIGHT DAILY TO REACH YOUR GOAL",
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
