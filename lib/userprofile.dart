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
    String emailKey = email.replaceAll('.', '_');

    final snapshot = await _databaseReference.child('Users').child(emailKey).get();

    if (snapshot.exists) {
      setState(() {
        userData = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  void _updateUserData(String key, dynamic value) async {
    String emailKey = widget.userEmail.replaceAll('.', '_');
    await _databaseReference.child('Users').child(emailKey).update({key: value});
  }

  // List of professions
  final List<String> professions = [
    'Office and Administrative Jobs',
    'Manual Labor and Skilled Trades',
    'Health and Medical Professions',
    'Education and Training',
    'Creative and Design Professions',
  ];

  // List of alcohol consumption options
  final List<String> alcoholConsumptionOptions = ['None', 'Frequent'];

  // List of smoking habits options
  final List<String> smokingHabitsOptions = ['None', 'Frequent'];

  // List of exercise levels
  final List<String> exerciseLevels = ['None', 'Light', 'Moderate', 'Intense'];

  // List of sleep patterns
  final List<String> sleepPatterns = [
    'Less than 6 hrs',
    '6–7 hrs',
    '7–9 hrs',
    '10+ hrs'
  ];

  // Show Gender Selection Modal
  void _showGenderSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Your Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    userData!['gender'] = 'Male';
                  });
                  _updateUserData('gender', 'Male');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    userData!['gender'] = 'Female';
                  });
                  _updateUserData('gender', 'Female');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Profession Selection Modal
  void _showProfessionSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Your Profession', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: professions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(professions[index]),
                      onTap: () {
                        setState(() {
                          userData!['profession'] = professions[index];
                        });
                        _updateUserData('profession', professions[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Alcohol Consumption Modal
  void _showAlcoholConsumptionSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Alcohol Consumption', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('None'),
                onTap: () {
                  setState(() {
                    userData!['alcoholConsumption'] = 'None';
                  });
                  _updateUserData('alcoholConsumption', 'None');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Frequent'),
                onTap: () {
                  setState(() {
                    userData!['alcoholConsumption'] = 'Frequent';
                  });
                  _updateUserData('alcoholConsumption', 'Frequent');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Smoking Habits Modal
  void _showSmokingHabitsSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Smoking Habits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('None'),
                onTap: () {
                  setState(() {
                    userData!['smokingHabits'] = 'None';
                  });
                  _updateUserData('smokingHabits', 'None');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Frequent'),
                onTap: () {
                  setState(() {
                    userData!['smokingHabits'] = 'Frequent';
                  });
                  _updateUserData('smokingHabits', 'Frequent');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Exercise Level Modal
  void _showExerciseLevelSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Exercise Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: exerciseLevels.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(exerciseLevels[index]),
                      onTap: () {
                        setState(() {
                          userData!['exerciseLevel'] = exerciseLevels[index];
                        });
                        _updateUserData('exerciseLevel', exerciseLevels[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Sleep Pattern Modal
  void _showSleepPatternSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Sleep Pattern', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sleepPatterns.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(sleepPatterns[index]),
                      onTap: () {
                        setState(() {
                          userData!['sleepPattern'] = sleepPatterns[index];
                        });
                        _updateUserData('sleepPattern', sleepPatterns[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
            color: Colors.grey.withOpacity(0.4),
          ),
          // Profile Details Over the Background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: userData != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Adds space for the transparent AppBar
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userData!['profileImageUrl'] != null
                      ? NetworkImage(userData!['profileImageUrl'])
                      : null, // Use NetworkImage if there's a profileImageUrl
                  child: userData!['profileImageUrl'] == null
                      ? const Icon(Icons.person, size: 60)
                      : null, // Default icon when no profile image
                ),
                const SizedBox(height: 16),
                Text(
                  userData!['fullName'] ?? 'Full Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userData!['email'] ?? 'Email',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      UserInfoField(
                        label: 'Age',
                        value: userData!['age'].toString(),
                        onTap: _showGenderSelection,
                      ),
                      UserInfoField(
                        label: 'Gender',
                        value: userData!['gender'] ?? 'Not specified',
                        onTap: _showGenderSelection,
                      ),
                      UserInfoField(
                        label: 'Height',
                        value: '${userData!['height_feet']} ft ${userData!['height_inches']} in' ?? 'Not specified',
                        onTap: _showGenderSelection,
                      ),
                      UserInfoField(
                        label: 'Weight',
                        value: '${userData!['weight']} kg' ?? 'Not specified',
                        onTap: _showGenderSelection,
                      ),
                      UserInfoField(
                        label: 'Profession',
                        value: userData!['profession'] ?? 'Not specified',
                        onTap: _showProfessionSelection,
                      ),
                      UserInfoField(
                        label: 'Alcohol Consumption',
                        value: userData!['alcoholConsumption'] ?? 'Not specified',
                        onTap: _showAlcoholConsumptionSelection,
                      ),
                      UserInfoField(
                        label: 'Smoking Habits',
                        value: userData!['smokingHabits'] ?? 'Not specified',
                        onTap: _showSmokingHabitsSelection,
                      ),
                      UserInfoField(
                        label: 'Exercise Level',
                        value: userData!['exerciseLevel'] ?? 'Not specified',
                        onTap: _showExerciseLevelSelection,
                      ),
                      UserInfoField(
                        label: 'Sleep Pattern',
                        value: userData!['sleepPattern'] ?? 'Not specified',
                        onTap: _showSleepPatternSelection,
                      ),
                    ],
                  ),
                ),
              ],
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const UserInfoField({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
