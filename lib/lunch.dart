import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LunchPage extends StatefulWidget {
  final String userEmail;

  LunchPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _LunchPageState createState() => _LunchPageState();
}

class _LunchPageState extends State<LunchPage> {
  List<Map<String, dynamic>> foodLog = [];
  List<Map<String, dynamic>> foodItems = [
    {'name': 'Rice and Curry', 'calories': 500, 'servings': 1},
    {'name': 'Chicken Fried Rice', 'calories': 650, 'servings': 1},
    {'name': 'Vegetable Salad with Dressing', 'calories': 200, 'servings': 1},
    {'name': 'Pasta with Tomato Sauce', 'calories': 450, 'servings': 1},
    {'name': 'Grilled Fish with Rice', 'calories': 400, 'servings': 1},
    {'name': 'Burger and Fries', 'calories': 700, 'servings': 1},
    {'name': 'Pizza Slice', 'calories': 300, 'servings': 1},
  ];

  List<Map<String, dynamic>> filteredFoodItems = [];
  TextEditingController searchController = TextEditingController();

  late DatabaseReference _foodLogRef;
  late String currentDate;

  @override
  void initState() {
    super.initState();
    filteredFoodItems = foodItems;

    // Get the current date in 'yyyy-MM-dd' format
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Initialize Firebase Realtime Database reference
    _foodLogRef = FirebaseDatabase.instance.ref('users/${_sanitizeEmail(widget.userEmail)}/lunch_log/$currentDate');
    _loadFoodLogFromDatabase();
  }

  String _sanitizeEmail(String email) {
    return email.replaceAll('.', ',');
  }

  void _loadFoodLogFromDatabase() async {
    final snapshot = await _foodLogRef.get();

    if (snapshot.exists) {
      var data = snapshot.value;

      if (data is List) {
        setState(() {
          foodLog = data
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        });
      } else if (data is Map) {
        setState(() {
          foodLog = data.values
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        });
      }
    }
  }

  void _saveFoodLogToDatabase() {
    _foodLogRef.set(foodLog);
  }

  int _getTotalCalories() {
    int totalCaloriesLunch = 0;
    for (var food in foodLog) {
      totalCaloriesLunch += (food['calories'] as num).toInt();
    }
    return totalCaloriesLunch;
  }

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
        title: Text('Lunch'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              // Open the date picker to select a date
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                // Format the selected date
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                // Update the database reference for the selected date
                String sanitizedEmail = _sanitizeEmail(widget.userEmail);

                // Update the state to load food logs for the selected date
                setState(() {
                  _foodLogRef = FirebaseDatabase.instance.ref('users/$sanitizedEmail/lunch_log/$formattedDate');
                  _loadFoodLogFromDatabase();  // Load the food log for the selected date
                });
              }
            },
          ),

        ],
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
                      _saveFoodLogToDatabase();
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
                            color: isSelected ? Colors.blue[100] : null,
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
                                _saveFoodLogToDatabase();
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LunchPage(userEmail: 'user@example.com'),
    debugShowCheckedModeBanner: false,
  ));
}
