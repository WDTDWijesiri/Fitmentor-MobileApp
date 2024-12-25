import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfile extends StatefulWidget {
  final String userEmail;

  const UserProfile({Key? key, required this.userEmail}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(widget.userEmail);
  }

  void _fetchUserDetails(String email) async {
    // Replace dots with underscores in email as shown in the database structure
    String emailKey = email.replaceAll('.', '_');

    // Query Firebase Realtime Database to get user details by email key
    final snapshot = await _databaseReference.child('Users').child(emailKey).get();

    if (snapshot.exists) {
      setState(() {
        userData = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Makes the app bar transparent
      ),
      extendBodyBehindAppBar: true, // Extends the body behind the AppBar
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Wavy_Bus-08_Single-05.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with gray color and 0.6 opacity
          Container(
            color: Colors.grey.withOpacity(0.6),
          ),
          // Profile Details Over the Background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: userData != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Adds space for the transparent app bar
                // Profile Picture with Edit Button
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200], // Placeholder background color
                      child: const Icon(Icons.person, size: 50, color: Colors.grey), // Placeholder Icon
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Edit action here
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // User Profile Information
                UserInfoField(label: 'Age', value: userData!['age'].toString()),
                const SizedBox(height: 10),
                UserInfoField(label: 'Gender', value: userData!['gender']),
                const SizedBox(height: 10),
                UserInfoField(label: 'Height', value: '${userData!['height_feet']} ft ${userData!['height_inches']} in'),
                const SizedBox(height: 10),
                UserInfoField(label: 'Weight', value: '${userData!['weight']} kg'),
                const SizedBox(height: 10),
                UserInfoField(label: 'Profession', value: '${userData!['profession']} '),
                const SizedBox(height: 10),
                UserInfoField(label: 'AlcoholConsumption', value: '${userData!['alcoholConsumption']} '),
                const SizedBox(height: 10),
                UserInfoField(label: 'ExerciseLevel', value: '${userData!['exerciseLevel']} '),
                const SizedBox(height: 10),
                UserInfoField(label: 'SmokingHabits', value: '${userData!['smokingHabits']} '),
                const SizedBox(height: 10),
                UserInfoField(label: 'sleepPattern', value: '${userData!['sleepPattern']} '),
                const SizedBox(height: 10),
              ],
            )
                : const Center(child: CircularProgressIndicator()), // Show loading indicator while fetching
          ),
        ],
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200]?.withOpacity(0.8), // Semi-transparent background for the input field
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
