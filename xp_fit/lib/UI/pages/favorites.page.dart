import 'package:flutter/material.dart';
import 'package:xp_fit/DB/db_helper.dart';
import 'package:xp_fit/UI/widgets/filteredElement.widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {


  List<Map<String, dynamic>> filteredElements = [];
  String selectedFilter = 'exe_user';
  
  // Define variables at the class level
  String? email;
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
          email = user['email'];
          isLoading = false;
        });
      loadInitialData();

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



  Future<void> loadInitialData() async {
    try {
      

      await DBHelper.debugTables();




      final filteredElementsList = await DBHelper.getFavorites(
        selectedFilter,email!
      );
      

      setState(() {
        filteredElements = filteredElementsList;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color themeColor = const Color.fromRGBO(80, 140, 155, 1);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A1D37), Color(0xFF1E3C72)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Filter:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132A47),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF132A47),
                          iconEnabledColor: Colors.blueAccent,
                          value: selectedFilter,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (newValue) async {
                            setState(() {
                              selectedFilter = newValue!;
                              isLoading = true;
                            });
                            await loadInitialData();
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "exe_user",
                              child: Text(
                                "Exercices",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "user_meals",
                              child: Text(
                                "Meals",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: filteredElements.length,
                        itemBuilder: (context, index) {
                          final filteredElement = filteredElements[index];
                          return FilteredElementCard(
                            filteredElement: filteredElement,
                          );
                        },
                      ),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          // Override the bottom nav theme to ensure transparency
          data: Theme.of(
            context,
          ).copyWith(canvasColor: const Color.fromARGB(0, 0, 0, 0)),
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
}