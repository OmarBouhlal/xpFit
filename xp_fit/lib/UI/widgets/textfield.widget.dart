import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Neon-styled text input field
class NeonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboard;
  final bool digitsOnly;

  const NeonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboard = TextInputType.text,
    this.digitsOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters:
          digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyanAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }
}

/// Neon-styled password field with visibility toggle
class NeonPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const NeonPasswordField({super.key, required this.controller});

  @override
  State<NeonPasswordField> createState() => _NeonPasswordFieldState();
}

class _NeonPasswordFieldState extends State<NeonPasswordField> {
  bool notVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: notVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.cyanAccent),
        suffixIcon: IconButton(
          icon: Icon(
            notVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.cyanAccent,
          ),
          onPressed: () {
            setState(() {
              notVisible = !notVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }
}
