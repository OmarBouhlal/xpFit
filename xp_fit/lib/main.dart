import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xp_fit/AUTH/authservice.page.dart';
import 'package:xp_fit/UI/pages/auth/login.page.dart';

import 'package:xp_fit/UI/pages/auth/register.page.dart';
import 'package:xp_fit/UI/pages/exercice.page.dart';
import 'package:xp_fit/UI/pages/favorites.page.dart';
import 'package:xp_fit/UI/pages/home.page.dart';
import 'package:xp_fit/UI/pages/nutrition.page.dart';
import 'package:xp_fit/UI/pages/avatar_selection.page.dart'; // Ensure this is the correct path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadStoredUser();

  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => authProvider,
      child: const MyApp(),
    ),
  );
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
        "/favorites": (context) => FavoritesPage(),
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
