import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  final String userEmail; // Add userEmail to constructor

  ExercisePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<Map<String, dynamic>> exerciseLog = []; // To store selected exercises in log
  List<Map<String, dynamic>> exerciseItems = [
    {'name': 'Running', 'calories': 300, 'duration': 30}, // Calories burned in 30 minutes
    {'name': 'Cycling', 'calories': 250, 'duration': 30},
    {'name': 'Swimming', 'calories': 400, 'duration': 30},
    {'name': 'Weightlifting', 'calories': 200, 'duration': 30},
    {'name': 'Yoga', 'calories': 100, 'duration': 30},
    {'name': 'Hiking', 'calories': 350, 'duration': 30},
    {'name': 'Dancing', 'calories': 300, 'duration': 30},
  ];

  List<Map<String, dynamic>> filteredExerciseItems = [];
  TextEditingController searchController = TextEditingController();

  // Firebase Realtime Database reference
  late DatabaseReference _exerciseLogRef;

  @override
  void initState() {
    super.initState();
    filteredExerciseItems = exerciseItems; // Initially, show all items
    // Initialize Firebase Realtime Database reference
    _exerciseLogRef = FirebaseDatabase.instance.ref('users/${_sanitizeEmail(widget.userEmail)}/exercise_log');
    _loadExerciseLogFromDatabase();
  }

  // Function to sanitize the email to use as a key
  String _sanitizeEmail(String email) {
    return email.replaceAll('.', ','); // Firebase doesn't allow '.' in keys, so we replace it with ','
  }

  // Function to load exercise log from Firebase Realtime Database
  void _loadExerciseLogFromDatabase() async {
    final snapshot = await _exerciseLogRef.get();

    if (snapshot.exists) {
      var data = snapshot.value;

      if (data is List) {
        setState(() {
          exerciseLog = data
              .where((item) => item is Map) // Ensure that each item is a Map
              .map((item) => Map<String, dynamic>.from(item as Map)) // Safely cast to Map<String, dynamic>
              .toList();
        });
      } else if (data is Map) {
        setState(() {
          exerciseLog = data.values
              .where((item) => item is Map) // Ensure that each value is a Map
              .map((item) => Map<String, dynamic>.from(item as Map)) // Safely cast to Map<String, dynamic>
              .toList();
        });
      }
    }
  }

  // Function to save exercise log to Firebase Realtime Database
  void _saveExerciseLogToDatabase() {
    _exerciseLogRef.set(exerciseLog);
  }

  // Function to calculate the total calories burned from the logged exercises
  int _getTotalCaloriesBurned() {
    int totalcaloriesExercise = 0;
    for (var exercise in exerciseLog) {
      totalcaloriesExercise += (exercise['calories'] as num).toInt();
    }
    return totalcaloriesExercise;
  }

  // Function to filter exercise items based on search input
  void _filterExerciseItems(String query) {
    setState(() {
      filteredExerciseItems = exerciseItems
          .where((exercise) => exercise['name'].toLowerCase().contains(query.toLowerCase()))
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
        title: Text('Exercise for ${widget.userEmail}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterExerciseItems,
              decoration: InputDecoration(
                hintText: 'Search and log exercises',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: exerciseLog.isEmpty
                ? const Center(child: Text('No exercises logged yet'))
                : ListView.builder(
              itemCount: exerciseLog.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.directions_run, color: Colors.blue),
                  title: Text(exerciseLog[index]['name']),
                  subtitle: Text('${exerciseLog[index]['calories']} cals burned | Duration: ${exerciseLog[index]['duration']} mins'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        exerciseLog.removeAt(index);
                      });
                      _saveExerciseLogToDatabase(); // Save updated exercise log
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Calories Burned: ${_getTotalCaloriesBurned()} cals',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        onChanged: _filterExerciseItems,
                        decoration: InputDecoration(
                          hintText: 'Search exercise',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredExerciseItems.length,
                        itemBuilder: (context, index) {
                          bool isSelected = exerciseLog.contains(filteredExerciseItems[index]);

                          return Container(
                            color: isSelected ? Colors.blue[100] : null,
                            child: CheckboxListTile(
                              title: Text(filteredExerciseItems[index]['name']),
                              subtitle: Text('${filteredExerciseItems[index]['calories']} cals burned | Duration: ${filteredExerciseItems[index]['duration']} mins'),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    exerciseLog.add(filteredExerciseItems[index]);
                                  } else {
                                    exerciseLog.remove(filteredExerciseItems[index]);
                                  }
                                });
                                _saveExerciseLogToDatabase(); // Save exercise log to database after modification
                              },
                              secondary: Icon(Icons.directions_run, color: Colors.blue),
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
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    home: ExercisePage(userEmail: 'user@example.com'),
    debugShowCheckedModeBanner: false,
  ));
}
