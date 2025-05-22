import 'package:flutter/material.dart';
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
                  SizedBox(
                    height: 20,
                  ), //Adds vertical space (20 pixels) between widgets. Used here to separate the email and password fields.
                  NeonPasswordField(controller: _passwordController),
                  SizedBox(height: 10),

                  ElevatedButton(
                    // create new account button
                    onPressed:
                        () => {Navigator.pushNamed(context, '/registration')},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Text(
                      "create new account",
                      style: const TextStyle(
                        color: Color.fromRGBO(202, 240, 246, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  //Adds vertical space (20 pixels) between widgets. Used her
                  // Login button
                  XPFitButton(
                    text: 'Login',
                    onPressed: () => {
                      Navigator.pushNamed(context, '/home')
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
