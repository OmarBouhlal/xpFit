import 'package:flutter/material.dart';

import 'package:xp_fit/UI/pages/auth/register.page.dart';
import 'package:xp_fit/UI/pages/home.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => RegisterPage(),
        //"/nutrition" : (context) => NutritionPage(),
        },
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: "/",
    );
  }
}
