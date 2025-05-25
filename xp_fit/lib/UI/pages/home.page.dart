import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xp_fit/UI/widgets/Objective.widget.dart';
import 'package:xp_fit/UI/widgets//DailyQuest.widget.dart';

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

  // User's name
  String userName = "Sung Jin Woo"; // Default user name

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
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.end),
          ),
          centerTitle: true, // This centers the title in the AppBar

          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
      padding: const EdgeInsets.only(
        top: 20.0, // Add margin from the top
      ),
            ),    
            
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Level indicator, XP text, and user name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Level $level',
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15), // Space between Level and XP
                          Text(
                            '${currentXP.toInt()}/${maxXP.toInt()} XP',
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 2.0,
                        ), // Move userName slightly to the left
                        child: Text(
                          userName,
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // XP Progress bar and person icon
                  Row(
                    children: [
                      Expanded(
                        flex:
                            8, // Adjust the flex to control the progress bar width
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: currentXP / maxXP,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              themeColor,
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ), // Space between the progress bar and the icon
                      Transform.translate(
                        offset: Offset(
                          0,
                          -15,
                        ), // Move the image slightly upward
                        child: Image.asset(
                          'assets/avatars/avatar1.png', // Replace with your asset path
                          height: 120, // Adjust the size as needed
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    PersonalQuestsWidget(),
                    SizedBox(height: 20),
                    DailyQuestSelectorWidget(),
                  ],
                ),
              ),
            ),

            // Add spacing for other body content
          ],
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/nutrition');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercice');

                  },
                ),
                IconButton(
                  icon: Icon(Icons.sports_gymnastics, color: themeColor),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
