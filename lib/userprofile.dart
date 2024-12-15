import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100), // Adds space for the transparent app bar
                // Profile Picture with Edit Button
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200], // Placeholder background color
                      child: Icon(Icons.person, size: 50, color: Colors.grey), // Placeholder Icon
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Edit action here
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // User Profile Information
                UserInfoField(label: 'User name', value: 'supun maduranga'),
                SizedBox(height: 10),
                UserInfoField(label: 'Email', value: 'supunmaduranga@gmail.com'),
                SizedBox(height: 10),
                UserInfoField(label: 'Age', value: '23'),
                SizedBox(height: 10),
                UserInfoField(label: 'Gender', value: 'Male'),
                SizedBox(height: 10),
                UserInfoField(label: 'Height', value: '5ft, 7in'),
                SizedBox(height: 10),
                UserInfoField(label: 'Weight', value: '55kg'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  final String label;
  final String value;

  UserInfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200]?.withOpacity(0.8), // Semi-transparent background for the input field
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserProfile(),
  ));
}
