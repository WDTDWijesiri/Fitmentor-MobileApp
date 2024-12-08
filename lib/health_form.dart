import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HealthForm extends StatefulWidget {
  final String userEmail;

  const HealthForm({super.key, required this.userEmail});

  @override
  _HealthFormState createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {
  // Dropdown values
  String? profession;
  String? alcoholConsumption;
  String? smokingHabits;
  String? exerciseLevel;
  String? sleepPattern;

  // Options for dropdowns
  final List<String> professionOptions = [
    'Office and Administrative Jobs',
    'Manual Labor and Skilled Trades',
    'Health and Medical Professions',
    'Education and Training',
    'Creative and Design Professions'
  ];

  final List<String> alcoholOptions = ['None', 'Frequent'];
  final List<String> smokingOptions = ['None', 'Frequent'];
  final List<String> exerciseOptions = ['None', 'Light', 'Moderate', 'Intense'];
  final List<String> sleepOptions = [
    'Less than 6 hrs',
    '6–7 hrs',
    '7–9 hrs',
    '10+ hrs'
  ];

  String? getSleepFeedback(String? selected) {
    if (selected == 'Less than 6 hrs') {
      return "Insufficient sleep. Consider improving your sleep routine.";
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (widget.userEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User email is empty! Please log in again.")),
      );
      return;
    }

    // Convert email to a Firebase-safe key
    final userKey = widget.userEmail.replaceAll('.', '_');

    // Reference to Firebase Realtime Database
    DatabaseReference userRef =
    FirebaseDatabase.instance.ref().child('Users').child(userKey);

    try {
      // Update user data in Firebase
      await userRef.update({
        'profession': profession ?? 'Not Specified',
        'alcoholConsumption': alcoholConsumption ?? 'Not Specified',
        'smokingHabits': smokingHabits ?? 'Not Specified',
        'exerciseLevel': exerciseLevel ?? 'Not Specified',
        'sleepPattern': sleepPattern ?? 'Not Specified',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Health data updated successfully!")),
      );

      // Navigate to another screen or give feedback to the user
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0), // Move heading down
          child: Text('Health Profile Builder'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: profession,
              decoration: const InputDecoration(labelText: 'Profession'),
              items: professionOptions
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => profession = value),
            ),
            const SizedBox(height: 24), // Increased spacing below dropdown
            DropdownButtonFormField<String>(
              value: alcoholConsumption,
              decoration: const InputDecoration(labelText: 'Alcohol Consumption'),
              items: alcoholOptions
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => alcoholConsumption = value),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: smokingHabits,
              decoration: const InputDecoration(labelText: 'Smoking Habits'),
              items: smokingOptions
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => smokingHabits = value),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: exerciseLevel,
              decoration: const InputDecoration(labelText: 'Exercise'),
              items: exerciseOptions
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => exerciseLevel = value),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: sleepPattern,
              decoration: const InputDecoration(labelText: 'Sleep Patterns'),
              items: sleepOptions
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => setState(() => sleepPattern = value),
            ),
            if (sleepPattern == 'Less than 6 hrs') ...[
              const SizedBox(height: 16),
              Text(
                getSleepFeedback(sleepPattern)!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Change button color
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
