import 'package:firebase_database/firebase_database.dart';
import 'package:fitmentor/premium.dart';
import 'package:fitmentor/snacks.dart';
import 'package:fitmentor/water.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'breakfast.dart'; // Import the breakfast.dart page
import 'dinner.dart';
import 'exercise.dart';
import 'lunch.dart';
import 'myanalysis.dart';
import 'userprofile.dart';

class DashboardScreen extends StatefulWidget {
  final String userEmail;

  DashboardScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double progress = 0.7; // Initial progress value (0.0 to 1.0)
  int calories = 0; // Initial calorie value
  int breakfastCalories = 0;// Initial value for breakfast calories
  int totalCalorieLunch=0;
  int totalCalorieDinner = 0;
  int totalCalorieSnacks = 0;
  int totalCalorieExercise = 0;

  // Data for the modal bottom sheet UI
  int _selectedIndex = 0;
  final List<String> _categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Exercise',
    'Water'
  ];
  final List<IconData> _icons = [
    Icons.wb_sunny,
    Icons.wb_sunny_outlined,
    Icons.brightness_3,
    Icons.fastfood,
    Icons.fitness_center,
    Icons.local_drink,
  ];
  // Function to show modal bottom sheet
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) { // If the Breakfast icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreakfastPage(userEmail: widget.userEmail),
                          ),
                        );
                      } else if (index == 1) { // If the Lunch icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LunchPage(userEmail: widget.userEmail),
                          ),
                        );
                      } else if (index == 2) { // If the Dinner icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DinnerPage(userEmail: widget.userEmail),
                          ),
                        );
                      } else if (index == 3) { // If the Snacks icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SnacksPage(userEmail: widget.userEmail),
                          ),
                        );
                      } else if (index == 4) { // If the Exercise icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExercisePage(userEmail: widget.userEmail),
                          ),
                        );
                      } else if (index == 5) { // If the Water icon is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterScreen(),
                          ),
                        );
                      }
                      // Handle other taps for other categories here if needed
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _icons[index],
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _categories[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 30,
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // Firebase database reference
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    _fetchTotalCalories();
    _fetchTotalCaloriesDinner();
    _fetchTotalCaloriesSnacks();
    _fetchTotalCaloriesExercise();
    _fetchTotalCaloriesLunch();
    _calculateTotalCalories();// Fetch total calories when the widget is initialized
  }

  // Method to fetch total calories from the food_log in Firebase
  Future<void> _fetchTotalCalories() async {
    try {
      // Get the current date in 'yyyy-MM-dd' format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final foodLogSnapshot = await _dbRef.child('users/${widget.userEmail.replaceAll('.', ',')}/food_log/$currentDate').get();

      if (foodLogSnapshot.exists) {
        int totalCaloriesBreakfast = 0;

        // Check if the value is a List or a Map
        if (foodLogSnapshot.value is List) {
          List<dynamic> foodLog = foodLogSnapshot.value as List<dynamic>;

          // Loop through the list and sum the calories
          for (var item in foodLog) {
            if (item != null && item is Map<dynamic, dynamic>) {
              var caloriesValue = item['calories'] ?? 0;
              if (caloriesValue is int) {
                totalCaloriesBreakfast += caloriesValue;
              } else if (caloriesValue is double) {
                totalCaloriesBreakfast += caloriesValue.toInt();
              }
            }
          }
        } else if (foodLogSnapshot.value is Map) {
          Map<dynamic, dynamic> foodLog = foodLogSnapshot.value as Map<dynamic, dynamic>;

          // Loop through the map and sum the calories
          foodLog.forEach((key, value) {
            var caloriesValue = value['calories'] ?? 0;
            if (caloriesValue is int) {
              totalCaloriesBreakfast += caloriesValue;
            } else if (caloriesValue is double) {
              totalCaloriesBreakfast += caloriesValue.toInt();
            }
          });
        }

        // Update the state with the new breakfast calories
        setState(() {
          breakfastCalories = totalCaloriesBreakfast;
        });
      } else {
        setState(() {
          breakfastCalories = 0; // No data found, set to 0
        });
      }
      _calculateTotalCalories();
    } catch (e) {
      print('Error fetching calories: $e');
      setState(() {
        breakfastCalories = 0; // Handle errors gracefully
      });
      _calculateTotalCalories();
    }
  }
  Future<void> _fetchTotalCaloriesLunch() async {
    try {
      // Get the current date in 'yyyy-MM-dd' format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final lunchLogSnapshot = await _dbRef.child('users/${widget.userEmail.replaceAll('.', ',')}/lunch_log/$currentDate').get();

      if (lunchLogSnapshot.exists) {
        int totalCaloriesLunch = 0;

        // Check if the value is a List or a Map
        if (lunchLogSnapshot.value is List) {
          List<dynamic> lunchLog = lunchLogSnapshot.value as List<dynamic>;

          // Loop through the list and sum the calories
          for (var item in lunchLog) {
            if (item != null && item is Map<dynamic, dynamic>) {
              var caloriesValue = item['calories'] ?? 0;
              if (caloriesValue is int) {
                totalCaloriesLunch += caloriesValue;
              } else if (caloriesValue is double) {
                totalCaloriesLunch += caloriesValue.toInt();
              }
            }
          }
        } else if (lunchLogSnapshot.value is Map) {
          Map<dynamic, dynamic> lunchLog = lunchLogSnapshot.value as Map<dynamic, dynamic>;

          // Loop through the map and sum the calories
          lunchLog.forEach((key, value) {
            var caloriesValue = value['calories'] ?? 0;
            if (caloriesValue is int) {
              totalCaloriesLunch += caloriesValue;
            } else if (caloriesValue is double) {
              totalCaloriesLunch += caloriesValue.toInt();
            }
          });
        }

        // Update the state with the new lunch calories
        setState(() {
          totalCalorieLunch = totalCaloriesLunch;
        });
      } else {
        setState(() {
          totalCalorieLunch = 0; // No data found, set to 0
        });
      }
      _calculateTotalCalories();
    } catch (e) {
      print('Error fetching lunch calories: $e');
      setState(() {
        totalCalorieLunch = 0; // Handle errors gracefully
      });
      _calculateTotalCalories();
    }
  }
  Future<void> _fetchTotalCaloriesDinner() async {
    try {
      // Get the current date in 'yyyy-MM-dd' format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final dinnerLogSnapshot = await _dbRef.child('users/${widget.userEmail.replaceAll('.', ',')}/dinner_log/$currentDate').get();

      if (dinnerLogSnapshot.exists) {
        int totalCaloriesDinner = 0;

        // Check if the value is a List or a Map
        if (dinnerLogSnapshot.value is List) {
          List<dynamic> dinnerLog = dinnerLogSnapshot.value as List<dynamic>;

          // Loop through the list and sum the calories
          for (var item in dinnerLog) {
            if (item != null && item is Map<dynamic, dynamic>) {
              var caloriesValue = item['calories'] ?? 0;
              if (caloriesValue is int) {
                totalCaloriesDinner += caloriesValue;
              } else if (caloriesValue is double) {
                totalCaloriesDinner += caloriesValue.toInt();
              }
            }
          }
        } else if (dinnerLogSnapshot.value is Map) {
          Map<dynamic, dynamic> dinnerLog = dinnerLogSnapshot.value as Map<dynamic, dynamic>;

          // Loop through the map and sum the calories
          dinnerLog.forEach((key, value) {
            var caloriesValue = value['calories'] ?? 0;
            if (caloriesValue is int) {
              totalCaloriesDinner += caloriesValue;
            } else if (caloriesValue is double) {
              totalCaloriesDinner += caloriesValue.toInt();
            }
          });
        }

        // Update the state with the new dinner calories
        setState(() {
          totalCalorieDinner = totalCaloriesDinner;
        });
      } else {
        setState(() {
          totalCalorieDinner = 0; // No data found, set to 0
        });
      }
      _calculateTotalCalories();
    } catch (e) {
      print('Error fetching dinner calories: $e');
      setState(() {
        totalCalorieDinner = 0; // Handle errors gracefully
      });
      _calculateTotalCalories();
    }
  }
  Future<void> _fetchTotalCaloriesSnacks() async {
    try {
      // Get the current date in 'yyyy-MM-dd' format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final snacksLogSnapshot = await _dbRef.child('users/${widget.userEmail.replaceAll('.', ',')}/snacks_log/$currentDate').get();

      if (snacksLogSnapshot.exists) {
        int totalCaloriesSnacks = 0;

        // Check if the value is a List or a Map
        if (snacksLogSnapshot.value is List) {
          List<dynamic> snacksLog = snacksLogSnapshot.value as List<dynamic>;

          // Loop through the list and sum the calories
          for (var item in snacksLog) {
            if (item != null && item is Map<dynamic, dynamic>) {
              var caloriesValue = item['calories'] ?? 0;
              if (caloriesValue is int) {
                totalCaloriesSnacks += caloriesValue;
              } else if (caloriesValue is double) {
                totalCaloriesSnacks += caloriesValue.toInt();
              }
            }
          }
        } else if (snacksLogSnapshot.value is Map) {
          Map<dynamic, dynamic> snacksLog = snacksLogSnapshot.value as Map<dynamic, dynamic>;

          // Loop through the map and sum the calories
          snacksLog.forEach((key, value) {
            var caloriesValue = value['calories'] ?? 0;
            if (caloriesValue is int) {
              totalCaloriesSnacks += caloriesValue;
            } else if (caloriesValue is double) {
              totalCaloriesSnacks += caloriesValue.toInt();
            }
          });
        }

        // Update the state with the new snacks calories
        setState(() {
          totalCalorieSnacks = totalCaloriesSnacks;
        });
      } else {
        setState(() {
          totalCalorieSnacks = 0; // No data found, set to 0
        });
      }
      _calculateTotalCalories();
    } catch (e) {
      print('Error fetching snacks calories: $e');
      setState(() {
        totalCalorieSnacks = 0; // Handle errors gracefully
      });
      _calculateTotalCalories();
    }
  }
  Future<void> _fetchTotalCaloriesExercise() async {
    try {
      // Get the current date in 'yyyy-MM-dd' format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final exerciseLogSnapshot = await _dbRef.child('users/${widget.userEmail.replaceAll('.', ',')}/exercise_log/$currentDate').get();

      if (exerciseLogSnapshot.exists) {
        int totalCaloriesExercise = 0;

        // Check if the value is a List or a Map
        if (exerciseLogSnapshot.value is List) {
          List<dynamic> exerciseLog = exerciseLogSnapshot.value as List<dynamic>;

          // Loop through the list and sum the calories
          for (var item in exerciseLog) {
            if (item != null && item is Map<dynamic, dynamic>) {
              var caloriesValue = item['calories'] ?? 0;
              if (caloriesValue is int) {
                totalCaloriesExercise += caloriesValue;
              } else if (caloriesValue is double) {
                totalCaloriesExercise += caloriesValue.toInt();
              }
            }
          }
        } else if (exerciseLogSnapshot.value is Map) {
          Map<dynamic, dynamic> exerciseLog = exerciseLogSnapshot.value as Map<dynamic, dynamic>;

          // Loop through the map and sum the calories
          exerciseLog.forEach((key, value) {
            var caloriesValue = value['calories'] ?? 0;
            if (caloriesValue is int) {
              totalCaloriesExercise += caloriesValue;
            } else if (caloriesValue is double) {
              totalCaloriesExercise += caloriesValue.toInt();
            }
          });
        }

        // Update the state with the new exercise calories
        setState(() {
          totalCalorieExercise = totalCaloriesExercise;
        });
      } else {
        setState(() {
          totalCalorieExercise = 0; // No data found, set to 0
        });
      }
      _calculateTotalCalories();
    } catch (e) {
      print('Error fetching exercise calories: $e');
      setState(() {
        totalCalorieExercise = 0; // Handle errors gracefully
      });
      _calculateTotalCalories();
    }
  }
  void _calculateTotalCalories() {
    setState(() {
      // Add calories from breakfast, lunch, dinner, and snacks, then subtract exercise calories
      calories = (breakfastCalories + totalCalorieLunch + totalCalorieDinner + totalCalorieSnacks) - totalCalorieExercise;

      // Update progress as a ratio (assuming a calorie goal of 2000 for example)
      // progress = (calories / 2000).clamp(0.0, 1.0);
    });
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PremiumPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Go Premium',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Navigation
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, color: Colors.black),
                Text(
                  'Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward, color: Colors.black),
              ],
            ),
          ),
          // Calorie Budget Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Calorie Budget',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$calories',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Human Image as Progress Bar
                  Container(
                    height: 180, // Adjusted to fit the human image better
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Border color for the progress bar
                        width: 3, // Border thickness
                      ),
                      borderRadius: BorderRadius.circular(60), // Border's rounded corners
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Human Image as Background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/images/man.png', // Human image
                            fit: BoxFit.cover,
                            height: 180,
                            width: 120,
                          ),
                        ),
                        // Overlaying the Human Image with Color Fill (smooth progress)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 120,
                              height: 180 * progress, // Height of the fill based on progress
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.withOpacity(0.7), // Use orange color for progress
                              ),
                            ),
                          ),
                        ),
                        // Calories Value on the Image
                        Positioned(
                          child: Text(
                            '$calories cal',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMealData('Exercise', '$totalCalorieExercise',(){
                        // Navigate to the BreakfastPage when Breakfast is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExercisePage(userEmail: widget.userEmail),
                          ),
                        );
                      }),
                      _buildMealData('Breakfast', '$breakfastCalories', () {
                        // Navigate to the BreakfastPage when Breakfast is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreakfastPage(userEmail: widget.userEmail),
                          ),
                        );
                      }),
                      _buildMealData('Lunch', '$totalCalorieLunch', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LunchPage(userEmail: widget.userEmail),
                          ),
                        );
                      }),
                      _buildMealData('Dinner', '$totalCalorieDinner', () {
                        // Navigate to the DinnerPage when Dinner is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DinnerPage(userEmail: widget.userEmail),
                          ),
                        );
                      }),

                      _buildMealData('Snacks', '$totalCalorieSnacks',(){
                        // Navigate to the DinnerPage when Dinner is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SnacksPage(userEmail: widget.userEmail),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // My Analysis and Weight In
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildListTile(Icons.analytics, 'My Analysis', '', () {
                  // Navigate to MyAnalysisPage when My Analysis is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAnalysisPage(),
                    ),
                  );
                }),

                _buildListTile(Icons.fitness_center, 'Weight In', '55kg'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Discover Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildListTile(Icons.nightlight_round, 'Sleep', ''),
                _buildListTile(Icons.medical_services, 'Meet Your Doctor', ''),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // Space for Floating Action Button
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Navigate to UserProfile on person icon click
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile(userEmail: widget.userEmail)),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMealData(String title, String value, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap, // Assign the onTap if provided, otherwise it's null
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String trailingText, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: trailingText.isNotEmpty
          ? Text(
        trailingText,
        style: const TextStyle(color: Colors.black),
      )
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: onTap, // Now this will handle the navigation if provided
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(userEmail: 'user@example.com'), // Example email, pass the real one in your app
    debugShowCheckedModeBanner: false,
  ));
}
