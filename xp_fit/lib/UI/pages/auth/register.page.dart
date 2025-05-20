import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? _selectedGender;
  bool notVisible = true;
  DateTime? _selectedBirthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 10),
                Text(
                  'XP-FIT',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.cyanAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _neonTextField(_usernameController, 'Username'),
                const SizedBox(height: 16),
                _neonTextField(_emailController, 'Email', keyboard: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _neonPasswordField(),
                const SizedBox(height: 16),
                _neonTextField(_weightController, 'Weight (kg)', digitsOnly: true),
                const SizedBox(height: 16),
                _neonTextField(_heightController, 'Height (cm)', digitsOnly: true),
                const SizedBox(height: 16),
                _birthDatePicker(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _genderOption("male", "Male"),
                    const SizedBox(width: 20),
                    _genderOption("female", "Female"),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: XPFitButton(
                    text: 'Register',
                    onPressed: () {
                      // Handle registration logic here
                      //print("Register button pressed!");
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _neonTextField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text, bool digitsOnly = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
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

  Widget _neonPasswordField() {
    return TextField(
      controller: _passwordController,
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

  Widget _genderOption(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedGender,
          activeColor: Colors.cyanAccent,
          onChanged: (val) {
            setState(() {
              _selectedGender = val;
            });
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _birthDatePicker() {
    return GestureDetector(
      onTap: _pickBirthDate,
      child: AbsorbPointer(
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Birth Date',
            labelStyle: const TextStyle(color: Colors.cyanAccent),
            hintText: _selectedBirthDate == null
                ? 'Tap to select'
                : '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}',
            hintStyle: const TextStyle(color: Colors.white70),
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
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF0D1B2A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0D1B2A),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }
}
