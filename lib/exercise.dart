import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class ExercisePage extends StatefulWidget {
  final String userEmail;

  ExercisePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<Map<String, dynamic>> exerciseLog = [];
  List<Map<String, dynamic>> exerciseItems = [
    {'name': 'Running', 'calories': 300, 'duration': 30},
    {'name': 'Cycling', 'calories': 250, 'duration': 30},
    {'name': 'Swimming', 'calories': 400, 'duration': 30},
    {'name': 'Weightlifting', 'calories': 200, 'duration': 30},
    {'name': 'Yoga', 'calories': 100, 'duration': 30},
    {'name': 'Hiking', 'calories': 350, 'duration': 30},
    {'name': 'Dancing', 'calories': 300, 'duration': 30},
  ];

  List<Map<String, dynamic>> filteredExerciseItems = [];
  TextEditingController searchController = TextEditingController();

  late DatabaseReference _exerciseLogRef;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get current date

  @override
  void initState() {
    super.initState();
    filteredExerciseItems = exerciseItems;
    _exerciseLogRef = FirebaseDatabase.instance
        .ref('users/${_sanitizeEmail(widget.userEmail)}/exercise_log/$currentDate'); // Store under current date
    _loadExerciseLogFromDatabase();
  }

  String _sanitizeEmail(String email) {
    return email.replaceAll('.', ',');
  }

  void _loadExerciseLogFromDatabase() async {
    final snapshot = await _exerciseLogRef.get();

    if (snapshot.exists) {
      var data = snapshot.value;

      if (data is List) {
        setState(() {
          exerciseLog = data
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        });
      } else if (data is Map) {
        setState(() {
          exerciseLog = data.values
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        });
      }
    }
  }

  void _saveExerciseLogToDatabase() {
    _exerciseLogRef.set(exerciseLog);
  }

  int _getTotalCaloriesBurned() {
    int totalcaloriesExercise = 0;
    for (var exercise in exerciseLog) {
      totalcaloriesExercise += (exercise['calories'] as num).toInt();
    }
    return totalcaloriesExercise;
  }

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
        title: Text('Exercise'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                String sanitizedEmail = _sanitizeEmail(widget.userEmail);

                setState(() {
                  _exerciseLogRef = FirebaseDatabase.instance.ref('users/$sanitizedEmail/exercise_log/$formattedDate');
                  _loadExerciseLogFromDatabase();
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
                      _saveExerciseLogToDatabase();
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
                                _saveExerciseLogToDatabase();
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
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ExercisePage(userEmail: 'user@example.com'),
    debugShowCheckedModeBanner: false,
  ));
}
