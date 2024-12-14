import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double progress = 0.7; // Initial progress value (0.0 to 1.0)
  int calories = 1000; // Initial calorie value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Calorie Budget',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$calories',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Human Image as Progress Bar
                  Container(
                    height: 180, // Adjusted to fit the human image better
                    width: 120,
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
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
          SizedBox(height: 16),
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
          SizedBox(height: 16),
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
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            SizedBox(width: 40), // Space for Floating Action Button
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
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
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMealData(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, String trailingText) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: trailingText.isNotEmpty
          ? Text(
        trailingText,
        style: TextStyle(color: Colors.black),
      )
          : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
