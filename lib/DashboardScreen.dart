import 'package:fitmentor/userprofile.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double progress = 0.7; // Initial progress value (0.0 to 1.0)
  int calories = 700; // Initial calorie value

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
            onPressed: () {},
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
                      _buildMealData('Exercise', '0'),
                      _buildMealData('Breakfast', '0'),
                      _buildMealData('Lunch', '0'),
                      _buildMealData('Dinner', '0'),
                      _buildMealData('Snacks', '0'),
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
                _buildListTile(Icons.analytics, 'My Analysis', ''),
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
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            progress = (progress + 0.1).clamp(0.0, 1.0); // Increase progress
            calories = (calories + 100).clamp(0, 2000); // Increase calories value
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMealData(String title, String value) {
    return Column(
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
    );
  }

  Widget _buildListTile(IconData icon, String title, String trailingText) {
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
