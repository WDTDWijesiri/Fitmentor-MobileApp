import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DinnerPage extends StatefulWidget {
  final String userEmail; // Add userEmail to constructor

  DinnerPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _DinnerPageState createState() => _DinnerPageState();
}

class _DinnerPageState extends State<DinnerPage> {
  List<Map<String, dynamic>> foodLog = []; // To store selected foods in log
  List<Map<String, dynamic>> foodItems = [
    {'name': 'Steak and Mashed Potatoes', 'calories': 700, 'servings': 1},
    {'name': 'Grilled Chicken with Vegetables', 'calories': 600, 'servings': 1},
    {'name': 'Salmon with Rice', 'calories': 450, 'servings': 1},
    {'name': 'Pasta Alfredo', 'calories': 650, 'servings': 1},
    {'name': 'Tacos', 'calories': 400, 'servings': 1},
    {'name': 'Vegetable Stir-fry', 'calories': 300, 'servings': 1},
    {'name': 'Soup and Bread', 'calories': 250, 'servings': 1},
  ];

  List<Map<String, dynamic>> filteredFoodItems = [];
  TextEditingController searchController = TextEditingController();

  // Firebase Realtime Database reference
  late DatabaseReference _foodLogRef;

  @override
  void initState() {
    super.initState();
    filteredFoodItems = foodItems; // Initially, show all items
    // Initialize Firebase Realtime Database reference
    _foodLogRef = FirebaseDatabase.instance.ref('users/${_sanitizeEmail(widget.userEmail)}/dinner_log');
    _loadFoodLogFromDatabase();
  }

  // Function to sanitize the email to use as a key
  String _sanitizeEmail(String email) {
    return email.replaceAll('.', ','); // Firebase doesn't allow '.' in keys, so we replace it with ','
  }

  // Function to load food log from Firebase Realtime Database
  void _loadFoodLogFromDatabase() async {
    final snapshot = await _foodLogRef.get();

    if (snapshot.exists) {
      var data = snapshot.value;

      if (data is List) {
        setState(() {
          foodLog = data
              .where((item) => item is Map) // Ensure that each item is a Map
              .map((item) => Map<String, dynamic>.from(item as Map)) // Safely cast to Map<String, dynamic>
              .toList();
        });
      } else if (data is Map) {
        setState(() {
          foodLog = data.values
              .where((item) => item is Map) // Ensure that each value is a Map
              .map((item) => Map<String, dynamic>.from(item as Map)) // Safely cast to Map<String, dynamic>
              .toList();
        });
      }
    }
  }

  // Function to save food log to Firebase Realtime Database
  void _saveFoodLogToDatabase() {
    _foodLogRef.set(foodLog);
  }

  // Function to calculate the total calories from the logged foods
  int _getTotalCalories() {
    int totalCaloriesDinner = 0;
    for (var food in foodLog) {
      totalCaloriesDinner += (food['calories'] as num).toInt();
    }
    return totalCaloriesDinner;
  }

  // Function to filter food items based on search input
  void _filterFoodItems(String query) {
    setState(() {
      filteredFoodItems = foodItems
          .where((food) => food['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Dinner for ${widget.userEmail}'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterFoodItems,
              decoration: InputDecoration(
                hintText: 'Search and log foods',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: foodLog.isEmpty
                ? Center(child: Text('No food logged yet'))
                : ListView.builder(
              itemCount: foodLog.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.fastfood, color: Colors.orange),
                  title: Text(foodLog[index]['name']),
                  subtitle: Text('${foodLog[index]['calories']} cals | Servings: ${foodLog[index]['servings']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        foodLog.removeAt(index);
                      });
                      _saveFoodLogToDatabase(); // Save updated food log
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Calories: ${_getTotalCalories()} cals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: _filterFoodItems,
                        decoration: InputDecoration(
                          hintText: 'Search food',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredFoodItems.length,
                        itemBuilder: (context, index) {
                          bool isSelected = foodLog.contains(filteredFoodItems[index]);

                          return Container(
                            color: isSelected ? Colors.green[100] : null,
                            child: CheckboxListTile(
                              title: Text(filteredFoodItems[index]['name']),
                              subtitle: Text('${filteredFoodItems[index]['calories']} cals | Servings: ${filteredFoodItems[index]['servings']}'),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    foodLog.add(filteredFoodItems[index]);
                                  } else {
                                    foodLog.remove(filteredFoodItems[index]);
                                  }
                                });
                                _saveFoodLogToDatabase(); // Save food log to database after modification
                              },
                              secondary: Icon(Icons.fastfood, color: Colors.orange),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    home: DinnerPage(userEmail: 'user@example.com'),
    debugShowCheckedModeBanner: false,
  ));
}