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

  
  final Color themeColor = const Color.fromARGB(232, 163, 218, 246);

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
    
    //used to get the pessed email that identifies the current user
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
          objWeight = user['obj_weight'];
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/favourite',arguments: email);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildMainContent() {
   weight = weight ?? 0.0;
   objWeight = objWeight ?? 1.0; // Default to 1 to avoid division by zero
   email = email ?? ''; // Safe email for PersonalQuestsWidget
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          top: 35.0, // Add margin from the top
        ),
      ),
      
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0.0,
        ),
        child: ClipRect(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 150, // Increased height to accommodate content
              child: Stack( // Changed to Stack for better positioning
                children: [
                  // Left side content
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 120, // Leave space for avatar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Level indicator - aligned to the left
                        Text(
                          'Level $level',
                          style: TextStyle(
                            color: themeColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // Username - aligned to the left (same vertical line as level)
                        Text(
                          username ?? 'User',
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28, // Large size for prominence
                            letterSpacing: 1.2,
                          ),
                        ),
                        
                        SizedBox(height: 10),
                        
                        // XP progress section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //'${((weight! * 100 )/objWeight!).toStringAsFixed(0)}/${maxXP.toInt()}XP',
                              '${((weight! < objWeight!)
                                ? ((weight! * 100) / objWeight!)
                                : (100 - (100 - (objWeight! / weight!) * 100))).toStringAsFixed(0)}/${maxXP.toInt()}XP',
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                              value: (weight! < objWeight!)
                                ? ((weight! * 100) / objWeight!) / maxXP
                                : (100 - (100 - (objWeight! / weight!) * 100)) / maxXP,

                                backgroundColor: Colors.grey.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color.fromARGB(232, 163, 218, 246),
                                ),
                                minHeight: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Avatar positioned on the right
                  Positioned(
                    right: -25,
                    top: -7,
                    child: Container(
                      height: 170,
                      width: 170,
                      child: avatar != null
                          ? Image.asset(
                              avatar!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildAvatarPlaceholder(themeColor);
                              },
                            )
                          : _buildAvatarPlaceholder(themeColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PersonalQuestsWidget(email : email!),
              SizedBox(height: 15),
              DailyQuestSelectorWidget(),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildAvatarPlaceholder(Color themeColor) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: themeColor.withOpacity(0.3),
    ),
    child: Icon(
      Icons.person,
      size: 40,
      color: themeColor,
    ),
  );
}
}