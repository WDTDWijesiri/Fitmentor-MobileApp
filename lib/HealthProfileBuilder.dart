import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'health_form.dart';

class HealthProfileBuilder extends StatefulWidget {
  final String userEmail;

  const HealthProfileBuilder({super.key, required this.userEmail});

  @override
  _HealthProfileBuilderState createState() => _HealthProfileBuilderState();
}

class _HealthProfileBuilderState extends State<HealthProfileBuilder> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedGender;
  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserProfile() async {
    final currentUserEmail = widget.userEmail;

    if (currentUserEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User email is empty! Please log in again.")),
      );
      return;
    }

    // Convert the email to a Firebase-safe key format
    final userKey = currentUserEmail.replaceAll('.', '_');

    // Reference to Firebase Realtime Database
    DatabaseReference userRef =
    FirebaseDatabase.instance.ref().child('Users').child(userKey);

    try {
      await userRef.update({
        'age': int.tryParse(ageController.text) ?? 0,
        'weight': int.tryParse(weightController.text) ?? 0,
        'height_feet': int.tryParse(feetController.text) ?? 0,
        'height_inches': int.tryParse(inchesController.text) ?? 0,
        'gender': selectedGender ?? 'Not Specified',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User profile updated successfully!")),
      );

      // Navigate to the HealthForm screen with the updated email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HealthForm(userEmail: currentUserEmail)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Health Profile Builder",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: _selectedImageFile != null
                  ? FileImage(_selectedImageFile!)
                  : null,
              child: _selectedImageFile == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            TextButton(
              onPressed: _pickImage,
              child: const Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildEditableField("Age", ageController, TextInputType.number),
            buildGenderDropdown(),
            buildEditableField(
                "Height (Feet)", feetController, TextInputType.number),
            buildEditableField(
                "Height (Inches)", inchesController, TextInputType.number),
            buildEditableField("Weight", weightController, TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: const [
          DropdownMenuItem(child: Text("Male"), value: "Male"),
          DropdownMenuItem(child: Text("Female"), value: "Female"),
        ],
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
