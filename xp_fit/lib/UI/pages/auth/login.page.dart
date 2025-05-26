import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xp_fit/AUTH/authservice.page.dart';
import 'package:xp_fit/DB/db_helper.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';
import 'package:xp_fit/UI/widgets/textfield.widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool notVisible = true;
  bool _isLoading = false; // Added loading state

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 0, 0, 0),
            const Color.fromARGB(255, 53, 174, 255),
          ],
          begin: Alignment.topCenter,
          end: Alignment(0.0, 5.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', height: 250),
                  NeonTextField(controller: _emailController, label: 'email'),
                  const SizedBox(height: 20),
                  NeonPasswordField(controller: _passwordController),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushNamed(context, '/registration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: const Text(
                      "create new account",
                      style: TextStyle(
                        color: Color.fromRGBO(202, 240, 246, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      )
                      : XPFitButton(text: 'Login', onPressed: _handleLogin),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    try {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Your existing validation
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields correctly.")),
        );
        return;
      }

      // Check login credentials
      final isValid = await DBHelper.checkLogin(email, password);
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
        return;
      }

      // Update auth state
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.setLoggedInUser(
        email: email,
        username: await _getUsernameFromEmail(
          email,
        ), // You'll need to implement this
      );

      // Navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String> _getUsernameFromEmail(String email) async {
    // Implement this method to fetch username from your database
    // Example:
    final db = await DBHelper.database;
    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return user.first['username'] as String;
  }
}
