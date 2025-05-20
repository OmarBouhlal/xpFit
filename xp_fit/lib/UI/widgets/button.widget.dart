import 'package:flutter/material.dart';

class XPFitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;

  const XPFitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.horizontalPadding = 30,
    this.verticalPadding = 13,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(202, 240, 246, 1),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        shadowColor: Colors.cyanAccent,
        elevation: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0D1B2A),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}