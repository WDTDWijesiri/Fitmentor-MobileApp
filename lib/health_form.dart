import 'package:flutter/material.dart';

class HealthForm extends StatefulWidget {
  @override
  _HealthFormState createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {
  String? selectedProfession;
  String? selectedAlcoholConsumption;

  final List<String> professions = [
    "Office and Administrative Jobs",
    "Manual Labor and Skilled Trades",
    "Health and Medical Professions",
    "Education and Training",
    "Creative and Design Professions"
  ];

  final List<String> alcoholConsumption = ["None", "Frequent"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Profile Builder"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Profession", style: TextStyle(fontSize: 16)),
            DropdownButtonFormField<String>(
              value: selectedProfession,
              items: professions
                  .map((profession) => DropdownMenuItem(
                value: profession,
                child: Text(profession),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProfession = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
            SizedBox(height: 20),
            Text("Alcohol Consumption", style: TextStyle(fontSize: 16)),
            DropdownButtonFormField<String>(
              value: selectedAlcoholConsumption,
              items: alcoholConsumption
                  .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAlcoholConsumption = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Submit action
                  print("Submitted");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
