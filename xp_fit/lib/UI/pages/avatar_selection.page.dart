import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';

class AvatarChoosingPage extends StatelessWidget {
  final List<Map<String, String>> avatarList = [
    {'image': 'assets/avatars/avatar1.png', 'name': 'Archer'},
    {'image': 'assets/avatars/avatar2.png', 'name': 'Mage'},
    {'image': 'assets/avatars/avatar3.png', 'name': 'Warrior'},
    {'image': 'assets/avatars/avatar4.png', 'name': 'Healer'},
    {'image': 'assets/avatars/avatar5.png', 'name': 'Necromancer'},
    {'image': 'assets/avatars/avatar6.png', 'name': 'Barbarian'},
    {'image': 'assets/avatars/avatar7.png', 'name': 'Knight'},
  ];

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final avatarSize = (screenWidth * 0.3).clamp(
      100.0,
      200.0,
    ); // 30% of screen width, min 100, max 200
    final horizontalSpacing = screenWidth * 0.02; // 2% of screen width
    final verticalSpacing = screenHeight * 0.02; // 2% of screen height

    // Function to create rows of 3 avatars each
    List<Widget> buildAvatarRows() {
      List<Widget> rows = [];

      for (int i = 0; i < avatarList.length; i += 3) {
        List<Widget> rowChildren = [];

        // Add up to 3 avatars per row
        for (int j = i; j < i + 3 && j < avatarList.length; j++) {
          rowChildren.add(
            GestureDetector(
              onTap: () {
                print('Selected Avatar: ${avatarList[j]['name']}');
              },
              child: Column(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(avatarList[j]['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                  ),

                  Text(
                    avatarList[j]['name']!,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: screenWidth * 0.04, // Responsive font size
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );

          // Add spacing between avatars (but not after the last one in the row)
          if (j < i + 2 && j < avatarList.length - 1) {
            rowChildren.add(SizedBox(width: horizontalSpacing));
          }
        }

        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        );

        // Add vertical spacing between rows (but not after the last row)
        if (i + 3 < avatarList.length) {
          rows.add(SizedBox(height: verticalSpacing));
        }
      }

      return rows;
    }

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.signal_cellular_alt, color: themeColor),
                SizedBox(width: 10),
                Icon(Icons.wifi, color: themeColor),
                SizedBox(width: 10),
                Icon(Icons.battery_full, color: themeColor),
              ],
            ),
          ),
          
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight,
              // Space equal to the AppBar height and status bar
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align content to start
                  children: [
                    Text(
                      'Welcome! Choose your Class',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height:
                          verticalSpacing * 3, // Space between text and avatars
                    ),
                    ...buildAvatarRows(),
                    SizedBox(
                      height: verticalSpacing * 3,
                    ), // Optional spacing after avatars

                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                      child: XPFitButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        horizontalPadding: screenWidth * 0.1,
                        verticalPadding: screenHeight * 0.02,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
