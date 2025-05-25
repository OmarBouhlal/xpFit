import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xp_fit/DB/db_helper.dart';
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

  // Your app's theme color
  final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);

  // Define variables at the class level
  int? idUser;
  String? username;
  String? email;
  String? password;
  double? weight;
  double? height;
  String? birthDate;
  String? gender;
  double? objWeight;
  String? avatar;

  // Loading state
  bool isLoading = true;
  bool hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load user data when the page dependencies change
    final emailRetrieve = ModalRoute.of(context)!.settings.arguments as String;
    loadUser(emailRetrieve);
  }

  void loadUser(String emailArg) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final user = await DBHelper.retrieve_user(emailArg);
      if (user != null) {
        setState(() {
          idUser = user['id_user'];
          username = user['username'];
          email = user['email'];
          password = user['password'];
          weight = (user['weight'] as num).toDouble();
          height = (user['height'] as num).toDouble();
          birthDate = user['birthDate'];
          gender = user['gender'];
          objWeight = user['obj_weight'] != null ? (user['obj_weight'] as num).toDouble() : null;
          avatar = user['avatar'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

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
        backgroundColor: Colors.transparent, // Make scaffold background transparent

        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                ),
              )
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load user data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final emailRetrieve = ModalRoute.of(context)!.settings.arguments as String;
                            loadUser(emailRetrieve);
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _buildMainContent(),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/home',arguments: email);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.restaurant, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/nutrition',arguments:email);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fitness_center_sharp, color: themeColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercice',arguments: email);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: themeColor),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
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
                      right: 35.0,
                    ), // Move userName slightly to the left
                    child: Text(
                      username ?? 'User', // Use the loaded username or fallback
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
                    flex: 8, // Adjust the flex to control the progress bar width
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
                    child: avatar != null
                        ? Image.asset(
                            avatar!, // Now safely use avatar since we check for null
                            height: 120, // Adjust the size as needed
                            width: 120,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if the image can't be loaded
                              return Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeColor.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: themeColor,
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColor.withOpacity(0.3),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: themeColor,
                            ),
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
    );
  }

  Widget _buildBottomNavigationBar() {
    return Theme(
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
              icon: Icon(Icons.favorite, color: themeColor),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}