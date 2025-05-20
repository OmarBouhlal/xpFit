import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // Set default brightness to dark for better contrast on dark backgrounds
      brightness: Brightness.dark,
      // Make app bar theme transparent
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      // Make scaffoldBackgroundColor transparent to allow Container gradient to show
      scaffoldBackgroundColor: Colors.transparent,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background container that will be underneath everything
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 53, 174, 255)],
          begin: Alignment.topCenter,
          end: Alignment(0.0, 5.0),
        ),
      ),
      // Scaffold inside the container with a transparent background
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make scaffold background transparent
        appBar: AppBar(
            title: Text(
            'Home Page',
            style: TextStyle(color: Color.fromRGBO(80, 140, 155,1)),
            ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Welcome to the Home Page!',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: const  Color.fromRGBO(80, 140, 155,1)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const  Color.fromRGBO(80, 140, 155,1)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: const  Color.fromRGBO(80, 140, 155,1)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: const  Color.fromRGBO(80, 140, 155,1)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}