import 'package:flutter/material.dart';

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
    return Scaffold(
        body : Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        label: Text("email"),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height:20),    //Adds vertical space (20 pixels) between widgets. Used here to separate the email and password fields.
                  TextField(
                      controller: _passwordController,
                      obscureText: notVisible,   //This is used to hide the password from the user.
                      decoration: InputDecoration(
                          hintText: "EMAIL",
                          label: Text('password'),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              notVisible==true?Icons.visibility:Icons.visibility_off,
                            ),
                            onPressed: () =>{
                              setState(() {
                                notVisible = !notVisible;
                              })
                            },
                          )
                      )
                  ),
                  SizedBox(height:20),    //Adds vertical space (20 pixels) between widgets. Used her

                  // Login button
                  ElevatedButton(
                    onPressed: ()=>{},
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),


                ],
              ),
            ),
          ),
        )
    );
  }
}