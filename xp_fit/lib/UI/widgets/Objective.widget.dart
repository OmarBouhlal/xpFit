import 'package:flutter/material.dart';
import 'package:xp_fit/DB/db_helper.dart';

class PersonalQuestsWidget extends StatefulWidget {
  final String? email;
  const PersonalQuestsWidget({super.key, required this.email});

  @override
  State<PersonalQuestsWidget> createState() => _PersonalQuestsWidgetState();
}

class _PersonalQuestsWidgetState extends State<PersonalQuestsWidget> {
  Future<double>? currentWeight;
  Future<double>? targetWeight;

  final Color backgroundColor = const Color(0xFF121E3C);
  final Color borderColor = Colors.blueAccent;
  final TextStyle labelStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  final TextStyle valueStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  void _loadWeights() {
    if (!mounted) return; // prevent setState after dispose
    setState(() {
      currentWeight = DBHelper.getCurrentWeight(widget.email!);
      targetWeight = DBHelper.getObjtWeight(widget.email!);
    });
  }

  void _editWeights() async {
    double currentValue = await currentWeight ?? 0.0;
    double targetValue = await targetWeight ?? 0.0;

    final currentController = TextEditingController(
      text: currentValue.toStringAsFixed(1),
    );
    final targetController = TextEditingController(
      text: targetValue.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Edit Weights',
            style: TextStyle(color: Colors.white),
          ),
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
              onPressed: () async {
                double? newCurrent = double.tryParse(
                  currentController.text.trim(),
                );
                double? newTarget = double.tryParse(
                  targetController.text.trim(),
                );

                if (newCurrent != null && newTarget != null) {
                  await DBHelper.modifyCurrentWeight(widget.email!, newCurrent);
                  await DBHelper.modifyObjeeWeight(widget.email!, newTarget);

                  if (mounted) _loadWeights(); // safe check here
                }

                if (context.mounted)
                  Navigator.of(context).pop(); // ensure context is valid
              },
              child: const Text(
                'SAVE',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeightRow(String label, Future<double>? futureWeight) {
    return FutureBuilder<double>(
      future: futureWeight,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              const Text("Loading...", style: TextStyle(color: Colors.white70)),
            ],
          );
        } else if (snapshot.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              Text("Error", style: TextStyle(color: Colors.redAccent)),
            ],
          );
        } else if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              Text(
                "${snapshot.data!.toStringAsFixed(1)} kg",
                style: valueStyle,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              const Text("No data", style: TextStyle(color: Colors.white70)),
            ],
          );
        }
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

          _buildWeightRow("Current Weight:", currentWeight),
          const SizedBox(height: 8),
          _buildWeightRow("Target Weight:", targetWeight),

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
