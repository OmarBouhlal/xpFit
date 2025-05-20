import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        // Set default brightness to dark for better contrast on dark backgrounds
        brightness: Brightness.dark,
        // Make app bar theme transparent
        appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
        // Make scaffoldBackgroundColor transparent to allow Container gradient to show
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // XP variables
  double currentXP = 75; // Current XP points
  double maxXP = 100; // XP needed for next level
  int level = 5; // Current level

  // Your app's theme color
  final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background container that will be underneath everything
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
      // Scaffold inside the container with a transparent background
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
        appBar: AppBar(
          
          centerTitle: true, // This centers the title in the AppBar
          title: Image.network(
            'assets/sdsdff.png',
            height: 60,
            width: 60,
            
           
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0), // Height of XP bar section
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level indicator and XP text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level $level',
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${currentXP.toInt()}/${maxXP.toInt()} XP',
                        style: TextStyle(color: themeColor, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // XP Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentXP / maxXP,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SizedBox(height: 20)],
          ),
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.restaurant, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.sports_gymnastics, color: themeColor),
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
