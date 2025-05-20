import 'package:flutter/material.dart';
import 'package:xp_fit/UI/pages/auth/login.page.dart';

import 'package:xp_fit/UI/pages/auth/register.page.dart';
import 'package:xp_fit/UI/pages/home.page.dart';
import 'package:xp_fit/UI/pages/nutrition.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoginPage(),
        "/registration" : (context) => RegisterPage(),
        "/home" : (context) => HomePage(),
        "/nutrition" : (context) => NutritionPage(),
        },
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: "/",
    );
  }
}
