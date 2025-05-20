import 'package:flutter/material.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';
import 'package:xp_fit/UI/widgets/textfield.widget.dart';
import 'package:xp_fit/DB/db_helper.dart';

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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 53, 174, 255)],
            begin: Alignment.topCenter,
            end: Alignment(0.0, 5.0),
          ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  NeonTextField(
                    controller: _usernameController,
                    label: 'Username',
                  ),
      
                  const SizedBox(height: 16),
      
                  NeonTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboard: TextInputType.emailAddress,
                  ),
      
                  const SizedBox(height: 16),
                  
                  NeonPasswordField(
                    controller: _passwordController,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  NeonTextField(
                    controller: _weightController,
                    label: 'Weight (kg)',
                    keyboard: TextInputType.number,
                    digitsOnly: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  NeonTextField(
                    controller: _heightController,
                    label: 'Height (kg)',
                    keyboard: TextInputType.number,
                    digitsOnly: true,
                  ),                
                  
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
                      onPressed: () async {
                        // Handle registration logic here
                        final username = _usernameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        final weight = double.tryParse(_weightController.text);
                        final height = double.tryParse(_heightController.text);
                        final gender = _selectedGender;
                        final birthDate = _selectedBirthDate?.toIso8601String();

                        if (username.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            weight == null ||
                            height == null ||
                            gender == null ||
                            birthDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all fields correctly.")),
                          );
                          return;
                        }

                        await DBHelper.registration(
                          username,
                          email,
                          password,
                          weight,
                          height,
                          birthDate,
                          gender,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration successful!")),
                        );
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      
                    ),
                  ),
      
                ],
              ),
            ),
          ),
        ),
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
