import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xp_fit/DB/db_helper.dart';
import 'package:xp_fit/UI/widgets/button.widget.dart';

class AvatarChoosingPage extends StatefulWidget {
  @override
  _AvatarChoosingPageState createState() => _AvatarChoosingPageState();
}

class _AvatarChoosingPageState extends State<AvatarChoosingPage> {
  String? selectedAvatar = 'assets/avatars/avatar1.png';

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
    final Color themeColor =  const Color.fromARGB(232, 163, 218, 246);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final emailRetrieve = ModalRoute.of(context)!.settings.arguments as String;

    final avatarSize = (screenWidth * 0.3).clamp(100.0, 200.0);
    final horizontalSpacing = screenWidth * 0.02;
    final verticalSpacing = screenHeight * 0.02;

    List<Widget> buildAvatarRows() {
      List<Widget> rows = [];

      for (int i = 0; i < avatarList.length; i += 3) {
        List<Widget> rowChildren = [];

        for (int j = i; j < i + 3 && j < avatarList.length; j++) {
          final avatar = avatarList[j];
          final isSelected = selectedAvatar == avatar['image'];

          rowChildren.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedAvatar = avatar['image'];
                });
              },
              child: Column(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: themeColor, width: 4) : null,
                      image: DecorationImage(
                        image: AssetImage(avatar['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    avatar['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );

          if (j < i + 2 && j < avatarList.length - 1) {
            rowChildren.add(SizedBox(width: horizontalSpacing));
          }
        }

        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        ));

        if (i + 3 < avatarList.length) {
          rows.add(SizedBox(height: verticalSpacing));
        }
      }

      return rows;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF35AEFF)],
          begin: Alignment.topCenter,
          end: Alignment(0.0, 5.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome! Choose your Class',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: verticalSpacing * 2),
                    ...buildAvatarRows(),
                    SizedBox(height: verticalSpacing * 2),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: XPFitButton(
                        text: 'Continue',
                        onPressed: () async {
                          if (selectedAvatar != null) {
                            await DBHelper.add_avatar(emailRetrieve, selectedAvatar!);
                            Navigator.pushNamed(context, '/home', arguments: emailRetrieve);
                            // You can navigate or show confirmation here
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please select an avatar.")),
                            );
                          }
                        },
                      ),
                    )
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

