import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Checks if a user with the given email already exists
  Future<bool> checkUserExists(String email) async {
    final snapshot = await _dbRef.child('users').orderByChild('email').equalTo(email).get();
    return snapshot.value != null;
  }

  /// Inserts a new user with default fields
  Future<void> insertUser(String email, String password) async {
    final newUser = {
      'email': email,
      'password': password,
      'weight': null,
      'height': null,
      'gender': null,
      'age': null,
      'created_at': DateTime.now().toIso8601String(),
    };
    await _dbRef.child('users').push().set(newUser);
  }
}
