import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xp_fit/UI/pages/auth/login.page.dart';

import 'package:xp_fit/UI/pages/auth/register.page.dart';
import 'package:xp_fit/UI/pages/chatbot.page.dart';
import 'package:xp_fit/UI/pages/exercice.page.dart';
import 'package:xp_fit/UI/pages/favorites.page.dart';
import 'package:xp_fit/UI/pages/home.page.dart';
import 'package:xp_fit/UI/pages/nutrition.page.dart';
import 'package:xp_fit/UI/pages/avatar_selection.page.dart'; // Ensure this is the correct path



Future<void> main() async {
  await dotenv.load(); // Load .env before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => LoginPage(),
        "/nutrition": (context) => NutritionPage(),
        "/registration": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/exercice": (context) => ExercicePage(),
        "/chooseAvatar": (context) => AvatarChoosingPage(),
        "/favourite": (context) => FavoritesPage(),
        "/chatbot" : (context) => ChatbotPage()
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      initialRoute: "/",
      
    );
    

  }
}

